package game;

import io.netty.channel.ChannelHandlerContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Random;
import java.util.logging.Logger;

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

		users.get(ctx).exitGracefully();
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
			characterType = Type.Character.USER;
			random = new Random();
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
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.TITLE }, new Integer[]{ title }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{ Type.Status.TITLE }, new Integer[]{ title }));
	}
	
	public String getGuild() {
		return guild;
	}
	
	public String getMail() {
		return mail;
	}

	public void setImage(String _image) {
		image = _image;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.IMAGE }, new String[]{ image }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{Type.Status.IMAGE}, new String[]{image}));
	}
	
	public int getJob() {
		return job;
	}

	public void setJob(int _job) {
		job = _job;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.JOB }, new Integer[]{ job }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{Type.Status.JOB}, new Integer[]{job}));
	}
	
	public int getStr() {
		int n = 0;
		// 스텟 Str
		n += pureStr;
		// 직업 기본 Str
		n += GameData.job.get(job).getStr() * level;
		// 아이템으로 오르는 Str
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getStr();
			n += findItemByIndex(weapon).getStr();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getStr();
			n += findItemByIndex(shield).getStr();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getStr();
			n += findItemByIndex(helmet).getStr();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getStr();
			n += findItemByIndex(armor).getStr();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getStr();
			n += findItemByIndex(cape).getStr();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getStr();
			n += findItemByIndex(shoes).getStr();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getStr();
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
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getDex();
			n += findItemByIndex(weapon).getDex();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getDex();
			n += findItemByIndex(shield).getDex();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getDex();
			n += findItemByIndex(helmet).getDex();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getDex();
			n += findItemByIndex(armor).getDex();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getDex();
			n += findItemByIndex(cape).getDex();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getDex();
			n += findItemByIndex(shoes).getDex();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getDex();
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
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getAgi();
			n += findItemByIndex(weapon).getAgi();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getAgi();
			n += findItemByIndex(shield).getAgi();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getAgi();
			n += findItemByIndex(helmet).getAgi();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getAgi();
			n += findItemByIndex(armor).getAgi();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getAgi();
			n += findItemByIndex(cape).getAgi();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getAgi();
			n += findItemByIndex(shoes).getAgi();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getAgi();
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

		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.HP }, new Integer[]{ hp }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{ Type.Status.HP }, new Integer[]{ hp }));
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
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getHp();
			n += findItemByIndex(weapon).getHp();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getHp();
			n += findItemByIndex(shield).getHp();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getHp();
			n += findItemByIndex(helmet).getHp();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getHp();
			n += findItemByIndex(armor).getHp();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getHp();
			n += findItemByIndex(cape).getHp();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getHp();
			n += findItemByIndex(shoes).getHp();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getHp();
			n += findItemByIndex(accessory).getHp();
		}

		return n;
	}

	public void gainMp(int value) {
		// 최대 MP 이상인 경우 보정
		if (mp + value > getMaxMp())
			value = getMaxMp() - mp;

		mp += value;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.MP }, new Integer[]{ mp }));
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
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getMp();
			n += findItemByIndex(weapon).getMp();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getMp();
			n += findItemByIndex(shield).getMp();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getMp();
			n += findItemByIndex(helmet).getMp();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getMp();
			n += findItemByIndex(armor).getMp();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getMp();
			n += findItemByIndex(cape).getMp();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getMp();
			n += findItemByIndex(shoes).getMp();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getMp();
			n += findItemByIndex(accessory).getMp();
		}
		
		return n;
	}

	// 치명타율
	public int getCritical() {
		int n = 0;
		// 아이템으로 오르는 Critical
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getCritical();
			n += findItemByIndex(weapon).getCritical();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getCritical();
			n += findItemByIndex(shield).getCritical();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getCritical();
			n += findItemByIndex(helmet).getCritical();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getCritical();
			n += findItemByIndex(armor).getCritical();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getCritical();
			n += findItemByIndex(cape).getCritical();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getCritical();
			n += findItemByIndex(shoes).getCritical();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getCritical();
			n += findItemByIndex(accessory).getCritical();
		}
		
		return n;
	}

	// 회피율
	public int getAvoid() {
		int n = 0;
		// 아이템으로 오르는 Avoid
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getAvoid();
			n += findItemByIndex(weapon).getAvoid();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getAvoid();
			n += findItemByIndex(shield).getAvoid();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getAvoid();
			n += findItemByIndex(helmet).getAvoid();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getAvoid();
			n += findItemByIndex(armor).getAvoid();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getAvoid();
			n += findItemByIndex(cape).getAvoid();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getAvoid();
			n += findItemByIndex(shoes).getAvoid();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getAvoid();
			n += findItemByIndex(accessory).getAvoid();
		}

		return n;
	}

	// 명중률
	public int getHit() {
		int n = 0;
		// 아이템으로 오르는 Hit
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getHit();
			n += findItemByIndex(weapon).getHit();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getHit();
			n += findItemByIndex(shield).getHit();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getHit();
			n += findItemByIndex(helmet).getHit();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getHit();
			n += findItemByIndex(armor).getHit();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getHit();
			n += findItemByIndex(cape).getHit();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getHit();
			n += findItemByIndex(shoes).getHit();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getHit();
			n += findItemByIndex(accessory).getHit();
		}

		return n;
	}

	// 물리 데미지
	public int getDamage() {
		int n = 0;
		// 아이템으로 오르는 Damage
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getDamage();
			n += findItemByIndex(weapon).getDamage();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getDamage();
			n += findItemByIndex(shield).getDamage();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getDamage();
			n += findItemByIndex(helmet).getDamage();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getDamage();
			n += findItemByIndex(armor).getDamage();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getDamage();
			n += findItemByIndex(cape).getDamage();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getDamage();
			n += findItemByIndex(shoes).getDamage();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getDamage();
			n += findItemByIndex(accessory).getDamage();
		}
		
		return n;
	}

	// 마법 데미지
	public int getMagicDamage() {
		int n = 0;
		// 아이템으로 오르는 MagicDamage
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getMagicDamage();
			n += findItemByIndex(weapon).getMagicDamage();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getMagicDamage();
			n += findItemByIndex(shield).getMagicDamage();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getMagicDamage();
			n += findItemByIndex(helmet).getMagicDamage();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getMagicDamage();
			n += findItemByIndex(armor).getMagicDamage();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getMagicDamage();
			n += findItemByIndex(cape).getMagicDamage();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getMagicDamage();
			n += findItemByIndex(shoes).getMagicDamage();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getMagicDamage();
			n += findItemByIndex(accessory).getMagicDamage();
		}

		return n;
	}

	// 물리 방어력
	public int getDefense() {
		int n = 0;
		// 아이템으로 오르는 Defense
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getDefense();
			n += findItemByIndex(weapon).getDefense();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getDefense();
			n += findItemByIndex(shield).getDefense();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getDefense();
			n += findItemByIndex(helmet).getDefense();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getDefense();
			n += findItemByIndex(armor).getDefense();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getDefense();
			n += findItemByIndex(cape).getDefense();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getDefense();
			n += findItemByIndex(shoes).getDefense();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getDefense();
			n += findItemByIndex(accessory).getDefense();
		}

		return n;
	}

	// 마법 방어력
	public int getMagicDefense() {
		int n = 0;
		// 아이템으로 오르는 MagicDefense
		if (weapon > 0) {
			n += GameData.item.get(findItemByIndex(weapon).getNo()).getMagicDefense();
			n += findItemByIndex(weapon).getMagicDefense();
		}
		if (shield > 0) {
			n += GameData.item.get(findItemByIndex(shield).getNo()).getMagicDefense();
			n += findItemByIndex(shield).getMagicDefense();
		}
		if (helmet > 0) {
			n += GameData.item.get(findItemByIndex(helmet).getNo()).getMagicDefense();
			n += findItemByIndex(helmet).getMagicDefense();
		}
		if (armor > 0) {
			n += GameData.item.get(findItemByIndex(armor).getNo()).getMagicDefense();
			n += findItemByIndex(armor).getMagicDefense();
		}
		if (cape > 0) {
			n += GameData.item.get(findItemByIndex(cape).getNo()).getMagicDefense();
			n += findItemByIndex(cape).getMagicDefense();
		}
		if (shoes > 0) {
			n += GameData.item.get(findItemByIndex(shoes).getNo()).getMagicDefense();
			n += findItemByIndex(shoes).getMagicDefense();
		}
		if (accessory > 0) {
			n += GameData.item.get(findItemByIndex(accessory).getNo()).getMagicDefense();
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

	// 경험치 획득
	public void gainExp(int value) {
		int maxExp = getMaxExp();
		exp += value;

		// 현재 경험치가 최대 경험치를 초과한 경우
		if (exp >= maxExp) {
			// 레벨 업
			exp = 0;
			level++;
			statPoint += 5;
			skillPoint += 1;
			// HP 및 MP 회복
			hp = getMaxHp();
			mp = getMaxMp();

			// 변화한 스텟 정보를 보냄
			ctx.writeAndFlush(Packet.updateStatus(
					new int[]{Type.Status.LEVEL, Type.Status.STAT_POINT, Type.Status.SKILL_POINT, Type.Status.STR, Type.Status.DEX,
							Type.Status.AGI, Type.Status.HP, Type.Status.MAX_HP, Type.Status.MP, Type.Status.MAX_MP, Type.Status.MAX_EXP},
					new Integer[]{level, statPoint, skillPoint, getStr(), getDex(), getAgi(), hp, getMaxHp(), mp, getMaxMp(), getMaxExp()}));

			Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
					new int[]{ Type.Status.LEVEL, Type.Status.HP, Type.Status.MAX_HP },
					new Integer[] { level, hp, getMaxHp() }));

			animation(25);
		}

		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.EXP }, new Integer[]{ exp }));
	}

	// 경험치 잃음
	public void loseExp(int value) {
		if (exp - value < 0)
			value = exp;

		gainExp(-value);
	}

	public void gainGold(int value) {
		gold += value;

		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.GOLD }, new Integer[] { gold }));
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
				skillList.put(rs.getInt("skill_no"), new GameData.Skill(no, rs.getInt("skill_no")));
				ctx.writeAndFlush(Packet.setSkillList(skillList.get(rs.getInt("skill_no"))));
			}

			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 스텟 포인트 사용
	public void useStatPoint(int stat) {
		if (statPoint <= 0)
			return;

		// 올릴 수 있는 스텟만 올리고
		switch (stat) {
			case Type.Status.STR:
				pureStr++;
				ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getStr() }));
				break;
			case Type.Status.DEX:
				pureDex++;
				ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getDex() }));
				break;
			case Type.Status.AGI:
				pureAgi++;
				ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getAgi() }));
				break;
			default:
				return;
		}

		// 스포 하나 까자
		statPoint--;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.STAT_POINT }, new Integer[]{ statPoint }));
	}

	public void removeEquipItem(int type) {

	}
	
	// 아이템 장착
	public void equipItem(int type, int index) {
		int oldEquip = 0;

		switch (type) {
			case Type.Item.WEAPON:
				oldEquip = weapon;
				weapon = index;
				break;
			case Type.Item.SHIELD:
				oldEquip = shield;
				shield = index;
				break;
			case Type.Item.HELMET:
				oldEquip = helmet;
				helmet = index;
				break;
			case Type.Item.ARMOR:
				oldEquip = armor;
				armor = index;
				break;
			case Type.Item.CAPE:
				oldEquip = cape;
				cape = index;
				break;
			case Type.Item.SHOES:
				oldEquip = shoes;
				shoes = index;
				break;
			case Type.Item.ACCESSORY:
				oldEquip = accessory;
				accessory = index;
				break;
			default:
				return;
		}

		// 이전에 장착했던 아이템과 현재 장착한 아이템
		GameData.Item lastEquippedItem = findItemByIndex(oldEquip);
		GameData.Item nowEquipItem = findItemByIndex(index);

		// 장착 상태 변경 후 인벤토리 업데이트
		if (lastEquippedItem != null) {
			lastEquippedItem.setEquipped(false);
			ctx.writeAndFlush(Packet.updateInventory(1, lastEquippedItem));
		}

		if (nowEquipItem != null) {
			nowEquipItem.setEquipped(true);
			ctx.writeAndFlush(Packet.updateInventory(1, nowEquipItem));
		}

		if (getMaxHp() < hp)
			hp = getMaxHp();

		if (getMaxMp() < mp)
			mp = getMaxMp();

		// TODO : Type.Status.WEAPON + type는 임시. 수정 요망
		ctx.writeAndFlush(Packet.updateStatus(
				new int[]{ Type.Status.WEAPON + type, Type.Status.STR, Type.Status.DEX, Type.Status.AGI, Type.Status.MAX_HP, Type.Status.HP,
						Type.Status.MAX_MP, Type.Status.MP, Type.Status.CRITICAL, Type.Status.AVOID, Type.Status.HIT },
				new Integer[]{ index, getStr(), getDex(), getAgi(), getMaxHp(), hp, getMaxMp(), mp, getCritical(), getAvoid(), getHit() }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(Type.Character.USER, no,
				new int[]{ Type.Status.MAX_HP, Type.Status.HP }, new Integer[]{ getMaxHp(), hp }));
	}

	// 아이템 번호로 아이템 획득
	public boolean gainItem(int itemNo, int num) {
		int gap = 0;
		int index = getEmptyIndex();
		GameData.ItemData item = GameData.item.get(itemNo);
		GameData.Item itemData = findLazyItemByNo(itemNo);

		// 이미 있던 아이템일 경우 채워줌
		if (itemData != null) {
			gap = itemData.getAmount() + num - item.getMaxLoad();
			itemData.changeAmount(num);
			num = gap;
			ctx.writeAndFlush(Packet.updateInventory(1, itemData));
		}

		while (num > 0) {
			if (index == -1) {
				// 나머지 아이템 드랍
				Map.getMap(map).getField(seed).loadDropItem(itemNo, num, x, y);
				return false;
			}
			// 계속해서 아이템 채우자
			inventory.put(index, new GameData.Item(no, itemNo, num, index, item.isTradeable() ? 1 : 0));
			ctx.writeAndFlush(Packet.setInventory(inventory.get(index)));
			index = getEmptyIndex();
			num -= item.getMaxLoad();
		}

		return true;
	}

	// 능력치 있는 장비 아이템 획득
	public boolean gainItem(int itemNo, GameData.Item item) {
		int index = getEmptyIndex();

		if (index == -1)
			return false;

		inventory.put(index, new GameData.Item(no, item.getNo(), index, item));
		ctx.writeAndFlush(Packet.setInventory(inventory.get(index)));

		return true;
	}

	// 아이템 No로 아이템 잃음 (퀘스트 등)
	public boolean loseItemByNo(int itemNo, int num) {
		if (itemNo <= 0 || num <= 0)
			return false;
		
		int gap = 0;
		GameData.Item item = findItemByNo(itemNo);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || getTotalItemAmount(item.getNo()) < num)
			return false;

		// 모든 아이템을 잃을 때까지 반복
		do {
			gap = num - item.getAmount();
			item.changeAmount(-num);
			if (item.getAmount() == 0) {
				// 아이템 삭제
				inventory.remove(item.getIndex());
				ctx.writeAndFlush(Packet.updateInventory(0, item));
			} else {
				// 아이템 갯수 업데이트
				ctx.writeAndFlush(Packet.updateInventory(1, item));
			}
			num = gap;
		} while (num > 0);

		return true;
	}

	// Index로 아이템 잃음 (직접 드랍하는 경우)
	public boolean loseItemByIndex(int index, int num) {
		GameData.Item item = findItemByIndex(index);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || item.getAmount() < num)
			return false;

		item.changeAmount(-num);
		if (item.getAmount() == 0) {
			// 아이템 삭제
			inventory.remove(item.getIndex());
			ctx.writeAndFlush(Packet.updateInventory(0, item));
		} else {
			// 아이템 갯수 업데이트
			ctx.writeAndFlush(Packet.updateInventory(1, item));
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
	public int getTotalItemAmount(int itemNo) {
		int num = 0;
		for (GameData.Item item : inventory.values()) {
			if (item.getNo() == itemNo)
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
	public GameData.Item findItemByNo(int itemNo) {
		for (GameData.Item item : inventory.values()) {
			if (item.getNo() == itemNo)
				return item;
		}

		return null;
	}

	// No로 여유 있는 아이템 검색
	public GameData.Item findLazyItemByNo(int itemNo) {
		for (GameData.Item item : inventory.values()) {
			// 아이템이 꽉 찬 경우가 아니라면
			if (item.getNo() == itemNo && item.getAmount() < GameData.item.get(item.getNo()).getMaxLoad())
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

		if (presentItem.isEquipped())
			return;

		if (targetItem != null) {
			if (targetItem.isEquipped())
				return;

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

		GameData.ItemData itemData = GameData.item.get(item.getNo());

		// 레벨이 낮으면 반환
		if (level < itemData.getLimitLevel())
			return false;

		// 직업이 다르고 아이템도 공용이 아니면 반환
		if (job != itemData.getJob() && itemData.getJob() != 0)
			return false;

		// 소모품이면 아이템 잃음
		if (itemData.isConsumable())
			loseItemByIndex(index, amount);

		// 아이템이 아니라면 장착해보자
		if (itemData.getType() != Type.Item.ITEM)
			equipItem(itemData.getType(), item.getIndex());

		// 함수가 있을 경우 실행
		String function = itemData.getFunction();
		if (function != "")
			Functions.execute(Functions.item, function, new Object[] { this, item });

		return true;
	}

	// No로 아이템 사용
	public boolean useItemByNo(int itemNo, int amount) {
		GameData.Item item = findItemByNo(itemNo);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount)
			return false;

		GameData.ItemData itemData = GameData.item.get(item.getNo());

		// 레벨이 낮으면 반환
		if (level < itemData.getLimitLevel())
			return false;

		// 직업이 다르고 아이템도 공용이 아니면 반환
		if (job != itemData.getJob() && itemData.getJob() != 0)
			return false;

		// 소모품이면 아이템 잃음
		if (itemData.isConsumable())
			loseItemByNo(itemNo, amount);

		// 함수가 있을 경우 실행
		String function = GameData.item.get(item.getNo()).getFunction();
		if (function != "")
			Functions.execute(Functions.item, function, new Object[] { this, item });

		return true;
	}

	// No로 아이템 버리기
	public boolean dropItemByNo(int itemNo, int amount) {
		GameData.Item item = findItemByNo(itemNo);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0)
			return false;

		GameData.ItemData itemData = GameData.item.get(item.getNo());

		loseItemByNo(itemNo, amount);
		if (itemData.getType() == Type.Item.ITEM)
			Map.getMap(no).getField(seed).loadDropItem(itemNo, amount, x, y);
		else
			Map.getMap(no).getField(seed).loadDropItem(itemNo, item, x, y);

		return true;
	}

	// Index로 아이템 버리기
	public boolean dropItemByIndex(int index, int amount) {
		GameData.Item item = findItemByIndex(index);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0)
			return false;

		GameData.ItemData itemData = GameData.item.get(item.getNo());

		loseItemByIndex(index, amount);
		if (itemData.getType() == Type.Item.ITEM)
			Map.getMap(no).getField(seed).loadDropItem(item.getNo(), amount, x, y);
		else
			Map.getMap(no).getField(seed).loadDropItem(item.getNo(), item, x, y);

		return true;
	}

	public boolean dropGold(int amount) {
		if (gold < amount)
			return false;

		loseGold(amount);
		Map.getMap(no).getField(seed).loadDropGold(amount, x, y);

		return true;
	}

	// 아이템 줍기
	public void pickItem() {
		Field field = Map.getMap(map).getField(seed);
		// 골드 먼저 줍자
		Field.DropGold dropGold = field.pickGold(x, y);
		Field.DropItem dropItem;

		// 골드가 없다면
		if (dropGold == null) {
			// 아이템을 줍자
			dropItem = field.pickItem(x, y);

			// 아이템도 없다면 반환
			if (dropItem == null)
				return;
		}
		else {
			// 골드가 있다면 획득하고 반환
			gainGold(dropGold.getAmount());
			field.removeDropGold(dropGold);

			return;
		}

		// 비어있는 인덱스를 획득
		int index = getEmptyIndex();
		if (index == -1)
			return;

		GameData.ItemData itemData = GameData.item.get(dropItem.getItemNo());

		if (itemData.getType() != Type.Item.ITEM) {
			// 장비 아이템일 경우 기존 능력치 얻어가자
			gainItem(dropItem.getItemNo(), dropItem.getItem());
		} else {
			// 일반 아이템일 경우 그냥 얻자
			gainItem(dropItem.getItemNo(), dropItem.getAmount());
		}

		field.removeDropItem(dropItem);
	}

	// No로 스킬 검색
	public GameData.Skill findSkillByNo(int skillNo) {
		if (!skillList.containsKey(skillNo))
			return null;

		return skillList.get(skillNo);
	}

	// 스킬 배우기
	public boolean studySkill(int skillNo) {
		if (skillList.containsKey(skillNo))
			return false;

		skillList.put(skillNo, new GameData.Skill(no, skillNo));
		return true;
	}

	// 스킬 지우기
	public boolean forgetSkill(int skillNo) {
		if (!skillList.containsKey(skillNo))
			return false;

		skillList.remove(skillNo);
		return true;
	}

	// No로 스킬 사용
	public boolean useSkill(int skillNo) {
		GameData.Skill skill = findSkillByNo(skillNo);

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
		for (Enemy enemy : Map.getMap(map).getField(seed).getAliveEnemies()) {
			if (enemy.getX() == new_x && enemy.getY() == new_y) {
				assault(enemy);
				return;
			}
		}
	}

	// 적 공격
	public void assault(Character target) {
		jump(0, 0);
		target.animation(8);

		// 실 데미지를 계산
		int attackDamage = (getDamage() - target.getDefense()) *  (getDamage() - target.getDefense());
		boolean isFatal = getCritical() > random.nextInt(100);
		if (isFatal) attackDamage *= 2;

		if (target.getClass().getName().equals("game.Enemy")) {
			// 타겟이 에너미인 경우
			Enemy e = (Enemy) target;
			e.displayDamage(attackDamage, isFatal);
			e.loseHp(attackDamage);
		} else if (target.getClass().getName().equals("game.User")) {
			// 타겟이 유저인 경우
			User u = (User) target;
			u.displayDamage(attackDamage, isFatal);
			u.loseHp(attackDamage);
		}
	}

	public void update() {

	}

	// 좌표 이동
	public void move(int type) {
		switch (type) {
			case Type.Direction.DOWN:
				moveDown();
				break;
			case Type.Direction.LEFT:
				moveLeft();
				break;
			case Type.Direction.RIGHT:
				moveRight();
				break;
			case Type.Direction.UP:
				moveUp();
				break;
		}
	}

	// 이동이 불가능한 경우 리프레쉬
	protected boolean moveUp() {
		if (!super.moveUp())
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));

		return true;
	}

	protected boolean moveDown() {
		if (!super.moveDown())
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));

		return true;
	}

	protected boolean moveLeft() {
		if (!super.moveLeft())
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));

		return true;
	}

	protected boolean moveRight() {
		if (!super.moveRight())
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));

		return true;
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

	// 게임 종료
	public void exitGracefully() {
		// 맵에서 나가기
		Map.getMap(map).getField(seed).removeUser(this);

		// 유저 정보 업데이트
		DataBase.updateUser(this);
		// 장착 아이템 정보 업데이트
		DataBase.updateEquip(this);

		// 아이템과 스킬을 지운다
		DataBase.deleteItem(no);
		DataBase.deleteSkill(no);

		// 가진 아이템과 스킬을 넣자
		for (GameData.Item item : inventory.values())
			DataBase.insertItem(item);
		for (GameData.Skill skill : skillList.values())
			DataBase.insertSkill(skill);
	}
}
