package game;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

import database.GameData;
import database.Type;
import org.json.simple.JSONObject;

import packet.Packet;

public class Map {

	private String texture;
	private int no;
	private String name;
	private int width;
	private int height;
	private int[] data;
	private Random random;
	
	private static Logger logger = Logger.getLogger(Map.class.getName());
	public Vector<User> user = new Vector<User>();
	public Vector<Enemy> enemy = new Vector<Enemy>();
	//public HashMap<String, NPC> NPC = new HashMap<String, NPC>();
	//public HashMap<String, DropGold> dropGold = new HashMap<String, DropGold>();
	//public HashMap<String, DropItem> dropItem = new HashMap<String, DropItem>();

	public Map(String fileName) {
		random = new Random();

		loadMapData(fileName);
		loadTroops();
	}

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

	private void loadTroops() {
		for (GameData.Troop troop : GameData.troop.values()) {
			if (troop.getMap() == no) {
				for (int i = 0; i < troop.getNum(); i++) {
					int x, y;
					do {
						x = random.nextInt(troop.getRange());
						y = random.nextInt(troop.getRange());
					} while (!isPassable(null, x, y));
					enemy.addElement(new Enemy(enemy.size(), x, y, troop.getResultSet()));
				}
				logger.info(no + "번 맵 에너미 등록 완료");
			}
		}
	}
	
	private boolean isValid(int x, int y) {
		int index = this.width * y + x;
		return index >= 0 && (index < width * height);
	}

	public boolean isPassable(Character c, int x, int y) {
		if (!isValid(x, y))
			return false;

		if (data[width * y + x] == 1)
			return false;

		for (User other : user) {
			if (other.equals(c))
				continue;
			if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
				return false;
		}

		for (Enemy other : enemy) {
			if (other.equals(c))
				continue;
			if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
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

			for (User other : user)
				if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
					blocked += 1;

			for (Enemy other : enemy)
				if (other.getSeed() == c.getSeed() && other.x == x && other.y == y)
					blocked += 1;
		}

		return blocked >= 4;
	}
	
	public void addUser(User u) {
		for (User other : user) {
			if (other.getSeed() == u.getSeed()) {
				other.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, u));
				u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, other));
			}
		}

		for (Enemy other : enemy) {
			if (other.getSeed() == u.getSeed()) {
				u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.ENEMY, other));
			}
		}
		user.addElement(u);
	}
	
	public void removeUser(User u) {
		for (User other : user) {
			if (other.equals(u) || other.getSeed() != u.getSeed())
				continue;

			other.getCtx().writeAndFlush(Packet.removeCharacter(Type.Character.USER, u.getName(), u.getNo()));
		}
		user.removeElement(u);
	}

	public void update() {
		for (Enemy e : enemy) {
			e.update();
		}
	}

	public void sendToAll(int seed, JSONObject msg) {
		for (User other : user) {
			if (other.getSeed() == seed)
				other.getCtx().writeAndFlush(msg);
		}
	}

	public void sendToOthers(int no, int seed, JSONObject msg) {
		for (User other : user) {
			if (other.getNo() == no || other.getSeed() != seed)
				continue;

			other.getCtx().writeAndFlush(msg);
		}
	}

}