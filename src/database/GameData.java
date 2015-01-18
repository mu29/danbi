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
			job.put(rs.getInt("no"), 
					new Job(rs.getInt("no"),
							rs.getString("name"),
							rs.getInt("hp"),
							rs.getInt("mp"),
							rs.getInt("str"),
							rs.getInt("dex"),
							rs.getInt("agi")));
		}
		rs = null;
		logger.info("직업 정보 로드 완료.");
		
		rs = executeQuery("SELECT * FROM `setting_register`;");
		while (rs.next()) {
			register.put(rs.getInt("no"),
					new Register(
					rs.getInt("job"),
					rs.getString("image"),
					rs.getInt("map"),
					rs.getInt("x"),
					rs.getInt("y"),
					rs.getInt("level")));
		}
		logger.info("가입 정보 로드 완료.");

		// 0번 인덱스에 빈 아이템 넣음
		item.put(0, new Item(0, "", "", "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null));
		rs = executeQuery("SELECT * FROM `item`;");
		while (rs.next()) {
			item.put(rs.getInt("no"), 
					new Item(
					rs.getInt("no"),
					rs.getString("name"),
					rs.getString("description"),
					rs.getString("image"),
					rs.getInt("job"),
					rs.getInt("level"),
					rs.getInt("type"),
					rs.getInt("price"),
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
					rs.getInt("delay"),
					rs.getInt("consume"),
					rs.getInt("max_load"),
					rs.getInt("trade"),
					rs.getString("function")));
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
		
		public Job(int no, String name, int hp, int mp, int str, int dex, int agi) {
			this.no = no;
			this.name = name;
			this.hp = hp;
			this.mp = mp;
			this.str = str;
			this.dex = dex;
			this.agi = agi;
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
		
		public Register(int job, String image, int map, int x, int y, int level) {
			this.job = job;
			this.image = image;
			this.map = map;
			this.x = x;
			this.y = y;
			this.level = level;
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
		
		public Item(int no, String name, String desc, String image, int job, int level, int type, int price, 
				int damage, int magicDamage, int defense, int magicDefense, int str, int dex, int agi, int hp, int mp, 
				int critical, int avoid, int hit, int delay, int consume, int maxLoad, int trade, String function) {
			this.no = no;
			this.name = name;
			this.description = desc;
			this.image = image;
			this.job = job;
			this.level = level;
			this.type = type;
			this.price = price;
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
			this.delay = delay;
			this.consume = consume == 1 ? true : false;
			this.maxLoad = maxLoad;
			this.trade = trade == 1 ? true : false;
			this.function = function;
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
	
}
