package database;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Logger;

public class GameData extends DataBase {

	public static Hashtable<Integer, Job> job = new Hashtable<Integer, Job>();
	public static Hashtable<Integer, Register> register = new Hashtable<Integer, Register>();
	public static Hashtable<Integer, ItemData> item = new Hashtable<Integer, ItemData>();
	public static Hashtable<Integer, SkillData> skill = new Hashtable<Integer, SkillData>();
	public static Hashtable<Integer, Troop> troop = new Hashtable<Integer, Troop>();
	public static Vector<Reward> reward = new Vector<Reward>();
	public static Hashtable<Integer, NPC> npc = new Hashtable<Integer, NPC>();
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

		rs = executeQuery("SELECT * FROM `setting_item`;");
		while (rs.next()) {
			item.put(rs.getInt("no"), new ItemData(rs));
		}
		logger.info("아이템 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_skill`;");
		while (rs.next()) {
			skill.put(rs.getInt("no"), new SkillData(rs));
		}
		logger.info("스킬 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_npc`;");
		while (rs.next()) {
			npc.put(rs.getInt("no"), new NPC(rs));
		}
		logger.info("NPC 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_reward`;");
		while (rs.next()) {
			reward.addElement(new Reward(rs));
		}
		logger.info("보상 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_troop`;");
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
	
	public static class ItemData {
		private int no;
		private String name;
		private String description;
		private String image;
		private int job;
		private int limitLevel;
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
		
		public ItemData(ResultSet rs) {
			try {
				no = rs.getInt("no");
				name = rs.getString("name");
				description = rs.getString("description");
				image = rs.getString("image");
				job = rs.getInt("job");
				limitLevel = rs.getInt("limit_level");
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
		
		public int getLimitLevel() {
			return limitLevel;
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

		public String getFunction() {
			return function;
		}
	}
	
	public static class Item {
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

		public Item(int _userNo, int _itemNo, int _amount, int _index, int _trade) {
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

		public Item(ResultSet rs) {
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

	public static class SkillData {
		private int no;
		private String name;
		private String description;
		private String type;
		private int job;
		private int delay;
		private int limitLevel;
		private int maxRank;
		private int userAnimation;
		private int targetAnimation;
		private String image;
		private String function;

		public SkillData(ResultSet rs) {
			try {
				no = rs.getInt("no");
				name = rs.getString("name");
				description = rs.getString("description");
				type = rs.getString("type");
				job = rs.getInt("job");
				delay = rs.getInt("delay");
				limitLevel = rs.getInt("limit_level");
				maxRank = rs.getInt("max_rank");
				userAnimation = rs.getInt("user_animation");
				targetAnimation = rs.getInt("target_animation");
				image = rs.getString("image");
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

		public String getDescription() {
			return description;
		}

		public String getType() {
			return type;
		}

		public int getJob() {
			return job;
		}

		public int getDelay() {
			return delay;
		}

		public int getLimitLevel() {
			return limitLevel;
		}

		public int getMaxRank() {
			return maxRank;
		}

		public int getUserAnimation() {
			return userAnimation;
		}

		public int getTargetAnimation() {
			return targetAnimation;
		}

		public String getImage() {
			return image;
		}

		public String getFunction() {
			return function;
		}
	}

	public static class Skill {
		private int no;
		private int rank;

		public Skill(int _no) {
			no = _no;
			rank = 1;
		}

		public int getNo() {
			return no;
		}

		public int getRank() {
			return rank;
		}
	}

	public static class Troop {
		private String name;
		private int num;
		private String image;
		private int type;
		private int team;
		private int range;
		private int hp;
		private int mp;
		private int attackAnimation;
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
		private int gold;
		private int exp;
		private int reward;
		private String function;
		private int frequency;
		private String dieFunction;

		public Troop(ResultSet rs) {
			try {
				name = rs.getString("name");
				num = rs.getInt("num");
				image = rs.getString("image");
				type = rs.getInt("type");
				team = rs.getInt("team");
				range = rs.getInt("range");
				hp = rs.getInt("hp");
				mp = rs.getInt("mp");
				attackAnimation = rs.getInt("animation");
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
				dieFunction = rs.getString("die");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getNum() {
			return num;
		}

		public int getRange() {
			return range;
		}

		public String getName() {
			return name;
		}

		public String getImage() {
			return image;
		}

		public int getType() {
			return type;
		}

		public int getTeam() {
			return team;
		}

		public int getHp() {
			return hp;
		}

		public int getMp() {
			return mp;
		}

		public int getAttackAnimation() {
			return attackAnimation;
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

		public int getCritical() {
			return critical;
		}

		public int getAvoid() {
			return avoid;
		}

		public int getHit() {
			return hit;
		}

		public int getMoveSpeed() {
			return moveSpeed;
		}

		public int getAttackSpeed() {
			return attackSpeed;
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

		public int getRegen() {
			return regen;
		}

		public int getLevel() {
			return level;
		}

		public int getGold() {
			return gold;
		}

		public int getExp() {
			return exp;
		}

		public int getReward() {
			return reward;
		}

		public String getFunction() {
			return function;
		}

		public int getFrequency() {
			return frequency;
		}

		public String getDieFunction() {
			return dieFunction;
		}
	}

	public static class Reward {
		private int no;
		private int itemNo;
		private int num;
		private int per;

		public Reward(ResultSet rs) {
			try {
				no = rs.getInt("no");
				itemNo = rs.getInt("item_no");
				num = rs.getInt("num");
				per = rs.getInt("per");
			} catch (Exception e) {
				e.printStackTrace();
			}
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

		public int getPer() {
			return per;
		}
	}

	public static class NPC {
		private int no;
		private String name;
		private String image;
		private int map;
		private int x;
		private int y;
		private int direction;
		private String function;

		public NPC(ResultSet rs) {
			try {
				no = rs.getInt("no");
				name = rs.getString("name");
				image = rs.getString("image");
				map = rs.getInt("map");
				x = rs.getInt("x");
				y = rs.getInt("y");
				direction = rs.getInt("direction");
				function = rs.getString("function");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public int getNo() {
			return no;
		}

		public String getName() {
			return name;
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

		public int getDirection() {
			return direction;
		}

		public String getFunction() {
			return function;
		}
	}
}
