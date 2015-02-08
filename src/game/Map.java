package game;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

import database.GameData;
import database.Type;
import org.json.simple.JSONObject;

import packet.Packet;

public class Map {
	private int no;
	private String name;
	private int width;
	private int height;
	private int[] data;
	private Random random;

	public Vector<User> users = new Vector<User>();
	public Vector<Enemy> enemies = new Vector<Enemy>();
	public Hashtable<Integer, NPC> npcs = new Hashtable<Integer, NPC>();
	public Vector<DropItem> dropItems = new Vector<DropItem>();
	public Vector<DropGold> dropGolds = new Vector<DropGold>();

	private static Hashtable<Integer, Map> maps = new Hashtable<Integer, Map>();
	private static Logger logger = Logger.getLogger(Map.class.getName());

	public Map(String fileName) {
		random = new Random();

		loadMapData(fileName);
		loadTroops();
		loadNPCs();
	}

	// 맵을 얻음
	public static Map get(int no) {
		return maps.get(no);
	}

	// 모든 맵을 얻음
	public static Hashtable<Integer, Map> getAll() {
		return maps;
	}

	// 모든 맵을 로드
	public static void loadMap(int num) {
		for (int i = 1; i <= num; i++) {
			maps.put(i, new Map("./Map/MAP" + i + ".map"));
		}

		logger.info("맵 로드 완료.");
	}

	// 맵 데이터 로드
	private void loadMapData(String fileName) {
		try {
			FileReader fr = new FileReader(fileName);
			BufferedReader br = new BufferedReader(fr);
			String read = br.readLine();
			String[] readData = read.split(",");
			no = Integer.parseInt(readData[0]);
			name = readData[1];
			width = Integer.parseInt(readData[2]);
			height = Integer.parseInt(readData[3]);
			data = new int[width * height];
			for (int y = 0; y < height; y++) {
				for (int x = 0; x < width; x++) {
					data[width * y + x] = Integer.parseInt(readData[width * y + x + 4]);
				}
			}

			br.close();
			fr.close();
		} catch (IOException e) {
			logger.warning(e.getMessage());
		}
	}

	// Enemy 로드
	private void loadTroops() {
		for (GameData.Troop troop : GameData.troop.values()) {
			if (troop.getMap() == no) {
				for (int i = 0; i < troop.getNum(); i++) {
					int x = troop.getX() - troop.getRange() / 2;
					int y = troop.getY() - troop.getRange() / 2;
					do {
						x += random.nextInt(troop.getRange());
						y += random.nextInt(troop.getRange());
					} while (!isPassable(null, x, y));
					enemies.addElement(new Enemy(enemies.size(), x, y, troop));
				}
			}
		}
		logger.info(no + "번 맵 에너미 등록 완료");
	}

	// NPC 로드
	private void loadNPCs() {
		for (GameData.NPC npc : GameData.npc.values()) {
			if (npc.getMap() == no) {
				npcs.put(npc.getNo(), new NPC(npc));
			}
		}
		logger.info(no + "번 맵 NPC 등록 완료");
	}
	
	private boolean isValid(int x, int y) {
		return x >= 0 && y >= 0 && x < width && y < height;
	}

	public boolean isPassable(Character c, int x, int y) {
		if (!isValid(x, y))
			return false;

		if (data[width * y + x] == 1)
			return false;

		for (User other : users) {
			if (other.equals(c))
				continue;
			if (other.getSeed() == (c == null ? 0 : c.getSeed()) && other.x == x && other.y == y)
				return false;
		}

		for (Enemy other : getAliveEnemies()) {
			if (other.equals(c))
				continue;
			if (other.getSeed() == (c == null ? 0 : c.getSeed()) && other.x == x && other.y == y)
				return false;
		}

		for (NPC other : npcs.values()) {
			if (other.equals(c))
				continue;
			if (other.getSeed() == (c == null ? 0 : c.getSeed()) && other.x == x && other.y == y)
				return false;
		}

		return true;
	}

	public boolean isIsolated(Character c) {
		int blocked = 0;
		for (int i = 0; i < 4; i++) {
			int x = c.getX() + (i == 0 ? -1 : i == 2 ? + 1 : 0);
			int y = c.getY() + (i == 1 ? -1 : i == 3 ? + 1 : 0);

			if (!isValid(x, y))
				blocked += 1;
			else if (data[width * y + x] == 1)
				blocked += 1;

			for (User other : users)
				if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
					blocked += 1;

			for (Enemy other : enemies)
				if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
					blocked += 1;

			for (NPC other : npcs.values()) {
				if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
					blocked += 1;
			}
		}

		return blocked >= 4;
	}
	
	public void addUser(User u) {
		for (User other : users) {
			if (other.getSeed() == u.getSeed()) {
				other.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, u));
				u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, other));
			}
		}

		for (Enemy other : getAliveEnemies()) {
			if (other.getSeed() == u.getSeed()) {
				u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.ENEMY, other));
			}
		}

		for (NPC other : npcs.values()) {
			if (other.getSeed() == u.getSeed()) {
				u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.NPC, other));
			}
		}

		for (DropItem item : dropItems) {
			if (item.getSeed() == u.getSeed()) {
				u.getCtx().writeAndFlush(Packet.loadDropItem(item));
			}
		}

		users.addElement(u);
	}
	
	public void removeUser(User u) {
		for (User other : users) {
			if (other.equals(u) || other.getSeed() != u.getSeed())
				continue;

			other.getCtx().writeAndFlush(Packet.removeCharacter(Type.Character.USER, u.getName(), u.getNo()));
		}

		users.removeElement(u);
	}

	public Vector<Enemy> getAliveEnemies() {
		Vector<Enemy> aliveEnemies = new Vector<Enemy>();

		for (Enemy enemy : enemies) {
			if (enemy.isAlive())
				aliveEnemies.addElement(enemy);
		}

		return aliveEnemies;
	}

	public void loadDropItem(int seed, int itemNo, int num, int x, int y) {
		DropItem item = new DropItem(seed, dropItems.size(), itemNo, num, x, y);
		dropItems.addElement(item);
		sendToAll(seed, Packet.loadDropItem(item));
	}

	public void update() {
		for (Enemy e : enemies) {
			e.update();
		}
	}

	public void sendToAll(int seed, JSONObject msg) {
		for (User other : users) {
			if (other.getSeed() == seed)
				other.getCtx().writeAndFlush(msg);
		}
	}

	public void sendToOthers(int no, int seed, JSONObject msg) {
		for (User other : users) {
			if (other.getNo() == no || other.getSeed() != seed)
				continue;

			other.getCtx().writeAndFlush(msg);
		}
	}

	public static class DropItem {
		private int no;
		private int itemNo;
		private int num;
		private int seed;
		private int x;
		private int y;
		private String image;

		public DropItem(int _seed, int _no, int _itemNo, int _num, int _x, int _y) {
			seed = _seed;
			no = _no;
			itemNo = _itemNo;
			num = _num;
			x = _x;
			y = _y;
			image = GameData.item.get(itemNo).getImage();
		}

		public int getNo() {
			return no;
		}

		public int getItemNo() {
			return itemNo;
		}

		public int getNum() {
			return num;
		}

		public int getSeed() {
			return seed;
		}

		public int getX() {
			return x;
		}

		public int getY() {
			return y;
		}

		public String getImage() {
			return image;
		}
	}

	public static class DropGold {
		private int amount;

		public DropGold(int _amount) {
			amount = _amount;
		}
	}
}