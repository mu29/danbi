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
	public static Hashtable<Integer, Troop> troop = new Hashtable<Integer, Troop>();
	private static Logger logger = Logger.getLogger(GameData.class.getName());

	public static void loadSettings() throws SQLException {
		ResultSet rs;

		rs = executeQuery("SELECT * FROM `setting_job`;");
		while (rs.next()) {
			job.put(rs.getInt("no"), new Job(rs));
		}
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

		rs = executeQuery("SELECT * FROM `troop`;");
		while (rs.next()) {
			troop.put(rs.getInt("no"), new Troop(rs));
		}
		logger.info("에너미 정보 로드 완료.");
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
		
		public Register(ResultSet rs) {
			try {
				job = rs.getInt("job");
				image = rs.getString("image");
				map = rs.getInt("map");
				x = rs.getInt("x");
				y = rs.getInt("y");
				level = rs.getInt("level");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getJob() {
			return job;
		}
		
		public String getImage() {
			return image;
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

		public int getLevel() {
			return level;
		}
		
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
		
		public Item(ResultSet rs) {
			try {
				no = rs.getInt("no");
				name = rs.getString("name");
				description = rs.getString("description");
				image = rs.getString("image");
				job = rs.getInt("job");
				level = rs.getInt("level");
				type = rs.getInt("type");
				price = rs.getInt("price");
				damage = rs.getInt("damage");
				magicDamage = rs.getInt("magic_damage");
				defense = rs.getInt("defense");
				magicDefense = rs.getInt("magic_defense");
				str = rs.getInt("str");
				dex = rs.getInt("dex");
				agi = rs.getInt("agi");
				hp = rs.getInt("hp");
				mp = rs.getInt("mp");
				critical = rs.getInt("critical");
				avoid = rs.getInt("avoid");
				hit = rs.getInt("hit");
				delay = rs.getInt("delay");
				consume = rs.getInt("consume") == 1;
				maxLoad = rs.getInt("max_load");
				trade = rs.getInt("trade") == 1;
				function = rs.getString("function");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getNo() {
			return no;
		}
		
		public String getName() {
			return name;
		}
		
		public String getDesc() {
			return description;
		}
		
		public String getImage() {
			return image;
		}
		
		public int getJob() {
			return job;
		}
		
		public int getLevel() {
			return level;
		}
		
		public int getType() {
			return type;
		}
		
		public int getPrice() {
			return price;
		}
		
		public int getDamage() {
			return damage;
		}
		
		public int getMagicDamage() {
			return magicDamage;
		}
		
		public int getDefense() {
			return defense;
		}
		
		public int getMagicDefense() {
			return magicDefense;
		}
		
		public int getStr() {
			return str;
		}
		
		public int getDex() {
			return dex;
		}
		
		public int getAgi() {
			return agi;
		}
		
		public int getHp() {
			return hp;
		}
		
		public int getMp() {
			return mp;
		}
		
		public int getCritical() {
			return critical;
		}
		
		public int getAvoid() {
			return avoid;
		}
		
		public int getHit() {
			return hit;
		}
		
		public int getDelay() {
			return delay;
		}
		
		public int getMaxLoad() {
			return maxLoad;
		}
		
		public boolean isConsumable() {
			return consume;
		}
		
		public boolean isTradeable() {
			return trade;
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

		public InventoryItem(ResultSet rs) {
			try {
				userNo = rs.getInt("user_no");
				itemNo = rs.getInt("item_no");
				amount = rs.getInt("amount");
				index = rs.getInt("index");
				damage = rs.getInt("damage");
				magicDamage = rs.getInt("magic_damage");
				defense = rs.getInt("defense");
				magicDefense = rs.getInt("magic_defense");
				str = rs.getInt("str");
				dex = rs.getInt("dex");
				agi = rs.getInt("agi");
				hp = rs.getInt("hp");
				mp = rs.getInt("mp");
				critical = rs.getInt("critical");
				avoid = rs.getInt("avoid");
				hit = rs.getInt("hit");
				reinforce = rs.getInt("reinforce");
				trade = rs.getInt("trade") == 1;
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}
		
		public InventoryItem(int _userNo, int _itemNo, int _amount, int _index, int _trade) {
			userNo = _userNo;
			itemNo = _itemNo;
			amount = _amount > GameData.item.get(itemNo).getMaxLoad() ? GameData.item.get(itemNo).getMaxLoad() : amount;
			index = _index;
			damage = 0;
			magicDamage = 0;
			defense = 0;
			magicDefense = 0;
			str = 0;
			dex = 0;
			agi = 0;
			hp = 0;
			mp = 0;
			critical = 0;
			avoid = 0;
			hit = 0;
			reinforce = 0;
			trade = _trade == 1;
		}

		public InventoryItem(int _userNo, int _itemNo, int _amount, int _index, int _damage, int _magicDamage, int _defense,
							 int _magicDefense, int _str, int _dex, int _agi, int _hp, int _mp, int _critical, int _avoid, int _hit,
							 int _reinforce, int _trade) {
			userNo = _userNo;
			itemNo = _itemNo;
			amount = _amount;
			index = _index;
			damage = _damage;
			magicDamage = _magicDamage;
			defense = _defense;
			magicDefense = _magicDefense;
			str = _str;
			dex = _dex;
			agi = _agi;
			hp = _hp;
			mp = _mp;
			critical = _critical;
			avoid = _avoid;
			hit = _hit;
			reinforce = _reinforce;
			trade = _trade == 1;
		}

		public int getUserNo() {
			return userNo;
		}

		public int getItemNo() {
			return itemNo;
		}

		public int getAmount() {
			return amount;
		}

		public int getIndex() {
			return index;
		}
		
		public int getDamage() {
			return damage;
		}
		
		public int getMagicDamage() {
			return magicDamage;
		}
		
		public int getDefense() {
			return defense;
		}
		
		public int getMagicDefense() {
			return magicDefense;
		}
		
		public int getStr() {
			return str;
		}
		
		public int getDex() {
			return dex;
		}
		
		public int getAgi() {
			return agi;
		}
		
		public int getHp() {
			return hp;
		}
		
		public int getMp() {
			return mp;
		}
		
		public int getCritical() {
			return critical;
		}
		
		public int getAvoid() {
			return avoid;
		}
		
		public int getHit() {
			return hit;
		}
		
		public int getReinforce() {
			return reinforce;
		}
		
		public boolean isTradeable() {
			return trade;
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

	public static class Troop {
		private int num;
		private int range;
		private int map;
		private ResultSet resultSet;
		private String query;

		public Troop(ResultSet rs) {
			try {
				num = rs.getInt("num");
				range = rs.getInt("range");
				map = rs.getInt("map");
				query = "SELECT * FROM `enemy` WHERE `no`='" + rs.getInt("no") + "';";
				resultSet = rs;
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public ResultSet getResultSet() {
			return resultSet;
		}

		public int getNum() {
			return num;
		}

		public int getRange() {
			return range;
		}
		public int getMap() {
			return map;
		}
	}
}
