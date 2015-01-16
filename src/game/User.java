package game;

import io.netty.channel.ChannelHandlerContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.logging.Logger;

import network.Handler;
import packet.Packet;
import database.DataBase;
import database.GameData;

public class User {
	
	private Logger logger = Logger.getLogger(User.class.getName());
	private ChannelHandlerContext ctx;
	private int no;
	private String id;
	private String pass;
	private String name;
	private String mail;
	private String image;
	private String guild;
	private int job;
	private int pureStr;
	private int pureDex;
	private int pureAgi;
	private int statPoint;
	private int skillPoint;
	private int title;
	private int hp;
	private int mp;
	private int level;
	private int exp;
	private int gold;
	private int map;
	private int x;
	private int y;
	private int direction;
	private int speed;
	private boolean admin;
	
	private int weapon = 0;
	private int shield = 0;
	private int helmet = 0;
	private int armor = 0;
	private int cape = 0;
	private int shoes = 0;
	private int accessory = 0;
	
	private Hashtable<Integer, GameData.InventoryItem> inventory = new Hashtable<Integer, GameData.InventoryItem>();
	
	public User(ChannelHandlerContext ctx, int no, String id, String pass, String name, int title, String mail, String image, int job, 
				int str, int dex, int agi, int statPoint, int skillPoint, int hp, int mp, int level, int exp, int gold, int map, int x, 
				int y, int d, int speed, int admin) {
		this.ctx = ctx;
		this.no = no;
		this.id = id;
		this.pass = pass;
		this.name = name;
		this.title = title;
		this.guild = "";
		this.mail = mail;
		this.image = image;
		this.job = job;
		this.pureStr = str;
		this.pureDex = dex;
		this.pureAgi = agi;
		this.statPoint = statPoint;
		this.skillPoint = skillPoint;
		this.hp = hp;
		this.mp = mp;
		this.level = level;
		this.exp = exp;
		this.map = map;
		this.gold = gold;
		this.x = x;
		this.y = y;
		this.direction = d;
		this.speed = speed;
		this.admin = admin == 0 ? false : true;

		// 0번 인덱스에 빈 아이템 넣음
		inventory.put(0, new GameData.InventoryItem(no, 0, 0, 0, 0));
	}
	
	public ChannelHandlerContext getCtx() {
		return ctx;
	}
	
	public int getNo() {
		return no;
	}
	
	public String getID() {
		return id;
	}
	
	public String getPass() {
		return pass;
	}
	
	public String getName() {
		return name;
	}
	
	public int getTitle() {
		return title;
	}

	public void setTitle(int t) {
		title = t;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.TITLE, t));
	}
	
	public String getGuild() {
		return guild;
	}
	
	public String getMail() {
		return mail;
	}
	
	public String getImage() {
		return image;
	}

	public void setImage(String i) {
		image = i;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.IMAGE, i));
	}
	
	public int getJob() {
		return job;
	}

	public void setJob(int j) {
		job = j;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.JOB, j));
	}
	
	public int getStr() {
		int n = 0;
		// 스텟 Str
		n += pureStr;
		// 직업 기본 Str
		n += GameData.job.get(job).getStr() * level;
		// 아이템으로 오르는 Str
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getStr();
		// 아이템 추가 능력치로 오르는 Str
		n += findItemByIndex(weapon).getStr();
		n += findItemByIndex(shield).getStr();
		n += findItemByIndex(helmet).getStr();
		n += findItemByIndex(armor).getStr();
		n += findItemByIndex(cape).getStr();
		n += findItemByIndex(shoes).getStr();
		n += findItemByIndex(accessory).getStr();
		
		return n;
	}
	
	public int getPureStr() {
		return pureStr;
	}
	
	public int getDex() {
		int n = 0;
		// 스텟 Dex
		n += pureDex;
		// 직업 기본 Dex
		n += GameData.job.get(job).getDex() * level;
		// 아이템으로 오르는 Dex
		n += GameData.item.get(weapon).getDex();
		n += GameData.item.get(shield).getDex();
		n += GameData.item.get(helmet).getDex();
		n += GameData.item.get(armor).getDex();
		n += GameData.item.get(cape).getDex();
		n += GameData.item.get(shoes).getDex();
		n += GameData.item.get(accessory).getDex();
		// 아이템 추가 능력치로 오르는 Dex
		n += findItemByIndex(weapon).getDex();
		n += findItemByIndex(shield).getDex();
		n += findItemByIndex(helmet).getDex();
		n += findItemByIndex(armor).getDex();
		n += findItemByIndex(cape).getDex();
		n += findItemByIndex(shoes).getDex();
		n += findItemByIndex(accessory).getDex();
		return n;
	}
	
	public int getPureDex() {
		return pureDex;
	}
	
	public int getAgi() {
		int n = 0;
		// 스텟 Agi
		n += pureAgi;
		// 직업 기본 Agi
		n += GameData.job.get(job).getAgi() * level;
		// 아이템으로 오르는 Agi
		n += GameData.item.get(weapon).getAgi();
		n += GameData.item.get(shield).getAgi();
		n += GameData.item.get(helmet).getAgi();
		n += GameData.item.get(armor).getAgi();
		n += GameData.item.get(cape).getAgi();
		n += GameData.item.get(shoes).getAgi();
		n += GameData.item.get(accessory).getAgi();
		// 아이템 추가 능력치로 오르는 Agi
		n += findItemByIndex(weapon).getAgi();
		n += findItemByIndex(shield).getAgi();
		n += findItemByIndex(helmet).getAgi();
		n += findItemByIndex(armor).getAgi();
		n += findItemByIndex(cape).getAgi();
		n += findItemByIndex(shoes).getAgi();
		n += findItemByIndex(accessory).getAgi();
		return n;
	}
	
	public int getPureAgi() {
		return pureAgi;
	}

	public int getHp() {
		return hp;
	}

	public void gainHp(int value) {
		if (hp + value > getMaxHp()) {
			value = getMaxHp() - hp;
		}

		hp += value;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.HP, hp));
	}

	public void loseHp(int value) {
		if (hp - value < 0) {
			// 쥬금
			return;
		}

		gainHp(-value);
	}
	
	public int getMaxHp() {
		int n = 0;
		// 직업 기본 Hp
		n += GameData.job.get(job).getHp() * level;
		// 아이템으로 오르는 Hp
		n += GameData.item.get(weapon).getHp();
		n += GameData.item.get(shield).getHp();
		n += GameData.item.get(helmet).getHp();
		n += GameData.item.get(armor).getHp();
		n += GameData.item.get(cape).getHp();
		n += GameData.item.get(shoes).getHp();
		n += GameData.item.get(accessory).getHp();
		// 아이템 추가 능력치로 오르는 Hp
		n += findItemByIndex(weapon).getHp();
		n += findItemByIndex(shield).getHp();
		n += findItemByIndex(helmet).getHp();
		n += findItemByIndex(armor).getHp();
		n += findItemByIndex(cape).getHp();
		n += findItemByIndex(shoes).getHp();
		n += findItemByIndex(accessory).getHp();

		return n;
	}

	public int getMp() {
		return mp;
	}

	public void gainMp(int value) {
		if (mp + value > getMaxMp()) {
			value = getMaxMp() - mp;
		}

		mp += value;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.MP, mp));
	}

	public boolean loseMp(int value) {
		if (mp - value < 0) {
			return false;
		}
		gainMp(-value);
		return true;
	}
	
	public int getMaxMp() {
		int n = 0;
		// 직업 기본 Mp
		n += GameData.job.get(job).getMp() * level;
		// 아이템으로 오르는 Mp
		n += GameData.item.get(weapon).getMp();
		n += GameData.item.get(shield).getMp();
		n += GameData.item.get(helmet).getMp();
		n += GameData.item.get(armor).getMp();
		n += GameData.item.get(cape).getMp();
		n += GameData.item.get(shoes).getMp();
		n += GameData.item.get(accessory).getMp();
		// 아이템 추가 능력치로 오르는 Mp
		n += findItemByIndex(weapon).getMp();
		n += findItemByIndex(shield).getMp();
		n += findItemByIndex(helmet).getMp();
		n += findItemByIndex(armor).getMp();
		n += findItemByIndex(cape).getMp();
		n += findItemByIndex(shoes).getMp();
		n += findItemByIndex(accessory).getMp();
		
		return n;
	}
	
	public int getCritical() {
		int n = 0;
		// 아이템으로 오르는 Critical
		n += GameData.item.get(weapon).getCritical();
		n += GameData.item.get(shield).getCritical();
		n += GameData.item.get(helmet).getCritical();
		n += GameData.item.get(armor).getCritical();
		n += GameData.item.get(cape).getCritical();
		n += GameData.item.get(shoes).getCritical();
		n += GameData.item.get(accessory).getCritical();
		// 아이템 추가 능력치로 오르는 Critical
		n += findItemByIndex(weapon).getCritical();
		n += findItemByIndex(shield).getCritical();
		n += findItemByIndex(helmet).getCritical();
		n += findItemByIndex(armor).getCritical();
		n += findItemByIndex(cape).getCritical();
		n += findItemByIndex(shoes).getCritical();
		n += findItemByIndex(accessory).getCritical();
		
		return n;
	}
	
	public int getAvoid() {
		int n = 0;
		// 아이템으로 오르는 Avoid
		n += GameData.item.get(weapon).getAvoid();
		n += GameData.item.get(shield).getAvoid();
		n += GameData.item.get(helmet).getAvoid();
		n += GameData.item.get(armor).getAvoid();
		n += GameData.item.get(cape).getAvoid();
		n += GameData.item.get(shoes).getAvoid();
		n += GameData.item.get(accessory).getAvoid();
		// 아이템 추가 능력치로 오르는 Avoid
		n += findItemByIndex(weapon).getAvoid();
		n += findItemByIndex(shield).getAvoid();
		n += findItemByIndex(helmet).getAvoid();
		n += findItemByIndex(armor).getAvoid();
		n += findItemByIndex(cape).getAvoid();
		n += findItemByIndex(shoes).getAvoid();
		n += findItemByIndex(accessory).getAvoid();

		return n;
	}
	
	public int getHit() {
		int n = 0;
		// 아이템으로 오르는 Hit
		n += GameData.item.get(weapon).getHit();
		n += GameData.item.get(shield).getHit();
		n += GameData.item.get(helmet).getHit();
		n += GameData.item.get(armor).getHit();
		n += GameData.item.get(cape).getHit();
		n += GameData.item.get(shoes).getHit();
		n += GameData.item.get(accessory).getHit();
		// 아이템 추가 능력치로 오르는 Hit
		n += findItemByIndex(weapon).getHit();
		n += findItemByIndex(shield).getHit();
		n += findItemByIndex(helmet).getHit();
		n += findItemByIndex(armor).getHit();
		n += findItemByIndex(cape).getHit();
		n += findItemByIndex(shoes).getHit();
		n += findItemByIndex(accessory).getHit();

		return n;
	}
	
	public int getLevel() {
		return level;
	}
	
	public int getExp() {
		return exp;
	}

	public int getMaxExp() {
		int n = 0;
		n += level * level * 10;

		return n;
	}

	public void gainExp(int value) {
		int maxExp = getMaxExp();
		exp += value;

		if (exp >= maxExp) {
			exp = 0;
			level++;
			statPoint += 5;
			skillPoint += 1;

			ctx.write(Packet.updateStatus(GameData.StatusType.LEVEL, level));
			ctx.write(Packet.updateStatus(GameData.StatusType.STAT_POINT, statPoint));
			ctx.write(Packet.updateStatus(GameData.StatusType.SKILL_POINT, skillPoint));
			ctx.write(Packet.updateStatus(GameData.StatusType.MAX_EXP, getMaxExp()));
		}

		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.EXP, exp));
	}

	public void loseExp(int value) {
		if (exp - value < 0) {
			value = exp;
		}
		gainExp(-value);
	}

	public int getGold() {
		return gold;
	}

	public void gainGold(int value) {
		gold += value;

		//
	}

	public boolean loseGold(int value) {
		if (gold < value) {
			return false;
		}
		gainGold(-value);
		return true;
	}
	
	public int getMap() {
		return map;
	}
	
	public int getX() {
		return x;
	}
	
	public int getY() {
		return y;
	}
	
	public int getDirection() {
		return direction;
	}
	
	public int getSpeed() {
		return speed;
	}
	
	public int getStatPoint() {
		return statPoint;
	}
	
	public int getSkillPoint() {
		return skillPoint;
	}
	
	public boolean isAdmin() {
		return admin;
	}

	public int getWeapon() {
		return weapon;
	}
	
	public int getShield() {
		return shield;
	}
	
	public int getHelmet() {
		return helmet;
	}
	
	public int getArmor() {
		return armor;
	}
	
	public int getCape() {
		return cape;
	}
	
	public int getShoes() {
		return shoes;
	}
	
	public int getAccessory() {
		return accessory;
	}
	
	public void loadData() {
		loadEquipItem();
		loadInventory();
	}
	
	// 장착한 아이템 불러오기
	public void loadEquipItem() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `equip` WHERE `user_no` = '" + no + "';");
    	
	    	if (rs.next()) {
	    		weapon = rs.getInt("weapon");
	    		shield = rs.getInt("shield");
	    		helmet = rs.getInt("helmet");
	    		armor = rs.getInt("armor");
	    		cape = rs.getInt("cape");
	    		shoes = rs.getInt("shoes");
	    		accessory = rs.getInt("accessory");
	    	}
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 인벤토리 불러오기
	public void loadInventory() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `inventory` WHERE `user_no` = '" + no + "';");
    	
	    	while (rs.next()) {
	    		inventory.put(rs.getInt("index"), 
				    				new GameData.InventoryItem(
				    				rs.getInt("user_no"),
				    				rs.getInt("item_no"),
				    				rs.getInt("amount"),
				    				rs.getInt("index"),
				    				rs.getInt("damage"),
				    				rs.getInt("magic_damage"),
				    				rs.getInt("defense"),
				    				rs.getInt("magic_defense"),
				    				rs.getInt("str"),
				    				rs.getInt("dex"),
				    				rs.getInt("agi"),
				    				rs.getInt("hp"),
				    				rs.getInt("mp"),
				    				rs.getInt("critical"),
				    				rs.getInt("avoid"),
				    				rs.getInt("hit"),
				    				rs.getInt("reinforce"),
				    				rs.getInt("trade")));

	    		ctx.writeAndFlush(Packet.setInventory(inventory.get(rs.getInt("index"))));
	    	}
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
		
	}
	
	// 아이템 장착
	public void equipItem(int type, int index) {
		switch (type) {
		case GameData.ItemType.WEAPON:
			weapon = index;
			break;
		case GameData.ItemType.SHIELD:
			shield = index;
			break;
		case GameData.ItemType.HELMET:
			helmet = index;
			break;
		case GameData.ItemType.ARMOR:
			armor = index;
			break;
		case GameData.ItemType.CAPE:
			cape = index;
			break;
		case GameData.ItemType.SHOES:
			shoes = index;
			break;
		case GameData.ItemType.ACCESSORY:
			accessory = index;
			break;
		}
	}
	
	public void useStatPoint(int stat) {
		if (statPoint <= 0) {
			return;
		}
		
		switch (stat) {
			case GameData.StatusType.STR:
				pureStr++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getStr()));
				break;
			case GameData.StatusType.DEX:
				pureDex++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getDex()));
				break;
			case GameData.StatusType.AGI:
				pureAgi++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getAgi()));
				break;
			default:
				return;
		}

		statPoint--;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.STAT_POINT, statPoint));
	}

	// NPC로부터 아이템 획득 (번호만으로 아이템 획득)
	public void gainItem(int no, int num) {
		int index = getEmptyIndex();
		GameData.Item i = GameData.item.get(no);

		// 새로 얻은 아이템일 경우
		if (findItemByNo(no) == null) {
			if (index == -1) {
				return;
			}
			inventory.put(index, new GameData.InventoryItem(no, no, num, index, i.isTradeable() ? 1 : 0));
		} else {
			// 이미 있던 아이템일 경우
			int gap = findItemByNo(no).getAmount() + num - i.getMaxLoad();
			findItemByNo(no).setUpAmount(num);
			if (gap > 0) {
				if (index == -1) {
					// gap만큼 아이템 드랍한다
					return;
				} else {
					inventory.put(index, new GameData.InventoryItem(no, no, gap, index, i.isTradeable() ? 1 : 0));
				}
			}
		}
	}
	
	// No로 아이템 제거
	public void loseItemByNo(int no, int num) {
		if (no == 0 || num < 0) {
			return;
		}
		
		int gap = 0;
		GameData.InventoryItem i = null;
		do {
			i = findItemByNo(no);
			if (i != null) {
				gap = i.getAmount() - num;
				i.setUpAmount(-num);
				if (i.getAmount() == 0) {
					inventory.remove(i.getIndex());
				}
				num = gap;
			} else {
				break;
			}
		} while (num < 0);
	}
	
	// Index로 아이템 제거
	public void loseItemByIndex(int index, int num) {
		GameData.InventoryItem i = findItemByIndex(index);
		if (i != null) {
			i.setUpAmount(-num);
			if (i.getAmount() == 0) {
				inventory.remove(i.getIndex());
			}
		}
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 0; i < 35; i++) {
			if (!inventory.containsKey(i))
				return i;
		}
		
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getTotalItemAmount(int no) {
		int num = 0;
		for (GameData.InventoryItem item : inventory.values()) {
			if (item.getItemNo() == no)
				num += item.getAmount();
		}
		
		return num;
	}
	
	// Index로 아이템 검색
	public GameData.InventoryItem findItemByIndex(int index) {
		if (!inventory.containsKey(index))
			return null;
		
		return inventory.get(index);
	}
	
	// No로 아이템 검색
	public GameData.InventoryItem findItemByNo(int no) {
		for (GameData.InventoryItem item : inventory.values()) {
			if (item.getItemNo() == no)
				return item;
		}
		
		return null;
	}

	public void turnUp() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.UP;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnDown() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.DOWN;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnLeft() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.LEFT;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnRight() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.RIGHT;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}
	
	public void moveUp() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.UP;

		if (gameMap.isPassable(x, y - 1)) {
			y -= 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveDown() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.DOWN;

		if (gameMap.isPassable(x, y + 1)) {
			y += 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveLeft() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.LEFT;

		if (gameMap.isPassable(x - 1, y)) {
			x -= 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveRight() {
		Map gameMap = Handler.getMap().get(map);
		direction = GameData.Direction.RIGHT;

		if (gameMap.isPassable(x + 1, y)) {
			x += 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
}
