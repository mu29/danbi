package database;

import game.Guild;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Logger;

public class GameData extends DataBase {
	public static Hashtable<Integer, Job> job = new Hashtable<>();
	public static Hashtable<Integer, Register> register = new Hashtable<>();
	public static Hashtable<Integer, ItemData> item = new Hashtable<>();
	public static Hashtable<Integer, SkillData> skill = new Hashtable<>();
	public static Hashtable<Integer, Troop> troop = new Hashtable<>();
	public static Hashtable<Integer, NPC> npc = new Hashtable<>();
	public static Hashtable<Integer, Shop> shop = new Hashtable<>();
	public static Vector<Reward> reward = new Vector<>();
	public static Vector<Portal> portal = new Vector<>();

	private static Logger logger = Logger.getLogger(GameData.class.getName());

	public static void loadSettings() throws SQLException {
		ResultSet rs;

		rs = executeQuery("SELECT * FROM `setting_job`;");
		while (rs.next())
			job.put(rs.getInt("no"), new Job(rs));
		logger.info("직업 정보 로드 완료.");
		
		rs = executeQuery("SELECT * FROM `setting_register`;");
		while (rs.next())
			register.put(rs.getInt("no"), new Register(rs));
		logger.info("가입 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_item`;");
		while (rs.next())
			item.put(rs.getInt("no"), new ItemData(rs));
		logger.info("아이템 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_skill`;");
		while (rs.next())
			skill.put(rs.getInt("no"), new SkillData(rs));
		logger.info("스킬 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_npc`;");
		while (rs.next())
			npc.put(rs.getInt("no"), new NPC(rs));
		logger.info("NPC 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_reward`;");
		while (rs.next())
			reward.addElement(new Reward(rs));
		logger.info("보상 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_troop`;");
		while (rs.next())
			troop.put(rs.getInt("no"), new Troop(rs));
		logger.info("에너미 정보 로드 완료.");

		ArrayList<ShopItem> shopItems = new ArrayList<>();
		rs = executeQuery("SELECT * FROM `setting_shop`;");
		while (rs.next())
			shopItems.add(new ShopItem(rs));

		for (ShopItem shopItem : shopItems) {
			int shopNo = shopItem.getNo();
			if (!shop.containsKey(shopNo))
				shop.put(shopNo, new Shop(shopNo));
			shop.get(shopNo).addItem(shopItem.getItemNo());
		}
		logger.info("상점 정보 로드 완료.");

		rs = executeQuery("SELECT * FROM `setting_portal`;");
		while (rs.next())
			portal.addElement(new Portal(rs));
		logger.info("포탈 정보 로드 완료.");

		rs.close();

		Guild.load();
	}

	public static class Job {
		private int mNo;
		private String mName;
		private int mHp;
		private int mMp;
		private int mStr;
		private int mDex;
		private int mAgi;
		
		public Job(ResultSet rs) throws SQLException {
			mNo = rs.getInt("no");
			mName = rs.getString("name");
			mHp = rs.getInt("hp");
			mMp = rs.getInt("mp");
			mStr = rs.getInt("str");
			mDex = rs.getInt("dex");
			mAgi = rs.getInt("agi");
		}
		
		public int getNo() {
			return mNo;
		}
		
		public String getName() {
			return mName;
		}
		
		public int getHp() {
			return mHp;
		}
		
		public int getMp() {
			return mMp;
		}
		
		public int getStr() {
			return mStr;
		}
		
		public int getDex() {
			return mDex;
		}
		
		public int getAgi() {
			return mAgi;
		}
	}

	public static class Register {
		
		private int mJob;
		private String mImage;
		private int mMap;
		private int mX;
		private int mY;
		private int mLevel;
		
		public Register(ResultSet rs) {
			try {
				mJob = rs.getInt("job");
				mImage = rs.getString("image");
				mMap = rs.getInt("map");
				mX = rs.getInt("x");
				mY = rs.getInt("y");
				mLevel = rs.getInt("level");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getJob() {
			return mJob;
		}
		
		public String getImage() {
			return mImage;
		}

		public int getMap() {
			return mMap;
		}

		public int getX() {
			return mX;
		}

		public int getY() {
			return mY;
		}

		public int getLevel() {
			return mLevel;
		}
		
	}
	
	public static class ItemData {
		private int mNo;
		private String mName;
		private String mDescription;
		private String mImage;
		private int mJob;
		private int mLimitLevel;
		private int mType;
		private int mPrice;
		private int mDamage;
		private int mMagicDamage;
		private int mDefense;
		private int mMagicDefense;
		private int mStr;
		private int mDex;
		private int mAgi;
		private int mHp;
		private int mMp;
		private int mCritical;
		private int mAvoid;
		private int mHit;
		private int mDelay;
		private boolean mbConsume;
		private int mMaxLoad;
		private boolean mbTrade;
		private String mFunctionName;
		
		public ItemData(ResultSet rs) {
			try {
				mNo = rs.getInt("no");
				mName = rs.getString("name");
				mDescription = rs.getString("description");
				mImage = rs.getString("image");
				mJob = rs.getInt("job");
				mLimitLevel = rs.getInt("limit_level");
				mType = rs.getInt("type");
				mPrice = rs.getInt("price");
				mDamage = rs.getInt("damage");
				mMagicDamage = rs.getInt("magic_damage");
				mDefense = rs.getInt("defense");
				mMagicDefense = rs.getInt("magic_defense");
				mStr = rs.getInt("str");
				mDex = rs.getInt("dex");
				mAgi = rs.getInt("agi");
				mHp = rs.getInt("hp");
				mMp = rs.getInt("mp");
				mCritical = rs.getInt("critical");
				mAvoid = rs.getInt("avoid");
				mHit = rs.getInt("hit");
				mDelay = rs.getInt("delay");
				mbConsume = rs.getInt("consume") == 1;
				mMaxLoad = rs.getInt("max_load");
				mbTrade = rs.getInt("trade") == 1;
				mFunctionName = rs.getString("function");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getNo() {
			return mNo;
		}
		
		public String getName() {
			return mName;
		}
		
		public String getDesc() {
			return mDescription;
		}
		
		public String getImage() {
			return mImage;
		}
		
		public int getJob() {
			return mJob;
		}
		
		public int getLimitLevel() {
			return mLimitLevel;
		}
		
		public int getType() {
			return mType;
		}
		
		public int getPrice() {
			return mPrice;
		}

		public int getDamage() { return mDamage; }

		public int getMagicDamage() { return mMagicDamage; }
		
		public int getDefense() {
			return mDefense;
		}
		
		public int getMagicDefense() {
			return mMagicDefense;
		}
		
		public int getStr() {
			return mStr;
		}
		
		public int getDex() {
			return mDex;
		}
		
		public int getAgi() {
			return mAgi;
		}
		
		public int getHp() {
			return mHp;
		}
		
		public int getMp() {
			return mMp;
		}
		
		public int getCritical() {
			return mCritical;
		}
		
		public int getAvoid() {
			return mAvoid;
		}
		
		public int getHit() {
			return mHit;
		}
		
		public int getDelay() {
			return mDelay;
		}
		
		public int getMaxLoad() {
			return mMaxLoad;
		}
		
		public boolean isConsumable() {
			return mbConsume;
		}
		
		public boolean isTradeable() {
			return mbTrade;
		}

		public String getFunction() {
			return mFunctionName;
		}
	}
	
	public static class Item implements Cloneable {
		private int mUserNo;
		private int mItemNo;
		private int mAmount;
		private int mIndex;
		private int mDamage;
		private int mMagicDamage;
		private int mDefense;
		private int mMagicDefense;
		private int mStr;
		private int mDex;
		private int mAgi;
		private int mHp;
		private int mMp;
		private int mCritical;
		private int mAvoid;
		private int mHit;
		private int mReinforce;
		private boolean mbTrade;
		private boolean mbEquipped;

		public Item(int userNo, int itemNo, int amount, int index, int trade) {
			mUserNo = userNo;
			mItemNo = itemNo;
			mAmount = amount > GameData.item.get(mItemNo).getMaxLoad() ? GameData.item.get(mItemNo).getMaxLoad() : amount;
			mIndex = index;
			mDamage = 0;
			mMagicDamage = 0;
			mDefense = 0;
			mMagicDefense = 0;
			mStr = 0;
			mDex = 0;
			mAgi = 0;
			mHp = 0;
			mMp = 0;
			mCritical = 0;
			mAvoid = 0;
			mHit = 0;
			mReinforce = 0;
			mbTrade = trade == 1;
			mbEquipped = false;
		}

		public Item(int userNo, int itemNo, int index, GameData.Item itemInfo) {
			mUserNo = userNo;
			mItemNo = itemNo;
			mAmount = 1;
			mIndex = index;
			mDamage = itemInfo.getDamage();
			mMagicDamage = itemInfo.getMagicDamage();
			mDefense = itemInfo.getDefense();
			mMagicDefense = itemInfo.getMagicDefense();
			mStr = itemInfo.getStr();
			mDex = itemInfo.getDex();
			mAgi = itemInfo.getAgi();
			mHp = itemInfo.getHp();
			mMp = itemInfo.getMp();
			mCritical = itemInfo.getCritical();
			mAvoid = itemInfo.getAvoid();
			mHit = itemInfo.getHit();
			mReinforce = itemInfo.getReinforce();
			mbTrade = itemInfo.isTradeable();
			mbEquipped = false;
		}

		public Item(ResultSet rs) {
			try {
				mUserNo = rs.getInt("user_no");
				mItemNo = rs.getInt("item_no");
				mAmount = rs.getInt("amount");
				mIndex = rs.getInt("index");
				mDamage = rs.getInt("damage");
				mMagicDamage = rs.getInt("magic_damage");
				mDefense = rs.getInt("defense");
				mMagicDefense = rs.getInt("magic_defense");
				mStr = rs.getInt("str");
				mDex = rs.getInt("dex");
				mAgi = rs.getInt("agi");
				mHp = rs.getInt("hp");
				mMp = rs.getInt("mp");
				mCritical = rs.getInt("critical");
				mAvoid = rs.getInt("avoid");
				mHit = rs.getInt("hit");
				mReinforce = rs.getInt("reinforce");
				mbTrade = rs.getInt("trade") == 1;
				mbEquipped = rs.getInt("equipped") == 1;
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getUserNo() {
			return mUserNo;
		}

		public int getNo() {
			return mItemNo;
		}

		public int getAmount() {
			return mAmount;
		}

		public int getIndex() {
			return mIndex;
		}
		
		public int getDamage() {
			return mDamage;
		}
		
		public int getMagicDamage() { return mMagicDamage; }
		
		public int getDefense() {
			return mDefense;
		}
		
		public int getMagicDefense() {
			return mMagicDefense;
		}
		
		public int getStr() {
			return mStr;
		}
		
		public int getDex() {
			return mDex;
		}
		
		public int getAgi() {
			return mAgi;
		}
		
		public int getHp() {
			return mHp;
		}
		
		public int getMp() {
			return mMp;
		}
		
		public int getCritical() {
			return mCritical;
		}
		
		public int getAvoid() {
			return mAvoid;
		}
		
		public int getHit() {
			return mHit;
		}
		
		public int getReinforce() {
			return mReinforce;
		}
		
		public boolean isTradeable() {
			return mbTrade;
		}

		public boolean isEquipped() {
			return mbEquipped;
		}

		public void setEquipped(boolean value) {
			mbEquipped = value;
		}

		public void setIndex(int value) {
			mIndex = value;
		}
		
		public void addAmount(int value) {
			if (mAmount + value > GameData.item.get(mItemNo).getMaxLoad()) {
				mAmount = GameData.item.get(mItemNo).getMaxLoad();
			} else if (mAmount + value < 0) {
				mAmount = 0;
			} else {
				mAmount += value;
			}
		}

		public void setAmount(int value) {
			mAmount = Math.abs(value);
		}

		@Override
		public Item clone() {
			Item cloneItem = null;
			try {
				cloneItem = (Item) super.clone();
			} catch (CloneNotSupportedException e) {
				e.printStackTrace();
			}
			return cloneItem;
		}
	}

	public static class SkillData {
		private int mNo;
		private String mName;
		private String mDescription;
		private String mType;
		private int mJob;
		private int mDelay;
		private int mLimitLevel;
		private int mMaxRank;
		private int mUserAnimation;
		private int mTargetAnimation;
		private String mImage;
		private String mFunctionName;

		public SkillData(ResultSet rs) {
			try {
				mNo = rs.getInt("no");
				mName = rs.getString("name");
				mDescription = rs.getString("description");
				mType = rs.getString("type");
				mJob = rs.getInt("job");
				mDelay = rs.getInt("delay");
				mLimitLevel = rs.getInt("limit_level");
				mMaxRank = rs.getInt("max_rank");
				mUserAnimation = rs.getInt("user_animation");
				mTargetAnimation = rs.getInt("target_animation");
				mImage = rs.getString("image");
				mFunctionName = rs.getString("function");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getNo() {
			return mNo;
		}

		public String getName() {
			return mName;
		}

		public String getDescription() {
			return mDescription;
		}

		public String getType() {
			return mType;
		}

		public int getJob() {
			return mJob;
		}

		public int getDelay() {
			return mDelay;
		}

		public int getLimitLevel() {
			return mLimitLevel;
		}

		public int getMaxRank() {
			return mMaxRank;
		}

		public int getUserAnimation() {
			return mUserAnimation;
		}

		public int getTargetAnimation() {
			return mTargetAnimation;
		}

		public String getImage() {
			return mImage;
		}

		public String getFunction() {
			return mFunctionName;
		}
	}

	public static class Skill {
		private int mUserNo;
		private int mSkillNo;
		private int mRank;

		public Skill(int userNo, int skillNo) {
			mUserNo = userNo;
			mSkillNo  = skillNo;
			mRank = 1;
		}

		public int getUserNo() {
			return mUserNo;
		}

		public int getNo() {
			return mSkillNo;
		}

		public int getRank() {
			return mRank;
		}
	}

	public static class Troop {
		private String mName;
		private int mNum;
		private String mImage;
		private int mType;
		private int mTeam;
		private int mRange;
		private int mHp;
		private int mMp;
		private int mAttackAnimation;
		private int mDamage;
		private int mMagicDamage;
		private int mDefense;
		private int mMagicDefense;
		private int mCritical;
		private int mAvoid;
		private int mHit;
		private int mMoveSpeed;
		private int mAttackSpeed;
		private int mMap;
		private int mX;
		private int mY;
		private int mDirection;
		private int mRegen;
		private int mLevel;
		private int mGold;
		private int mExp;
		private int mReward;
		private String mSkill;
		private int mFrequency;
		private String mDieFunctionName;

		public Troop(ResultSet rs) {
			try {
				mName = rs.getString("name");
				mNum = rs.getInt("num");
				mImage = rs.getString("image");
				mType = rs.getInt("type");
				mTeam = rs.getInt("team");
				mRange = rs.getInt("range");
				mHp = rs.getInt("hp");
				mMp = rs.getInt("mp");
				mAttackAnimation = rs.getInt("animation");
				mDamage = rs.getInt("damage");
				mMagicDamage = rs.getInt("magic_damage");
				mDefense = rs.getInt("defense");
				mMagicDefense = rs.getInt("magic_defense");
				mCritical = rs.getInt("critical");
				mAvoid = rs.getInt("avoid");
				mHit = rs.getInt("hit");
				mMoveSpeed = rs.getInt("move_speed");
				mAttackSpeed = rs.getInt("attack_speed");
				mMap = rs.getInt("map");
				mX = rs.getInt("x");
				mY = rs.getInt("y");
				mDirection = rs.getInt("direction");
				mRegen = rs.getInt("regen");
				mLevel = rs.getInt("level");
				mExp = rs.getInt("exp");
				mGold = rs.getInt("gold");
				mReward = rs.getInt("reward");
				mSkill = rs.getString("skill");
				mFrequency = rs.getInt("frequency");
				mDieFunctionName = rs.getString("die");
			} catch (SQLException e) {
				logger.warning(e.getMessage());
			}
		}

		public int getNum() {
			return mNum;
		}

		public int getRange() {
			return mRange;
		}

		public String getName() {
			return mName;
		}

		public String getImage() {
			return mImage;
		}

		public int getType() {
			return mType;
		}

		public int getTeam() {
			return mTeam;
		}

		public int getHp() {
			return mHp;
		}

		public int getMp() {
			return mMp;
		}

		public int getAttackAnimation() {
			return mAttackAnimation;
		}

		public int getDamage() {
			return mDamage;
		}

		public int getMagicDamage() {
			return mMagicDamage;
		}

		public int getDefense() {
			return mDefense;
		}

		public int getMagicDefense() {
			return mMagicDefense;
		}

		public int getCritical() {
			return mCritical;
		}

		public int getAvoid() {
			return mAvoid;
		}

		public int getHit() {
			return mHit;
		}

		public int getMoveSpeed() {
			return mMoveSpeed;
		}

		public int getAttackSpeed() {
			return mAttackSpeed;
		}

		public int getMap() {
			return mMap;
		}

		public int getX() {
			return mX;
		}

		public int getY() {
			return mY;
		}

		public int getDirection() {
			return mDirection;
		}

		public int getRegen() {
			return mRegen;
		}

		public int getLevel() {
			return mLevel;
		}

		public int getGold() {
			return mGold;
		}

		public int getExp() {
			return mExp;
		}

		public int getReward() {
			return mReward;
		}

		public String getSkill() {
			return mSkill;
		}

		public int getFrequency() {
			return mFrequency;
		}

		public String getDieFunction() {
			return mDieFunctionName;
		}
	}

	public static class Reward {
		private int mNo;
		private int mItemNo;
		private int mNum;
		private int mPer;

		public Reward(ResultSet rs) {
			try {
				mNo = rs.getInt("no");
				mItemNo = rs.getInt("item_no");
				mNum = rs.getInt("num");
				mPer = rs.getInt("per");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		public int getNo() {
			return mNo;
		}

		public int getItemNo() {
			return mItemNo;
		}

		public int getNum() {
			return mNum;
		}

		public int getPer() {
			return mPer;
		}
	}

	public static class NPC {
		private int mNo;
		private String mName;
		private String mImage;
		private int mMap;
		private int mX;
		private int mY;
		private int mDirection;
		private String mFunctionName;

		public NPC(ResultSet rs) {
			try {
				mNo = rs.getInt("no");
				mName = rs.getString("name");
				mImage = rs.getString("image");
				mMap = rs.getInt("map");
				mX = rs.getInt("x");
				mY = rs.getInt("y");
				mDirection = rs.getInt("direction");
				mFunctionName = rs.getString("function");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public int getNo() {
			return mNo;
		}

		public String getName() {
			return mName;
		}

		public String getImage() {
			return mImage;
		}

		public int getMap() {
			return mMap;
		}

		public int getX() {
			return mX;
		}

		public int getY() {
			return mY;
		}

		public int getDirection() {
			return mDirection;
		}

		public String getFunction() {
			return mFunctionName;
		}
	}

	public static class Shop {
		private int mNo;
		private Hashtable<Integer, ItemData> mItems;

		public Shop(int no) {
			mNo = no;
			mItems = new Hashtable<>();
		}

		public int getNo() {
			return mNo;
		}

		public void addItem(int mItemNo) {
			mItems.put(mItems.size() + 1, item.get(mItemNo));
		}

		public ItemData getItem(int index) {
			if (mItems.containsKey(index)) {
				return mItems.get(index);
			}
			return null;
		}

		public Hashtable<Integer, ItemData> getAllItems() {
			return mItems;
		}
	}

	public static class ShopItem {
		private int mNo;
		private int mItemNo;

		public ShopItem(ResultSet rs) {
			try {
				mNo = rs.getInt("no");
				mItemNo = rs.getInt("item_no");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public int getNo() {
			return mNo;
		}

		public int getItemNo() {
			return mItemNo;
		}
	}

	public static class Portal {
		private int mMap;
		private int mX;
		private int mY;
		private int mNextMap;
		private int mNextX;
		private int mNextY;

		public Portal(ResultSet rs) {
			try {
				mMap = rs.getInt("map");
				mX = rs.getInt("x");
				mY = rs.getInt("y");
				mNextMap = rs.getInt("next_map");
				mNextX = rs.getInt("next_x");
				mNextY = rs.getInt("next_y");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		public int getMap() {
			return mMap;
		}

		public int getX() {
			return mX;
		}

		public int getY() {
			return mY;
		}

		public int getNextMap() {
			return mNextMap;
		}

		public int getNextX() {
			return mNextX;
		}

		public int getNextY() {
			return mNextY;
		}
	}
}