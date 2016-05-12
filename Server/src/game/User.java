package game;

import io.netty.channel.ChannelHandlerContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

import packet.Packet;
import database.*;
import database.GameData.*;

public class User extends Character {
	private ChannelHandlerContext ctx;
	// 유저 정보
	private String id;
	private String pass;
	private String mail;
	private int guildNo;
	private int job;
	private int pureStr;
	private int pureDex;
	private int pureAgi;
	private int statPoint;
	private int skillPoint;
	private int title;
	private boolean admin;
	// 장착 아이템
	private int weapon = 0;
	private int shield = 0;
	private int helmet = 0;
	private int armor = 0;
	private int cape = 0;
	private int shoes = 0;
	private int accessory = 0;
    // 인벤토리 등
	private int maxInventory = 35;
	private Hashtable<Integer, Item> itemBag = new Hashtable<>();
	private Hashtable<Integer, Skill> skillBag = new Hashtable<>();
	// 거래 관련
	private int tradePartner;
	private Hashtable<Integer, Item>  tradeItemList = new Hashtable<>();
	private int tradeGold;
	private boolean isAcceptTrade = false;
	// 커뮤니티 관련
	private int partyNo;
	// NPC 관련
	private Message message = new Message();

	private static Hashtable<ChannelHandlerContext, User> users = new Hashtable<ChannelHandlerContext, User>();
	private static Logger logger = Logger.getLogger(User.class.getName());

	public static boolean put(ChannelHandlerContext ctx, User user) {
		if (users.containsKey(ctx))
			return false;

		users.put(ctx, user);
		return true;
	}

	public static User get(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx))
			return null;

		return users.get(ctx);
	}

	public static User get(int userNo) {
		for (User u : users.values())
			if (u.getNo() == userNo)
				return u;

		return null;
	}

	public static Hashtable<ChannelHandlerContext, User> getAll() {
		return users;
	}

	public static boolean remove(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx))
			return false;

		users.get(ctx).exitGracefully();
		users.remove(ctx);
		return true;
	}

	public User(ChannelHandlerContext _ctx, ResultSet rs) {
		try {
			ctx = _ctx;
			no = rs.getInt("no");
			id = rs.getString("id");
			pass = rs.getString("pass");
			name = rs.getString("name");
			title = rs.getInt("title");
			guildNo = rs.getInt("guild");
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

	// 타이틀
	public int getTitle() {
		return title;
	}

	public void setTitle(int _title) {
		title = _title;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.TITLE }, new Integer[]{ title }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{ Type.Status.TITLE }, new Integer[]{ title }));
	}

	// 길드
	public int getGuild() {
		return guildNo;
	}

	public void setGuild(int _guild) {
		guildNo = _guild;
		ctx.writeAndFlush(Packet.setGuild(guildNo));
	}
	
	public String getMail() {
		return mail;
	}

	// 이미지
	public void setImage(String _image) {
		image = _image;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.IMAGE }, new String[]{ image }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{ Type.Status.IMAGE }, new String[]{ image }));
	}

	// 직업
	public int getJob() {
		return job;
	}

	public void setJob(int _job) {
		job = _job;
		ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.JOB }, new Integer[]{ job }));
		Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
				new int[]{ Type.Status.JOB }, new Integer[]{ job }));
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

		ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.EXP}, new Integer[]{exp}));
	}

	// 경험치 잃음
	public void loseExp(int value) {
		if (exp - value < 0)
			value = exp;

		gainExp(-value);
	}

	public void gainGold(int value) {
		gold += value;

		ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.GOLD}, new Integer[]{gold}));
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

	// 정보 가져오기
	public void loadData() {
		loadEquipItem();
		loadInventory();
		loadSkillList();
		loadGuildMember();
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
				itemBag.put(rs.getInt("index"), new Item(rs));
				ctx.writeAndFlush(Packet.setItem(itemBag.get(rs.getInt("index"))));
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
				skillBag.put(rs.getInt("skill_no"), new Skill(no, rs.getInt("skill_no")));
				ctx.writeAndFlush(Packet.setSkill(skillBag.get(rs.getInt("skill_no"))));
			}

			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 길드 멤버 불러오기
	public void loadGuildMember() {
		if (guildNo == 0)
			return;

		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `guild` = '" + guildNo + "';");

			while (rs.next()) {
				User member = User.get(rs.getInt("no"));

				if (member == null)
					ctx.writeAndFlush(Packet.setGuildMember(rs.getInt("no"), rs.getString("name"), rs.getString("image"),
							rs.getInt("level"), rs.getInt("job"), rs.getInt("hp"), rs.getInt("hp")));
				else
					ctx.writeAndFlush(Packet.setGuildMember(member));
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
		ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.STAT_POINT}, new Integer[]{statPoint}));
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
		Item lastEquippedItem = findItemByIndex(oldEquip);
		Item nowEquipItem = findItemByIndex(index);

		// 장착 상태 변경 후 인벤토리 업데이트
		if (lastEquippedItem != null) {
			lastEquippedItem.setEquipped(false);
			ctx.writeAndFlush(Packet.updateItem(1, lastEquippedItem));
		}

		if (nowEquipItem != null) {
			nowEquipItem.setEquipped(true);
			ctx.writeAndFlush(Packet.updateItem(1, nowEquipItem));
		}

		// HP, MP 보정
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
		ItemData itemData = GameData.item.get(itemNo);
		Item item = findLazyItemByNo(itemNo);

		// 이미 있던 아이템일 경우 채워줌
		if (item != null) {
			gap = item.getAmount() + num - itemData.getMaxLoad();
			item.addAmount(num);
			num = gap;
			ctx.writeAndFlush(Packet.updateItem(1, item));
		}

		while (num > 0) {
			if (index == -1) {
				// 나머지 아이템 드랍
				Map.getMap(map).getField(seed).loadDropItem(itemNo, num, x, y);
				return false;
			}
			// 계속해서 아이템 채우자
			itemBag.put(index, new Item(no, itemNo, num, index, itemData.isTradeable() ? 1 : 0));
			ctx.writeAndFlush(Packet.setItem(itemBag.get(index)));
			index = getEmptyIndex();
			num -= itemData.getMaxLoad();
		}

		return true;
	}

	// 능력치 있는 장비 아이템 획득
	public boolean gainItem(int itemNo, Item item) {
		int index = getEmptyIndex();

		if (index == -1)
			return false;

		itemBag.put(index, new Item(no, item.getNo(), index, item));
		ctx.writeAndFlush(Packet.setItem(itemBag.get(index)));

		return true;
	}

	// 아이템 No로 아이템 잃음 (퀘스트 등)
	public boolean loseItemByNo(int itemNo, int num) {
		if (itemNo <= 0 || num <= 0)
			return false;
		
		int gap = 0;
		Item item = findItemByNo(itemNo);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || getTotalItemAmount(item.getNo()) < num)
			return false;

		// 모든 아이템을 잃을 때까지 반복
		do {
			gap = num - item.getAmount();
			item.addAmount(-num);
			if (item.getAmount() == 0) {
				// 아이템 삭제
				itemBag.remove(item.getIndex());
				ctx.writeAndFlush(Packet.updateItem(0, item));
			} else {
				// 아이템 갯수 업데이트
				ctx.writeAndFlush(Packet.updateItem(1, item));
			}
			num = gap;
		} while (num > 0);

		return true;
	}

	// Index로 아이템 잃음 (직접 드랍하는 경우)
	public boolean loseItemByIndex(int index, int num) {
		Item item = findItemByIndex(index);

		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || item.getAmount() < num)
			return false;

		item.addAmount(-num);
		if (item.getAmount() == 0) {
			// 아이템 삭제
			itemBag.remove(item.getIndex());
			ctx.writeAndFlush(Packet.updateItem(0, item));
		} else {
			// 아이템 갯수 업데이트
			ctx.writeAndFlush(Packet.updateItem(1, item));
		}

		return true;
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 1; i <= maxInventory; i++) {
			if (!itemBag.containsKey(i))
				return i;
		}
		
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getTotalItemAmount(int itemNo) {
		int num = 0;
		for (Item item : itemBag.values()) {
			if (item.getNo() == itemNo)
				num += item.getAmount();
		}
		
		return num;
	}
	
	// Index로 아이템 검색
	public Item findItemByIndex(int index) {
		if (!itemBag.containsKey(index))
			return null;
		
		return itemBag.get(index);
	}

	// No로 아이템 검색
	public Item findItemByNo(int itemNo) {
		for (Item item : itemBag.values()) {
			if (item.getNo() == itemNo)
				return item;
		}

		return null;
	}

	// No로 여유 있는 아이템 검색
	public Item findLazyItemByNo(int itemNo) {
		for (Item item : itemBag.values()) {
			// 아이템이 꽉 찬 경우가 아니라면
			if (item.getNo() == itemNo && item.getAmount() < GameData.item.get(item.getNo()).getMaxLoad())
				return item;
		}

		return null;
	}

	// 아이템 인덱스 변경
	public void changeItemIndex(int index1, int index2) {
		Item presentItem = findItemByIndex(index1);
		Item targetItem = findItemByIndex(index2);

		// 아이템이 없으면 반환
		if (presentItem == null)
			return;

		if (presentItem.isEquipped())
			return;

		if (targetItem != null) {
			if (targetItem.isEquipped())
				return;

			// 아이템 간 인덱스 변경
			itemBag.remove(index1);
			itemBag.remove(index2);
			presentItem.setIndex(index2);
			targetItem.setIndex(index1);
			itemBag.put(index2, presentItem);
			itemBag.put(index1, targetItem);

			ctx.write(Packet.setItem(presentItem));
			ctx.writeAndFlush(Packet.setItem(targetItem));
		} else {
			// 빈 곳으로 아이템 이동
			ctx.write(Packet.updateItem(0, presentItem));
			itemBag.remove(index1);
			presentItem.setIndex(index2);
			itemBag.put(index2, presentItem);
			ctx.writeAndFlush(Packet.setItem(presentItem));
		}

	}

	// Index로 아이템 사용
	public boolean useItemByIndex(int index, int amount) {
		Item item = findItemByIndex(index);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount)
			return false;

		ItemData itemData = GameData.item.get(item.getNo());

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
			Functions.execute(Functions.item, function, new Object[]{this, item});

		return true;
	}

	// No로 아이템 사용
	public boolean useItemByNo(int itemNo, int amount) {
		Item item = findItemByNo(itemNo);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount)
			return false;

		ItemData itemData = GameData.item.get(item.getNo());

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
			Functions.execute(Functions.item, function, new Object[]{this, item});

		return true;
	}

	// No로 아이템 버리기
	public boolean dropItemByNo(int itemNo, int amount) {
		Item item = findItemByNo(itemNo);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0)
			return false;

		ItemData itemData = GameData.item.get(item.getNo());

		loseItemByNo(itemNo, amount);
		if (itemData.getType() == Type.Item.ITEM)
			Map.getMap(no).getField(seed).loadDropItem(itemNo, amount, x, y);
		else
			Map.getMap(no).getField(seed).loadDropItem(itemNo, item, x, y);

		return true;
	}

	// Index로 아이템 버리기
	public boolean dropItemByIndex(int index, int amount) {
		Item item = findItemByIndex(index);

		// 아이템이 없으면 반환
		if (item == null)
			return false;

		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0)
			return false;

		ItemData itemData = GameData.item.get(item.getNo());

		loseItemByIndex(index, amount);
		if (itemData.getType() == Type.Item.ITEM)
			Map.getMap(no).getField(seed).loadDropItem(item.getNo(), amount, x, y);
		else
			Map.getMap(no).getField(seed).loadDropItem(item.getNo(), item, x, y);

		return true;
	}

	// 골드 버리기
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

		ItemData itemData = GameData.item.get(dropItem.getItemNo());

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
		if (!skillBag.containsKey(skillNo))
			return null;

		return skillBag.get(skillNo);
	}

	// 스킬 배우기
	public boolean studySkill(int skillNo) {
		if (skillBag.containsKey(skillNo))
			return false;

		GameData.Skill skill = new GameData.Skill(no, skillNo);
		skillBag.put(skillNo, skill);
		ctx.writeAndFlush(Packet.setSkill(skill));
		return true;
	}

	// 스킬 지우기
	public boolean forgetSkill(int skillNo) {
		if (!skillBag.containsKey(skillNo))
			return false;

		ctx.writeAndFlush(Packet.updateSkill(0, skillBag.get(skillNo)));
		skillBag.remove(skillNo);
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
			Functions.execute(Functions.skill, function, new Object[]{this, skill});

		return true;
	}

	// 거래 요청
	public boolean requestTrade(int partnerNo) {
		User partner = User.get(partnerNo);

		// 거래 중이라면 반환
		if (nowTrading())
			return false;

		// 파트너가 없으면 반환
		if (partner == null)
			return false;

		// 상대 유저가 거래중이라면 반환
		if (partner.nowTrading())
			return false;

		// 거래 요청
		partner.getCtx().writeAndFlush(Packet.requestTrade(no));
		return true;
	}

	// 거래 수락 및 거절
	public void responseTrade(int type, int partnerNo) {
		User partner = User.get(partnerNo);

		// 파트너가 없으면 반환
		if (partner == null)
			return;

		// 파트너가 교환중이면 반환
		if (partner.nowTrading())
			return;

		switch (type) {
			case 0:
				// 수락
				tradePartner = partnerNo;
				ctx.writeAndFlush(Packet.openTradeWindow(partnerNo));
				partner.tradePartner = no;
				partner.getCtx().writeAndFlush(Packet.openTradeWindow(no));
				break;
			case 1:
				// 거절
				//partner.finishTrade();
				break;
		}
	}

	// 거래 아이템 올리기
	public void loadTradeItem(int index, int amount, int tradeIndex) {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		// 거래 종료 대기 중이라면 반환
		if (isAcceptTrade || User.get(tradePartner).isAcceptTrade)
			return;

		Item item = findItemByIndex(index);

		// 아이템이 없다면 반환
		if (item == null)
			return;

		// 거래 불가능한 아이템일 경우 반환
		if (!item.isTradeable())
			return;

		// 장착중이라면 반환
		if (item.isEquipped())
			return;

		// 소지 갯수보다 거래하려는 갯수가 많을 경우 반환
		if (item.getAmount() < amount)
			return;

		// 해당 공간에 이미 아이템이 있는 경우 반환
		if (tradeItemList.containsKey(tradeIndex))
			return;

		// 거래하려는 아이템을 거래 목록에 올림
		Item tradeItem = item.clone();
		tradeItem.setIndex(tradeIndex);
		tradeItem.setAmount(amount);
		tradeItemList.put(tradeIndex, tradeItem);

		// 아이템 잃음
		loseItemByIndex(index, amount);

		// 거래 아이템 로드
		ctx.writeAndFlush(Packet.loadTradeItem(tradeItem));
		User.get(tradePartner).getCtx().writeAndFlush(Packet.loadTradeItem(tradeItem));
	}

	// 거래 아이템 내리기
	public void dropTradeItem(int index) {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		// 거래 종료 대기 중이라면 반환
		if (isAcceptTrade || User.get(tradePartner).isAcceptTrade)
			return;

		// 아이템이 없으면 반환
		if (!tradeItemList.containsKey(index))
			return;

		Item item = tradeItemList.get(index);
		ItemData itemData = GameData.item.get(item.getNo());

		// 일반 아이템일 경우 그냥 얻고, 장비 아이템일 경우 능력치 보존
		if (itemData.getType() == Type.Item.ITEM)
			gainItem(item.getNo(), item.getAmount());
		else
			gainItem(item.getNo(), item);

		// 거래 아이템 리스트에서 제거
		tradeItemList.remove(index);

		// 거래 아이템 삭제
		ctx.writeAndFlush(Packet.dropTradeItem(no, index));
		User.get(tradePartner).getCtx().writeAndFlush(Packet.dropTradeItem(no, index));
	}

	// 거래 골드 변경
	public void changeTradeGold(int value) {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		// 거래 종료 대기 중이라면 반환
		if (isAcceptTrade || User.get(tradePartner).isAcceptTrade)
			return;

		// 가진 골드와 거래중인 골드의 합보다 많으면 반환
		if (tradeGold + gold < value)
			return;

		gainGold(tradeGold);
		loseGold(value);
		tradeGold = value;

		// 골드 변경하렴
		ctx.writeAndFlush(Packet.changeTradeGold(no, tradeGold));
		User.get(tradePartner).getCtx().writeAndFlush(Packet.changeTradeGold(no, tradeGold));
	}

	// 거래 종료 대기
	public void acceptTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		User partner = User.get(tradePartner);

		// 상대방도 거래 종료 대기 중이라면
		if (partner.isAcceptTrade)
			finishTrade();
		else
			isAcceptTrade = true;

		ctx.writeAndFlush(Packet.acceptTrade(no));
		partner.getCtx().writeAndFlush(Packet.acceptTrade(no));
	}

	// 거래 종료
	public void finishTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		User partner = User.get(tradePartner);

		// 아이템 및 골드 획득
		for (Item i : partner.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());

			if (iData.getType() == Type.Item.ITEM)
				gainItem(i.getNo(), i.getAmount());
			else
				gainItem(i.getNo(), i);
		}
		gainGold(partner.tradeGold);

		// 파트너 아이템 및 골드 획득
		for (Item i : tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());

			if (iData.getType() == Type.Item.ITEM)
				partner.gainItem(i.getNo(), i.getAmount());
			else
				partner.gainItem(i.getNo(), i);
		}
		partner.gainGold(tradeGold);

		// 거래 관련 변수 초기화
		tradePartner = 0;
		isAcceptTrade = false;
		tradeGold = 0;
		tradeItemList.clear();

		partner.tradePartner = 0;
		partner.isAcceptTrade = false;
		partner.tradeGold = 0;
		partner.tradeItemList.clear();
	}

	// 거래 취소
	public void cancelTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading())
			return;

		// 아이템 및 골드 돌려받기
		for (Item i : tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());

			if (iData.getType() == Type.Item.ITEM)
				gainItem(i.getNo(), i.getAmount());
			else
				gainItem(i.getNo(), i);
		}
		gainGold(tradeGold);

		// 파트너 아이템 및 골드 돌려받기
		User partner = User.get(tradePartner);
		for (Item i : partner.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());

			if (iData.getType() == Type.Item.ITEM)
				partner.gainItem(i.getNo(), i.getAmount());
			else
				partner.gainItem(i.getNo(), i);
		}
		partner.gainGold(partner.tradeGold);

		// 거래 관련 변수 초기화
		tradePartner = 0;
		isAcceptTrade = false;
		tradeGold = 0;
		tradeItemList.clear();

		partner.tradePartner = 0;
		partner.isAcceptTrade = false;
		partner.tradeGold = 0;
		partner.tradeItemList.clear();

		ctx.writeAndFlush(Packet.cancelTrade());
		partner.getCtx().writeAndFlush(Packet.cancelTrade());
	}

	// 거래 중 여부
	public boolean nowTrading() {
		// 거래 중이 아니라면
		if (tradePartner == 0)
			return false;

		// 거래 상대 없다면
		if (User.get(tradePartner) == null) {
			cancelTrade();
			return false;
		}

		return true;
	}

	// 상점 열기
	public void openShop(int _no) {
		ctx.writeAndFlush(Packet.openShopWindow(_no));
		for (ItemData shopItem : GameData.shop.get(_no).getAllItems().values()) {
			ctx.writeAndFlush(Packet.setShopItem(shopItem.getNo(), shopItem.getPrice()));
		}
	}

	// 상점 아이템 구매
	public void buyShopItem(int _shopNo, int _index, int _amount) {
		if (!GameData.shop.containsKey(_shopNo))
			return;

		Shop shop = GameData.shop.get(_shopNo);

		if (shop.getItem(_index) == null)
			return;

		ItemData item = shop.getItem(_index);

		if (item.getType() == Type.Item.ITEM)
			_amount = _amount > item.getMaxLoad() ? item.getMaxLoad() : _amount;
		else
			_amount = 1;

		if (gold < item.getPrice() * _amount)
			return;

		loseGold(item.getPrice() * _amount);
		gainItem(item.getNo(), _amount);
	}

	// 파티 번호 설정
	public void setPartyNo(int _partyNo) {
		partyNo = _partyNo;
		ctx.writeAndFlush(Packet.setParty(partyNo));
	}

	// 파티 번호 얻기
	public int getPartyNo() {
		return partyNo;
	}

	// 파티 생성
	public void createParty() {
		// 이미 파티가 있다면 반환
		if (nowJoinParty())
			return;

		// 파티를 생성
		Party.add(no);
	}

	// 파티 요청
	public void inviteParty(int _other) {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty())
			return;

		// 파티 멤버수가 최대라면 반환
		if (Party.get(partyNo).getMembers().size() >= 4)
			return;

		User other = User.get(_other);
		User master = User.get(partyNo);

		// 파티 마스터가 없다면 반환
		if (master == null)
			return;

		// 상대 유저가 없다면 반환
		if (other == null)
			return;

		// 상대에게 이미 파티가 있다면 반환
		if (other.partyNo > 0)
			return;

		// 파티 요청
		other.getCtx().writeAndFlush(Packet.inviteParty(partyNo, master.getName()));
	}

	// 파티 응답
	public void responseParty(int _type, int _partyNo) {
		// 이미 가입한 파티가 있다면 반환
		if (nowJoinParty())
			return;

		switch (_type) {
			case 0:
				// 수락
				Party.get(_partyNo).join(no);
				break;
			case 1:
				// 거절
				break;
		}
	}

	// 파티 나가기
	public void quitParty() {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty())
			return;

		// 파티 탈퇴
		Party.get(partyNo).exit(no);
	}

	// 파티 강퇴
	public void kickParty(int _member) {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty())
			return;

		// 파티 마스터가 아니라면 반환
		if (partyNo != no)
			return;

		// 마스터를 강퇴하려 하면 반환
		if (_member == partyNo)
			return;

		Party.get(partyNo).exit(_member);
	}

	// 파티 해체
	public void breakUpParty() {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty())
			return;

		// 파티 마스터가 아니라면 반환
		if (partyNo != no)
			return;

		Party.get(partyNo).breakUp();
	}

	// 파티 가입 여부
	private boolean nowJoinParty() {
		// 가입한 파티가 없다면
		if (partyNo == 0)
			return false;

		Party party = Party.get(partyNo);

		// 해당 파티가 없다면
		if (party == null) {
			partyNo = 0;
			return false;
		}

		return true;
	}

	// 길드 생성
	public void createGuild(String _guildName) {
		// 가입한 길드가 있다면 반환
		if (nowJoinGuild())
			return;

		// 소지금이 적으면 반환
		if (gold < 100000)
			return;

		loseGold(100000);
		Guild.add(no, _guildName);
	}

	// 길드 요청
	public void inviteGuild(int _other) {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild())
			return;

		// 길드 멤버수가 최대라면 반환
		if (Guild.get(guildNo).getMembers().size() >= 40)
			return;

		User other = User.get(_other);
		User master = User.get(Guild.get(guildNo).getMaster());

		// 마스터가 없다면 반환
		if (master == null)
			return;

		// 자신이 마스터가 아니라면 반환
		if (!this.equals(master))
			return;

		// 상대 유저가 없다면 반환
		if (other == null)
			return;

		// 상대에게 이미 길드가 있다면 반환
		if (other.guildNo > 0)
			return;

		// 길드 요청
		other.getCtx().writeAndFlush(Packet.inviteGuild(guildNo, master.getName()));
	}

	// 길드 응답
	public void responseGuild(int _type, int _guildNo) {
		// 이미 가입한 파티가 있다면 반환
		if (nowJoinGuild())
			return;

		switch (_type) {
			case 0:
				// 수락
				Guild.get(_guildNo).join(no);
				break;
			case 1:
				// 거절
				break;
		}
	}
	
	// 길드 나가기
	public void quitGuild() {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild())
			return;

		// 길드 탈퇴
		Guild.get(guildNo).exit(no);
	}

	// 길드 강퇴
	public void kickGuild(int _member) {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild())
			return;

		// 길드 마스터가 아니라면 반환
		if (guildNo != no)
			return;

		// 마스터를 강퇴하려 하면 반환
		if (_member == guildNo)
			return;

		Guild.get(guildNo).exit(_member);
	}

	// 길드 해체
	public void breakUpGuild() {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild())
			return;

		// 길드 마스터가 아니라면 반환
		if (guildNo != no)
			return;

		Guild.get(guildNo).breakUp();
	}

	// 길드 가입 여부
	private boolean nowJoinGuild() {
		// 가입한 파티가 없다면
		if (guildNo == 0)
			return false;

		Guild guild = Guild.get(guildNo);

		// 해당 길드가 없다면
		if (guild == null) {
			guildNo = 0;
			return false;
		}

		return true;
	}
	
	// 현재 대화 얻음
	public Message getMessage() {
		return message;
	}

	// 대화 업데이트
	public void updateMessage(int select) {
		for (Npc npc : Map.getMap(map).getField(seed).getNPCs()) {
			if (npc.getNo() == message.getNpc()) {
				message.mySelect = select;
				Functions.execute(Functions.npc, npc.getFunction(), new Object[]{ this, npc });
				break;
			}
		}
	}

	// 스페이스바 누를 경우 액션
	public void action() {
		// 다른 작업 중이라면 반환
		if (isBusy())
			return;

		int new_x = x + (direction == 6 ? 1 : direction == 4 ? -1 : 0);
		int new_y = y + (direction == 2 ? 1 : direction == 8 ? -1 : 0);

		// 에너미가 있을 경우 공격하고 반환
		for (Enemy enemy : Map.getMap(map).getField(seed).getAliveEnemies()) {
			if (enemy.getX() == new_x && enemy.getY() == new_y) {
				assault(enemy);
				return;
			}
		}

		// NPC가 있을 경우 대화하고 반환
		for (Npc npc : Map.getMap(map).getField(seed).getNPCs()) {
			if (npc.getX() == new_x && npc.getY() == new_y) {
				Functions.execute(Functions.npc, npc.getFunction(), new Object[]{ this, npc });
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

	// 채팅
	public void chat(String _message) {
		Vector<User> mapUsers = Map.getMap(map).getField(seed).getUsers();
		switch (_message.split(" ")[0]) {
			case "/공지":
				if (!admin)
					return;

				for (User u : users.values())
					u.getCtx().writeAndFlush(Packet.chat("[공지] " + _message.replace("/공지 ", ""), 255, 255, 255, 255, 0, 0));
				break;
			default:
				for (User u : mapUsers)
					u.getCtx().writeAndFlush(Packet.chat(name + " : " + _message));
				break;
		}
	}
	
	// 파티 채팅
	public void partyChat(String _message) {
 		if (!nowJoinParty())
 			return;
 		for (int members : Party.get(partyNo).getMembers()) {
 			User u = User.get(members);
 			u.getCtx().writeAndFlush(Packet.chat("[파티] " + name + " : " + _message, 0, 255, 0));
 		}
 	}
 
 	// 길드 채팅
 	public void guildChat(String _message) {
 		if (!nowJoinGuild())
 			return;
 		for (int members : Guild.get(guildNo).getMembers()) {
 			User u = User.get(members);
 			u.getCtx().writeAndFlush(Packet.chat("[길드] " + name + " : " + _message, 255, 255, 0));
 		}
 	}
 	
 	// 귓속말
 	public void whistle(String _target, String _message) {
 		// 타겟이 본인일 경우
 		if (name.equals(_target))
 			return;
 		// 메세지가 존재하지 않을 경우
 		if (_message == null)
 			return;
 		
 		for (User u : users.values()) {
 			if (u.getName().equals(_target)) {
 				u.getCtx().writeAndFlush(Packet.chat("[From:" + name + "] " + _message));
 				ctx.writeAndFlush(Packet.chat("[To:" + _target + "] " + _message));
 				return;
 			}
 		}
 		// 타겟이 접속중이 아닐 경우
 		return;
 	}

	// 다른 작업을 하고 있는지 (대화, 거래)
	private boolean isBusy() {
		// 대화 중
		if (message.isStart())
			return true;

		// 거래 중
		if (nowTrading())
			return true;

		return false;
	}

	public void update() {

	}

	// 좌표 이동
	public void move(int type) {
		// 다른 작업 중이라면 리프레쉬
		if (isBusy()) {
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));
			return;
		}

		// 이동
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

		// 맵 이동 여부 판정
		Field gameField = Map.getMap(map).getField(seed);
		for (Portal portal : gameField.getPortals()) {
			if (portal.getX() == x && portal.getY() == y) {
				gameField.removeUser(this);
				map = portal.getNextMap();
				x = portal.getNextX();
				y = portal.getNextY();
				Map.getMap(portal.getNextMap()).getField(seed).addUser(this);
			}
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
		// 다른 작업 중이라면 리프레쉬
		if (isBusy()) {
			ctx.writeAndFlush(Packet.refreshCharacter(characterType, no, x, y, direction));
			return;
		}

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
		// 거래중이라면 거래 종료
		if (nowTrading())
			cancelTrade();

		// 파티 가입중이라면 파티 탈퇴
		if (nowJoinParty()) {
			if (partyNo == no)
				breakUpParty();
			else
				quitParty();
		}

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
		for (Item item : itemBag.values())
			DataBase.insertItem(item);
		for (GameData.Skill skill : skillBag.values())
			DataBase.insertSkill(skill);
	}

	public class Message {
		private int npcNo;
		private int npcMessage;
		private int npcSelect;
		private int mySelect;

		// 대화 중 여부
		public boolean isStart() {
			return npcNo > 0;
		}

		// 현재 대화중인 NPC
		public int getNpc() {
			return npcNo;
		}

		// 현재 메시지
		public int getMessage() {
			return npcMessage;
		}

		// 선택한 선택지
		public int getSelect() {
			return mySelect;
		}

		// 대화 시작
		public void open(int _npcNo, int _npcSelect) {
			npcNo = _npcNo;
			npcMessage = 0;
			npcSelect = _npcSelect;

			ctx.writeAndFlush(Packet.openMessageWindow(npcNo, npcMessage, npcSelect));
		}

		// 대화 종료
		public void close() {
			npcNo = 0;

			ctx.writeAndFlush(Packet.closeMessageWindow());
		}

		// 대화 진행
		public void update(int message, int select) {
			npcMessage = message;
			npcSelect = select;

			ctx.writeAndFlush(Packet.openMessageWindow(npcNo, npcMessage, npcSelect));
		}
	}
}
