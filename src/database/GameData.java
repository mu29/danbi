package database;

import network.Handler;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.logging.Logger;

public class GameData extends DataBase {

	public static Hashtable<Integer, Job> job = new Hashtable<Integer, Job>();
	public static Hashtable<Integer, Register> register = new Hashtable<Integer, Register>();
	public static Hashtable<Integer, Item> item = new Hashtable<Integer, Item>();
	private static Logger logger = Logger.getLogger(GameData.class.getName());

	public static void loadSettings() throws SQLException {
		ResultSet rs = executeQuery("SELECT * FROM `setting_job`;");
		while (rs.next()) {
			job.put(rs.getInt("no"), new Job(rs));
		}
		rs = null;
		logger.info("직업 정보 로드 완료.");
		
		rs = executeQuery("SELECT * FROM `setting_register`;");
		while (rs.next()) {
			register.put(rs.getInt("no"), new Register(rs));
		}
		logger.info("가입 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `item`;");
		while (rs.next()) {
			item.put(rs.getInt("no"), new Item(rs));
		}
		logger.info("아이템 정보 로드 완료.");
	}
	
	public static void load() {
		
	}

	public static class Job {
		private int no;
		private String name;
		private int hp;
		private int mp;
		private int str;
		private int dex;
		private int agi;
		
		public Job(ResultSet rs) throws SQLException {
			this.no = rs.getInt("no");
			this.name = rs.getString("name");
			this.hp = rs.getInt("hp");
			this.mp = rs.getInt("mp");
			this.str =rs.getInt("str");
			this.dex = 	rs.getInt("dex");
			this.agi = rs.getInt("agi");
		}
		
		public int getNo() {
			return this.no;
		}
		
		public String getName() {
			return this.name;
		}
		
		public int getHp() {
			return this.hp;
		}
		
		public int getMp() {
			return this.mp;
		}
		
		public int getStr() {
			return this.str;
		}
		
		public int getDex() {
			return this.dex;
		}
		
		public int getAgi() {
			return this.agi;
		}
	}

	public static class Register {
		
		private int job;
		private String image;
		private int map;
		private int x;
		private int y;
		private int level;
		
		public Register(ResultSet rs) throws SQLException {
			this.job = rs.getInt("job");
			this.image = rs.getString("image");
			this.map = rs.getInt("map");
			this.x = rs.getInt("x");
			this.y = rs.getInt("y");
			this.level = rs.getInt("level");
		}

		public int getJob() {
			return this.job;
		}
		
		public String getImage() {
			return this.image;
		}

		public int getMap() {
			return this.map;
		}

		public int getX() {
			return this.x;
		}

		public int getY() {
			return this.y;
		}

		public int getLevel() {
			return this.level;
		}
		
	}
	
	public static class Direction {
		public static final int DOWN = 2;
		public static final int LEFT = 4;
		public static final int RIGHT = 6;
		public static final int UP = 8;
	}

	public static class ItemType {
		public static final int WEAPON = 0;
		public static final int SHIELD = 1;
		public static final int HELMET = 2;
		public static final int ARMOR = 3;
		public static final int CAPE = 4;
		public static final int SHOES = 5;
		public static final int ACCESSORY = 6;
		public static final int ITEM = 7;
	}

	public static class StatusType {
		public static final int TITLE = 0;
		public static final int IMAGE = 1;
		public static final int JOB = 2;
		public static final int STR = 3;
		public static final int DEX = 4;
		public static final int AGI = 5;
		public static final int CRITICAL = 6;
		public static final int AVOID = 7;
		public static final int HIT = 8;
		public static final int STAT_POINT = 9;
		public static final int SKILL_POINT = 10;
		public static final int HP = 11;
		public static final int MAX_HP = 12;
		public static final int MP = 13;
		public static final int MAX_MP = 14;
		public static final int LEVEL = 15;
		public static final int EXP = 16;
		public static final int MAX_EXP = 17;
	}
	
	public static class Item {
		private int no;
		private String name;
		private String description;
		private String image;
		private int job;
		private int level;
		private int type;
		private int price;
		private int damage;
		private int magicDamage;
		private int defense;
		private int magicDefense;
		private int str;
		private int dex;
		private int agi;
		private int hp;
		private int mp;
		private int critical;
		private int avoid;
		private int hit;
		private int delay;
		private boolean consume;
		private int maxLoad;
		private boolean trade;
		private String function;
		
		public Item(ResultSet rs) throws SQLException {
			this.no = rs.getInt("no");
			this.name = rs.getString("name");
			this.description = rs.getString("description");
			this.image = rs.getString("image");
			this.job = rs.getInt("job");
			this.level = rs.getInt("level");
			this.type = rs.getInt("type");
			this.price = rs.getInt("price");
			this.damage = rs.getInt("damage");
			this.magicDamage = rs.getInt("magic_damage");
			this.defense = rs.getInt("defense");
			this.magicDefense = rs.getInt("magic_defense");
			this.str = rs.getInt("str");
			this.dex = rs.getInt("dex");
			this.agi = rs.getInt("agi");
			this.hp = rs.getInt("hp");
			this.mp = rs.getInt("mp");
			this.critical = rs.getInt("critical");
			this.avoid = rs.getInt("avoid");
			this.hit = rs.getInt("hit");
			this.delay = rs.getInt("delay");
			this.consume = rs.getInt("consume") == 1 ? true : false;
			this.maxLoad = rs.getInt("max_load");
			this.trade = rs.getInt("trade") == 1 ? true : false;
			this.function = rs.getString("function");
		}

		public int getNo() {
			return this.no;
		}
		
		public String getName() {
			return this.name;
		}
		
		public String getDesc() {
			return this.description;
		}
		
		public String getImage() {
			return this.image;
		}
		
		public int getJob() {
			return this.job;
		}
		
		public int getLevel() {
			return this.level;
		}
		
		public int getType() {
			return this.type;
		}
		
		public int getPrice() {
			return this.price;
		}
		
		public int getDamage() {
			return this.damage;
		}
		
		public int getMagicDamage() {
			return this.magicDamage;
		}
		
		public int getDefense() {
			return this.defense;
		}
		
		public int getMagicDefense() {
			return this.magicDefense;
		}
		
		public int getStr() {
			return this.str;
		}
		
		public int getDex() {
			return this.dex;
		}
		
		public int getAgi() {
			return this.agi;
		}
		
		public int getHp() {
			return this.hp;
		}
		
		public int getMp() {
			return this.mp;
		}
		
		public int getCritical() {
			return this.critical;
		}
		
		public int getAvoid() {
			return this.avoid;
		}
		
		public int getHit() {
			return this.hit;
		}
		
		public int getDelay() {
			return this.delay;
		}
		
		public int getMaxLoad() {
			return this.maxLoad;
		}
		
		public boolean isConsumable() {
			return this.consume;
		}
		
		public boolean isTradeable() {
			return this.trade;
		}
	}
	
	public static class InventoryItem {
		private int userNo;
		private int itemNo;
		private int amount;
		private int index;
		private int damage;
		private int magicDamage;
		private int defense;
		private int magicDefense;
		private int str;
		private int dex;
		private int agi;
		private int hp;
		private int mp;
		private int critical;
		private int avoid;
		private int hit;
		private int reinforce;
		private boolean trade;
		
		public InventoryItem(int userNo, int itemNo, int amount, int index, int trade) {
			this.userNo = userNo;
			this.itemNo = itemNo;
			this.amount = amount > GameData.item.get(itemNo).getMaxLoad() ? GameData.item.get(itemNo).getMaxLoad() : amount;
			this.index = index;
			this.damage = 0;
			this.magicDamage = 0;
			this.defense = 0;
			this.magicDefense = 0;
			this.str = 0;
			this.dex = 0;
			this.agi = 0;
			this.hp = 0;
			this.mp = 0;
			this.critical = 0;
			this.avoid = 0;
			this.hit = 0;
			this.reinforce = 0;
			this.trade = trade == 1 ? true : false;
		}
		
		public InventoryItem(int userNo, int itemNo, int amount, int index, int damage, int magicDamage, int defense, 
				int magicDefense, int str, int dex, int agi, int hp, int mp, int critical, int avoid, int hit,
				int reinforce, int trade) {
			this.userNo = userNo;
			this.itemNo = itemNo;
			this.amount = amount;
			this.index = index;
			this.damage = damage;
			this.magicDamage = magicDamage;
			this.defense = defense;
			this.magicDefense = magicDefense;
			this.str = str;
			this.dex = dex;
			this.agi = agi;
			this.hp = hp;
			this.mp = mp;
			this.critical = critical;
			this.avoid = avoid;
			this.hit = hit;
			this.reinforce = reinforce;
			this.trade = trade == 1 ? true : false;
		}

		public int getUserNo() {
			return this.userNo;
		}

		public int getItemNo() {
			return this.itemNo;
		}

		public int getAmount() {
			return this.amount;
		}

		public int getIndex() {
			return this.index;
		}
		
		public int getDamage() {
			return this.damage;
		}
		
		public int getMagicDamage() {
			return this.magicDamage;
		}
		
		public int getDefense() {
			return this.defense;
		}
		
		public int getMagicDefense() {
			return this.magicDefense;
		}
		
		public int getStr() {
			return this.str;
		}
		
		public int getDex() {
			return this.dex;
		}
		
		public int getAgi() {
			return this.agi;
		}
		
		public int getHp() {
			return this.hp;
		}
		
		public int getMp() {
			return this.mp;
		}
		
		public int getCritical() {
			return this.critical;
		}
		
		public int getAvoid() {
			return this.avoid;
		}
		
		public int getHit() {
			return this.hit;
		}
		
		public int getReinforce() {
			return this.reinforce;
		}
		
		public boolean isTradeable() {
			return this.trade;
		}
		
		public void setIndex(int value) {
			index = value;
		}
		
		public void changeAmount(int value) {
			if (amount + value > GameData.item.get(itemNo).getMaxLoad()) {
				amount = GameData.item.get(itemNo).getMaxLoad();
			} else if (amount + value < 0) {
				amount = 0;
			} else {
				amount += value;
			}
		}
	}

	public class Enemy {
		private int no;
		private String name;
		private String image;
		private int type;
		private int hp;
		private int maxHp;
		private int mp;
		private int maxMp;
		private int damage;
		private int magicDamage;
		private int defense;
		private int magicDefense;
		private int critical;
		private int avoid;
		private int hit;
		private int moveSpeed;
		private int attackSpeed;
		private int map;
		private int x;
		private int y;
		private int direction;
		private int regen;
		private int level;
		private int exp;
		private int gold;
		private int reward;
		private String function;
		private int frequency;
		private String die;

		public Enemy(ResultSet rs) throws SQLException {
			no = rs.getInt("no");
			name = rs.getString("name");
			image = rs.getString("image");
			type = rs.getInt("type");
			hp = rs.getInt("hp");
			maxHp = rs.getInt("hp");
			mp = rs.getInt("mp");
			maxMp = rs.getInt("mp");
			damage = rs.getInt("damage");
			magicDamage = rs.getInt("magic_damage");
			defense = rs.getInt("defense");
			magicDefense = rs.getInt("magic_defense");
			critical = rs.getInt("critical");
			avoid = rs.getInt("avoid");
			hit = rs.getInt("hit");
			moveSpeed = rs.getInt("move_speed");
			attackSpeed = rs.getInt("attack_speed");
			map = rs.getInt("map");
			x = rs.getInt("x");
			y = rs.getInt("y");
			direction = rs.getInt("direction");
			regen = rs.getInt("regen");
			level = rs.getInt("level");
			exp = rs.getInt("exp");
			gold = rs.getInt("gold");
			reward = rs.getInt("reward");
			function = rs.getString("function");
			frequency = rs.getInt("frequency");
			die = rs.getString("die");
		}
	}
}
