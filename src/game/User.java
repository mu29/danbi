package game;

import io.netty.channel.ChannelHandlerContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.logging.Logger;

import network.Handler;
import packet.Packet;
import database.*;

public class User extends Character {
	private static Hashtable<ChannelHandlerContext, User> users = new Hashtable<ChannelHandlerContext, User>();

	private ChannelHandlerContext ctx;
	private String id;
	private String pass;
	private String mail;
	private String guild;
	private int job;
	private int pureStr;
	private int pureDex;
	private int pureAgi;
	private int statPoint;
	private int skillPoint;
	private int title;
	private boolean admin;
	
	private int weapon = 0;
	private int shield = 0;
	private int helmet = 0;
	private int armor = 0;
	private int cape = 0;
	private int shoes = 0;
	private int accessory = 0;

	private int maxInventory = 35;

	private Hashtable<Integer, GameData.Item> inventory = new Hashtable<Integer, GameData.Item>();
	private Hashtable<Integer, GameData.Skill> skillList  = new Hashtable<Integer, GameData.Skill>();

	private static Logger logger = Logger.getLogger(User.class.getName());

	public static User get(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx))
			return null;

		return users.get(ctx);
	}

	public static Hashtable<ChannelHandlerContext, User> getAll() {
		return users;
	}

	public static boolean put(ChannelHandlerContext ctx, User user) {
		if (users.containsKey(ctx))
			return false;

		users.put(ctx, user);
		return true;
	}

	public static boolean remove(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx))
			return false;

		users.remove(ctx);
		return true;
	}

	public User(ChannelHandlerContext ct, ResultSet rs) {
		try {
			ctx = ct;
			no = rs.getInt("no");
			id = rs.getString("id");
			pass = rs.getString("pass");
			name = rs.getString("name");
			title = rs.getInt("title");
			guild = "";
			mail = rs.getString("mail");
			image = rs.getString("image");
			job = rs.getInt("job");
			pureStr = rs.getInt("str");
			pureDex = rs.getInt("dex");
			pureAgi = rs.getInt("agi");
			statPoint = rs.getInt("stat_point");
			skillPoint = rs.getInt("skill_point");
			hp = rs.getInt("hp");
			mp = rs.getInt("mp");
			level = rs.getInt("level");
			exp = rs.getInt("exp");
			gold = rs.getInt("gold");
			map = rs.getInt("map");
			seed = rs.getInt("seed");
			x = rs.getInt("x");
			y = rs.getInt("y");
			direction = rs.getInt("direction");
			moveSpeed = rs.getInt("speed");
			admin = rs.getInt("admin") == 0;

			team = no;
		} catch (SQLException e) {
			logger.warning(e.getMessage());
		}
	}
	
	public ChannelHandlerContext getCtx() {
		return ctx;
	}
	
	public String getID() {
		return id;
	}
	
	public String getPass() {
		return pass;
	}
	
	public int getTitle() {
		return title;
	}

	public void setTitle(int _title) {
		title = _title;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.TITLE, title));
		Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.TITLE, title));
	}
	
	public String getGuild() {
		return guild;
	}
	
	public String getMail() {
		return mail;
	}

	public void setImage(String _image) {
		image = _image;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.IMAGE, image));
		Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.IMAGE, image));
	}
	
	public int getJob() {
		return job;
	}

	public void setJob(int _job) {
		job = _job;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.JOB, job));
		Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.JOB, job));
	}
	
	public int getStr() {
		int n = 0;
		// 스텟 Str
		n += pureStr;
		// 직업 기본 Str
		n += GameData.job.get(job).getStr() * level;
		// 아이템으로 오르는 Str
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getStr();
			n += findItemByIndex(weapon).getStr();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getStr();
			n += findItemByIndex(shield).getStr();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getStr();
			n += findItemByIndex(helmet).getStr();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getStr();
			n += findItemByIndex(armor).getStr();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getStr();
			n += findItemByIndex(cape).getStr();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getStr();
			n += findItemByIndex(shoes).getStr();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getStr();
			n += findItemByIndex(accessory).getStr();
		}

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
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getDex();
			n += findItemByIndex(weapon).getDex();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getDex();
			n += findItemByIndex(shield).getDex();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getDex();
			n += findItemByIndex(helmet).getDex();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getDex();
			n += findItemByIndex(armor).getDex();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getDex();
			n += findItemByIndex(cape).getDex();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getDex();
			n += findItemByIndex(shoes).getDex();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getDex();
			n += findItemByIndex(accessory).getDex();
		}
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
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getAgi();
			n += findItemByIndex(weapon).getAgi();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getAgi();
			n += findItemByIndex(shield).getAgi();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getAgi();
			n += findItemByIndex(helmet).getAgi();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getAgi();
			n += findItemByIndex(armor).getAgi();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getAgi();
			n += findItemByIndex(cape).getAgi();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getAgi();
			n += findItemByIndex(shoes).getAgi();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getAgi();
			n += findItemByIndex(accessory).getAgi();
		}
		return n;
	}
	
	public int getPureAgi() {
		return pureAgi;
	}

	public void gainHp(int value) {
		// 최대 HP 이상인 경우 보정
		if (hp + value > getMaxHp())
			value = getMaxHp() - hp;

		hp += value;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.HP, hp));
		Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.HP, hp));
	}

	public void loseHp(int value) {
		gainHp(-value);

		if (hp - value < 0) {
			// 쥬금
			return;
		}
	}

	// 최대 HP
	public int getMaxHp() {
		int n = 0;
		// 직업 기본 Hp
		n += GameData.job.get(job).getHp() * level;
		// 아이템으로 오르는 Hp
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getHp();
			n += findItemByIndex(weapon).getHp();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getHp();
			n += findItemByIndex(shield).getHp();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getHp();
			n += findItemByIndex(helmet).getHp();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getHp();
			n += findItemByIndex(armor).getHp();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getHp();
			n += findItemByIndex(cape).getHp();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getHp();
			n += findItemByIndex(shoes).getHp();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getHp();
			n += findItemByIndex(accessory).getHp();
		}

		return n;
	}

	public void gainMp(int value) {
		// 최대 MP 이상인 경우 보정
		if (mp + value > getMaxMp())
			value = getMaxMp() - mp;

		mp += value;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.MP, mp));
	}

	public boolean loseMp(int value) {
		if (mp - value < 0)
			return false;

		gainMp(-value);
		return true;
	}

	// 최대 MP
	public int getMaxMp() {
		int n = 0;
		// 직업 기본 Mp
		n += GameData.job.get(job).getMp() * level;
		// 아이템으로 오르는 Mp
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getMp();
			n += findItemByIndex(weapon).getMp();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getMp();
			n += findItemByIndex(shield).getMp();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getMp();
			n += findItemByIndex(helmet).getMp();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getMp();
			n += findItemByIndex(armor).getMp();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getMp();
			n += findItemByIndex(cape).getMp();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getMp();
			n += findItemByIndex(shoes).getMp();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getMp();
			n += findItemByIndex(accessory).getMp();
		}
		
		return n;
	}

	// 치명타율
	public int getCritical() {
		int n = 0;
		// 아이템으로 오르는 Critical
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getCritical();
			n += findItemByIndex(weapon).getCritical();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getCritical();
			n += findItemByIndex(shield).getCritical();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getCritical();
			n += findItemByIndex(helmet).getCritical();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getCritical();
			n += findItemByIndex(armor).getCritical();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getCritical();
			n += findItemByIndex(cape).getCritical();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getCritical();
			n += findItemByIndex(shoes).getCritical();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getCritical();
			n += findItemByIndex(accessory).getCritical();
		}
		
		return n;
	}

	// 회피율
	public int getAvoid() {
		int n = 0;
		// 아이템으로 오르는 Avoid
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getAvoid();
			n += findItemByIndex(weapon).getAvoid();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getAvoid();
			n += findItemByIndex(shield).getAvoid();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getAvoid();
			n += findItemByIndex(helmet).getAvoid();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getAvoid();
			n += findItemByIndex(armor).getAvoid();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getAvoid();
			n += findItemByIndex(cape).getAvoid();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getAvoid();
			n += findItemByIndex(shoes).getAvoid();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getAvoid();
			n += findItemByIndex(accessory).getAvoid();
		}

		return n;
	}

	// 명중률
	public int getHit() {
		int n = 0;
		// 아이템으로 오르는 Hit
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getHit();
			n += findItemByIndex(weapon).getHit();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getHit();
			n += findItemByIndex(shield).getHit();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getHit();
			n += findItemByIndex(helmet).getHit();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getHit();
			n += findItemByIndex(armor).getHit();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getHit();
			n += findItemByIndex(cape).getHit();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getHit();
			n += findItemByIndex(shoes).getHit();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getHit();
			n += findItemByIndex(accessory).getHit();
		}


		return n;
	}

	// 물리 데미지
	public int getDamage() {
		int n = 0;
		// 아이템으로 오르는 Damage
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getDamage();
			n += findItemByIndex(weapon).getDamage();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getDamage();
			n += findItemByIndex(shield).getDamage();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getDamage();
			n += findItemByIndex(helmet).getDamage();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getDamage();
			n += findItemByIndex(armor).getDamage();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getDamage();
			n += findItemByIndex(cape).getDamage();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getDamage();
			n += findItemByIndex(shoes).getDamage();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getDamage();
			n += findItemByIndex(accessory).getDamage();
		}
		
		return n;
	}

	// 마법 데미지
	public int getMagicDamage() {
		int n = 0;
		// 아이템으로 오르는 MagicDamage
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getMagicDamage();
			n += findItemByIndex(weapon).getMagicDamage();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getMagicDamage();
			n += findItemByIndex(shield).getMagicDamage();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getMagicDamage();
			n += findItemByIndex(helmet).getMagicDamage();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getMagicDamage();
			n += findItemByIndex(armor).getMagicDamage();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getMagicDamage();
			n += findItemByIndex(cape).getMagicDamage();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getMagicDamage();
			n += findItemByIndex(shoes).getMagicDamage();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getMagicDamage();
			n += findItemByIndex(accessory).getMagicDamage();
		}

		return n;
	}

	// 물리 방어력
	public int getDefense() {
		int n = 0;
		// 아이템으로 오르는 Defense
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getDefense();
			n += findItemByIndex(weapon).getDefense();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getDefense();
			n += findItemByIndex(shield).getDefense();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getDefense();
			n += findItemByIndex(helmet).getDefense();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getDefense();
			n += findItemByIndex(armor).getDefense();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getDefense();
			n += findItemByIndex(cape).getDefense();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getDefense();
			n += findItemByIndex(shoes).getDefense();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getDefense();
			n += findItemByIndex(accessory).getDefense();
		}

		return n;
	}

	// 마법 방어력
	public int getMagicDefense() {
		int n = 0;
		// 아이템으로 오르는 MagicDefense
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getMagicDefense();
			n += findItemByIndex(weapon).getMagicDefense();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getItemNo()).getMagicDefense();
			n += findItemByIndex(shield).getMagicDefense();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getMagicDefense();
			n += findItemByIndex(helmet).getMagicDefense();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getItemNo()).getMagicDefense();
			n += findItemByIndex(armor).getMagicDefense();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getItemNo()).getMagicDefense();
			n += findItemByIndex(cape).getMagicDefense();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getMagicDefense();
			n += findItemByIndex(shoes).getMagicDefense();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getMagicDefense();
			n += findItemByIndex(accessory).getMagicDefense();
		}

		return n;
	}

	// 필요 경험치
	public int getMaxExp() {
		// 필요 경험치 계산식
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

			ctx.write(Packet.updateStatus(Type.Status.LEVEL, level));
			ctx.write(Packet.updateStatus(Type.Status.STAT_POINT, statPoint));
			ctx.write(Packet.updateStatus(Type.Status.SKILL_POINT, skillPoint));
			ctx.write(Packet.updateStatus(Type.Status.MAX_EXP, getMaxExp()));

			Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.LEVEL, level));
			Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.MAX_HP, getMaxHp()));
		}

		ctx.writeAndFlush(Packet.updateStatus(Type.Status.EXP, exp));
	}

	public void loseExp(int value) {
		if (exp - value < 0)
			value = exp;

		gainExp(-value);
	}

	public void gainGold(int value) {
		gold += value;

		//
	}

	public boolean loseGold(int value) {
		if (gold < value)
			return false;

		gainGold(-value);
		return true;
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

	public int getMaxInventory() {
		return maxInventory;
	}
	
	public void loadData() {
		loadEquipItem();
		loadInventory();
		loadSkillList();
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
	    	} else {
				DataBase.insertEquip(no);
			}
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 인벤토리 불러오기
	public void loadInventory() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `item` WHERE `user_no` = '" + no + "';");

			while (rs.next()) {
				inventory.put(rs.getInt("index"), new GameData.Item(rs));
				ctx.writeAndFlush(Packet.setInventory(inventory.get(rs.getInt("index"))));
			}

			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}

	}

	// 스킬 불러오기
	public void loadSkillList() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `skill` WHERE `user_no` = '" + no + "';");

			while (rs.next()) {
				skillList.put(rs.getInt("no"), new GameData.Skill(rs.getInt("no")));
				ctx.writeAndFlush(Packet.setSkillList(skillList.get(rs.getInt("no"))));
			}

			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}

	}
	
	// 아이템 장착
	public void equipItem(int type, int index) {
		switch (type) {
		case Type.Item.WEAPON:
			weapon = index;
			break;
		case Type.Item.SHIELD:
			shield = index;
			break;
		case Type.Item.HELMET:
			helmet = index;
			break;
		case Type.Item.ARMOR:
			armor = index;
			break;
		case Type.Item.CAPE:
			cape = index;
			break;
		case Type.Item.SHOES:
			shoes = index;
			break;
		case Type.Item.ACCESSORY:
			accessory = index;
			break;
		}

		Map.get(map).sendToOthers(no, seed, Packet.updateCharacter(Type.Character.USER, no, Type.Status.MAX_HP, getMaxHp()));
	}

	// 스텟 포인트 사용
	public void useStatPoint(int stat) {
		if (statPoint <= 0)
			return;

		// 올릴 수 있는 스텟만 올리고
		switch (stat) {
			case Type.Status.STR:
				pureStr++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getStr()));
				break;
			case Type.Status.DEX:
				pureDex++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getDex()));
				break;
			case Type.Status.AGI:
				pureAgi++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getAgi()));
				break;
			default:
				return;
		}

		// 스포 하나 까자
		statPoint--;
		ctx.writeAndFlush(Packet.updateStatus(Type.Status.STAT_POINT, statPoint));
	}

	// NPC로부터 아이템 획득 (아이템 번호로 아이템 획득)
	public boolean gainItem(int itemNo, int num) {
		int gap = 0;
		int index = getEmptyIndex();
		GameData.ItemData i = GameData.item.get(itemNo);
		GameData.Item item = findLazyItemByNo(itemNo);

		// 이미 있던 아이템일 경우 채워줌
		if (item != null) {
			gap = item.getAmount() + num - i.getMaxLoad();
			item.changeAmount(num);
			num = gap;
			ctx.writeAndFlush(Packet.updateInventory(1, item));
		}

		while (num > 0) {
			if (index == -1) {
				// 나머지 아이템 드랍
				return false;
			}
			// 계속해서 아이템 채우자
			inventory.put(index, new GameData.Item(no, itemNo, num, index, i.isTradeable() ? 1 : 0));
			ctx.writeAndFlush(Packet.setInventory(inventory.get(index)));
			index = getEmptyIndex();
			num -= i.getMaxLoad();
		}

		return true;
	}

	// 아이템 No로 아이템 잃음 (퀘스트 등)
	public boolean loseItemByNo(int itemNo, int num) {
		if (itemNo <= 0 || num <= 0)
			return false;
		
		int gap = 0;
		GameData.Item i = findItemByNo(itemNo);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (i == null || getTotalItemAmount(i.getItemNo()) < num)
			return false;

		// 모든 아이템을 잃을 때까지 반복
		do {
			gap = num - i.getAmount();
			i.changeAmount(-num);
			if (i.getAmount() == 0) {
				// 아이템 삭제
				inventory.remove(i.getIndex());
				ctx.writeAndFlush(Packet.updateInventory(0, i));
			} else {
				// 아이템 갯수 업데이트
				ctx.writeAndFlush(Packet.updateInventory(1, i));
			}
			num = gap;
		} while (num > 0);

		return true;
	}

	// Index로 아이템 잃음 (직접 드랍하는 경우)
	public boolean loseItemByIndex(int index, int num) {
		GameData.Item i = findItemByIndex(index);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (i == null || i.getAmount() < num)
			return false;

		i.changeAmount(-num);
		if (i.getAmount() == 0) {
			// 아이템 삭제
			inventory.remove(i.getIndex());
			ctx.writeAndFlush(Packet.updateInventory(0, i));
		} else {
			// 아이템 갯수 업데이트
			ctx.writeAndFlush(Packet.updateInventory(1, i));
		}

		return true;
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 1; i <= maxInventory; i++) {
			if (!inventory.containsKey(i))
				return i;
		}
		
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getTotalItemAmount(int no) {
		int num = 0;
		for (GameData.Item item : inventory.values()) {
			if (item.getItemNo() == no)
				num += item.getAmount();
		}
		
		return num;
	}
	
	// Index로 아이템 검색
	public GameData.Item findItemByIndex(int index) {
		if (!inventory.containsKey(index))
			return null;
		
		return inventory.get(index);
	}

	// No로 아이템 검색
	public GameData.Item findItemByNo(int no) {
		for (GameData.Item item : inventory.values()) {
			if (item.getItemNo() == no)
				return item;
		}

		return null;
	}

	// No로 여유 있는 아이템 검색
	public GameData.Item findLazyItemByNo(int no) {
		for (GameData.Item item : inventory.values()) {
			// 아이템이 꽉 찬 경우가 아니라면
			if (item.getItemNo() == no && item.getAmount() < GameData.item.get(item.getItemNo()).getMaxLoad())
				return item;
		}

		return null;
	}

	// 아이템 인덱스 변경
	public void changeItemIndex(int index1, int index2) {
		GameData.Item presentItem = findItemByIndex(index1);
		GameData.Item targetItem = findItemByIndex(index2);

		// 아이템이 없으면 반환
		if (presentItem == null)
			return;

		if (targetItem != null) {
			// 아이템 간 인덱스 변경
			inventory.remove(index1);
			inventory.remove(index2);
			presentItem.setIndex(index2);
			targetItem.setIndex(index1);
			inventory.put(index2, presentItem);
			inventory.put(index1, targetItem);

			ctx.write(Packet.setInventory(presentItem));
			ctx.writeAndFlush(Packet.setInventory(targetItem));
		} else {
			// 빈 곳으로 아이템 이동
			ctx.write(Packet.updateInventory(0, presentItem));
			inventory.remove(index1);
			presentItem.setIndex(index2);
			inventory.put(index2, presentItem);
			ctx.writeAndFlush(Packet.setInventory(presentItem));
		}

	}

	// Index로 아이템 사용
	public boolean useItemByIndex(int index, int amount) {
		GameData.Item item = findItemByIndex(index);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount)
			return false;

		// 소모품이면 아이템 잃음
		if (GameData.item.get(item.getItemNo()).isConsumable())
			loseItemByIndex(index, amount);

		// 함수가 있을 경우 실행
		String function = GameData.item.get(item.getItemNo()).getFunction();
		if (function != "")
			Functions.execute(Functions.item, function, new Object[] { this, item });

		return true;
	}

	// No로 아이템 사용
	public boolean useItemByNo(int no, int amount) {
		GameData.Item item = findItemByNo(no);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount)
			return false;

		// 소모품이면 아이템 잃음
		if (GameData.item.get(item.getItemNo()).isConsumable())
			loseItemByNo(no, amount);

		// 함수가 있을 경우 실행
		String function = GameData.item.get(item.getItemNo()).getFunction();
		if (function != "")
			Functions.execute(Functions.item, function, new Object[] { this, item });

		return true;
	}

	// No로 스킬 검색
	public GameData.Skill findSkillByNo(int no) {
		if (!skillList.containsKey(no))
			return null;

		return skillList.get(no);
	}

	// 스킬 배우기
	public boolean studySkill(int no) {
		if (skillList.containsKey(no))
			return false;

		skillList.put(no, new GameData.Skill(no));
		return true;
	}

	// 스킬 지우기
	public boolean forgetSkill(int no) {
		if (!skillList.containsKey(no))
			return false;

		skillList.remove(no);
		return true;
	}

	// No로 스킬 사용
	public boolean useSkill(int no) {
		GameData.Skill skill = findSkillByNo(no);

		if (skill == null)
			return false;

		// 함수가 있을 경우 실행
		String function = GameData.skill.get(skill.getNo()).getFunction();
		if (function != "")
			Functions.execute(Functions.skill, function, new Object[] { this, skill });

		return true;
	}

	// 스페이스바 누를 경우 액션
	public void action() {
		int new_x = x + (direction == 6 ? 1 : direction == 4 ? -1 : 0);
		int new_y = y + (direction == 2 ? 1 : direction == 8 ? -1 : 0);

		// 에너미가 있을 경우 공격하고 반환
		for (Enemy enemy : Map.get(map).getAliveEnemies()) {
			if (enemy.getX() == new_x && enemy.getY() == new_y) {
				assault(enemy);
				return;
			}
		}
	}

	// 적 공격
	public void assault(Character target) {
		Map.get(map).sendToAll(seed, Packet.jumpCharacter(Type.Character.USER, no, x, y));
		Map.get(map).sendToAll(seed, Packet.animationCharacter(Type.Character.ENEMY, target.getNo(), 8));

		// 실 데미지를 계산
		int attackDamage = (getDamage() - target.getDefense()) *  (getDamage() - target.getDefense());
		if (target.getClass().getName().equals("game.Enemy")) {
			// 타겟이 에너미인 경우
			Enemy e = (Enemy) target;
			e.loseHp(attackDamage);
		} else if (target.getClass().getName().equals("game.User")) {
			// 타겟이 유저인 경우
			User u = (User) target;
			u.loseHp(attackDamage);
		}
	}

	public void update() {

	}

	// 방향 전환
	public void turn(int type) {
		switch (type) {
			case Type.Direction.DOWN:
				turnDown();
				break;
			case Type.Direction.LEFT:
				turnLeft();
				break;
			case Type.Direction.RIGHT:
				turnRight();
				break;
			case Type.Direction.UP:
				turnUp();
				break;
		}
	}

	private void turnUp() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.UP;

		gameMap.sendToOthers(no, seed, Packet.turnCharacter(Type.Character.USER, no, direction));
	}

	private void turnDown() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.DOWN;

		gameMap.sendToOthers(no, seed, Packet.turnCharacter(Type.Character.USER, no, direction));
	}

	private void turnLeft() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.LEFT;

		gameMap.sendToOthers(no, seed, Packet.turnCharacter(Type.Character.USER, no, direction));
	}

	private void turnRight() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.RIGHT;

		gameMap.sendToOthers(no, seed, Packet.turnCharacter(Type.Character.USER, no, direction));
	}

	// 좌표 이동
	public void move(int type) {
		switch (type) {
			case 2:
				moveDown();
				break;
			case 4:
				moveLeft();
				break;
			case 6:
				moveRight();
				break;
			case 8:
				moveUp();
				break;
		}
	}

	private void moveUp() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.UP;

		if (gameMap.isPassable(this, x, y - 1)) {
			y -= 1;
			gameMap.sendToOthers(no, seed, Packet.moveCharacter(Type.Character.USER, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.refreshCharacter(Type.Character.USER, no, x, y, direction));
		}
	}

	private void moveDown() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.DOWN;

		if (gameMap.isPassable(this, x, y + 1)) {
			y += 1;
			gameMap.sendToOthers(no, seed, Packet.moveCharacter(Type.Character.USER, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.refreshCharacter(Type.Character.USER, no, x, y, direction));
		}
	}

	private void moveLeft() {
		Map gameMap = Map.get(map);
		direction = Type.Direction.LEFT;

		if (gameMap.isPassable(this, x - 1, y)) {
			x -= 1;
			gameMap.sendToOthers(no, seed, Packet.moveCharacter(Type.Character.USER, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.refreshCharacter(Type.Character.USER, no, x, y, direction));
		}
	}

	private void moveRight() {
		studySkill(1);
		Map gameMap = Map.get(map);
		direction = Type.Direction.RIGHT;

		if (gameMap.isPassable(this, x + 1, y)) {
			x += 1;
			gameMap.sendToOthers(no, seed, Packet.moveCharacter(Type.Character.USER, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.refreshCharacter(Type.Character.USER, no, x, y, direction));
		}
	}
	
}
