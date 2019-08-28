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
    // 말풍선
    private static int standardDelay = -1;
    private boolean isBalloonShowing = false;
    private long startChattingTime;
    // 쿨타임
	public CoolTime coolTime = new CoolTime();
	public CoolTime getCoolTime() { return coolTime; }
	private long lastTime = System.currentTimeMillis() / 100;

	private static Hashtable<ChannelHandlerContext, User> users = new Hashtable<ChannelHandlerContext, User>();
	private static Logger logger = Logger.getLogger(User.class.getName());

	public static boolean put(ChannelHandlerContext ctx, User user) {
		if (users.containsKey(ctx)) {
			return false;
		}
		users.put(ctx, user);
		return true;
	}

	public static User get(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx)) {
			return null;
		}
		return users.get(ctx);
	}

	public static User get(int userNo) {
		for (User u : users.values()) {
			if (u.getNo() == userNo) {
				return u;
			}
		}
		return null;
	}

	public static Hashtable<ChannelHandlerContext, User> getAll() {
		return users;
	}

	public static boolean remove(ChannelHandlerContext ctx) {
		if (!users.containsKey(ctx)) {
			return false;
		}
		users.get(ctx).exitGracefully();
		users.remove(ctx);
		return true;
	}

	public User(ChannelHandlerContext ctx, ResultSet rs) {
		try {
			this.ctx = ctx;
			this.no = rs.getInt("no");
			this.id = rs.getString("id");
			this.pass = rs.getString("pass");
			this.name = rs.getString("name");
			this.title = rs.getInt("title");
			this.guildNo = rs.getInt("guild");
			this.mail = rs.getString("mail");
			this.image = rs.getString("image");
			this.job = rs.getInt("job");
			this.pureStr = rs.getInt("str");
			this.pureDex = rs.getInt("dex");
			this.pureAgi = rs.getInt("agi");
			this.statPoint = rs.getInt("stat_point");
			this.skillPoint = rs.getInt("skill_point");
			this.hp = rs.getInt("hp");
			this.mp = rs.getInt("mp");
			this.level = rs.getInt("level");
			this.exp = rs.getInt("exp");
			this.gold = rs.getInt("gold");
			this.map = rs.getInt("map");
			this.seed = rs.getInt("seed");
			this.x = rs.getInt("x");
			this.y = rs.getInt("y");
			this.direction = rs.getInt("direction");
			this.moveSpeed = rs.getInt("speed");
			this.admin = rs.getInt("admin") == 0;
			this.team = no;
			this.characterType = Type.Character.USER;
			this.random = new Random();
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

	public void setTitle(int title) {
		this.title = title;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.TITLE }, new Integer[]{ this.title }));
		Map.getMap(this.map).getField(this.seed).sendToOthers(this, Packet.updateCharacter(this.characterType, this.no,
				new int[]{ Type.Status.TITLE }, new Integer[]{ this.title }));
	}

	// 길드
	public int getGuild() {
		return guildNo;
	}

	public void setGuild(int guild) {
		this.guildNo = guild;
		this.ctx.writeAndFlush(Packet.setGuild(this.guildNo));
	}
	
	public String getMail() {
		return mail;
	}

	// 이미지
	public void setImage(String image) {
		this.image = image;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.IMAGE }, new String[]{ this.image }));
		Map.getMap(this.map).getField(this.seed).sendToOthers(this, Packet.updateCharacter(this.characterType, this.no,
				new int[]{ Type.Status.IMAGE }, new String[]{ this.image }));
	}

	// 직업
	public int getJob() {
		return job;
	}

	public void setJob(int job) {
		this.job = job;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.JOB }, new Integer[]{ job }));
		Map.getMap(this.map).getField(this.seed).sendToOthers(this, Packet.updateCharacter(this.characterType, this.no,
				new int[]{ Type.Status.JOB }, new Integer[]{ this.job }));
	}
	
	public int getStr() {
		int n = 0;
		// 스텟 Str
		n += this.pureStr;
		// 직업 기본 Str
		n += GameData.job.get(this.job).getStr() * this.level;
		// 아이템으로 오르는 Str
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getStr();
			n += findItemByIndex(this.weapon).getStr();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getStr();
			n += findItemByIndex(this.shield).getStr();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getStr();
			n += findItemByIndex(this.helmet).getStr();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getStr();
			n += findItemByIndex(this.armor).getStr();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getStr();
			n += findItemByIndex(this.cape).getStr();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getStr();
			n += findItemByIndex(this.shoes).getStr();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getStr();
			n += findItemByIndex(this.accessory).getStr();
		}
		return n;
	}
	
	public int getPureStr() {
		return pureStr;
	}
	
	public int getDex() {
		int n = 0;
		// 스텟 Dex
		n += this.pureDex;
		// 직업 기본 Dex
		n += GameData.job.get(this.job).getDex() * this.level;
		// 아이템으로 오르는 Dex
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getDex();
			n += findItemByIndex(this.weapon).getDex();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getDex();
			n += findItemByIndex(this.shield).getDex();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getDex();
			n += findItemByIndex(this.helmet).getDex();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getDex();
			n += findItemByIndex(this.armor).getDex();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getDex();
			n += findItemByIndex(this.cape).getDex();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getDex();
			n += findItemByIndex(this.shoes).getDex();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getDex();
			n += findItemByIndex(this.accessory).getDex();
		}
		return n;
	}
	
	public int getPureDex() {
		return pureDex;
	}
	
	public int getAgi() {
		int n = 0;
		// 스텟 Agi
		n += this.pureAgi;
		// 직업 기본 Agi
		n += GameData.job.get(this.job).getAgi() * this.level;
		// 아이템으로 오르는 Agi
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getAgi();
			n += findItemByIndex(this.weapon).getAgi();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getAgi();
			n += findItemByIndex(this.shield).getAgi();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getAgi();
			n += findItemByIndex(this.helmet).getAgi();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getAgi();
			n += findItemByIndex(this.armor).getAgi();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getAgi();
			n += findItemByIndex(this.cape).getAgi();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getAgi();
			n += findItemByIndex(this.shoes).getAgi();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getAgi();
			n += findItemByIndex(this.accessory).getAgi();
		}
		return n;
	}
	
	public int getPureAgi() {
		return pureAgi;
	}

	public void gainHp(int value) {
		// 최대 HP 이상인 경우 보정
		if (this.hp + value > getMaxHp()) {
			value = getMaxHp() - this.hp;
		}
		this.hp += value;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.HP }, new Integer[]{ this.hp }));
		Map.getMap(this.map).getField(this.seed).sendToOthers(this, Packet.updateCharacter(this.characterType, this.no,
				new int[]{ Type.Status.HP }, new Integer[]{ this.hp }));
	}

	public void loseHp(int value) {
		gainHp(-value);
		if (this.hp - value < 0) {
			// 쥬금
			return;
		}
	}

	// 최대 HP
	public int getMaxHp() {
		int n = 0;
		// 직업 기본 Hp
		n += GameData.job.get(this.job).getHp() * this.level;
		// 아이템으로 오르는 Hp
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getHp();
			n += findItemByIndex(this.weapon).getHp();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getHp();
			n += findItemByIndex(this.shield).getHp();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getHp();
			n += findItemByIndex(this.helmet).getHp();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getHp();
			n += findItemByIndex(this.armor).getHp();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getHp();
			n += findItemByIndex(this.cape).getHp();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getHp();
			n += findItemByIndex(this.shoes).getHp();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getHp();
			n += findItemByIndex(this.accessory).getHp();
		}
		return n;
	}

	public void gainMp(int value) {
		// 최대 MP 이상인 경우 보정
		if (this.mp + value > getMaxMp()) {
			value = getMaxMp() - this.mp;
		}
		this.mp += value;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ Type.Status.MP }, new Integer[]{ this.mp }));
	}

	public boolean loseMp(int value) {
		if (this.mp - value < 0) {
			return false;
		}
		gainMp(-value);
		return true;
	}

	// 최대 MP
	public int getMaxMp() {
		int n = 0;
		// 직업 기본 Mp
		n += GameData.job.get(this.job).getMp() * this.level;
		// 아이템으로 오르는 Mp
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getMp();
			n += findItemByIndex(this.weapon).getMp();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getMp();
			n += findItemByIndex(this.shield).getMp();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getMp();
			n += findItemByIndex(this.helmet).getMp();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getMp();
			n += findItemByIndex(this.armor).getMp();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getMp();
			n += findItemByIndex(this.cape).getMp();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getMp();
			n += findItemByIndex(this.shoes).getMp();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getMp();
			n += findItemByIndex(this.accessory).getMp();
		}
		return n;
	}

	// 치명타율
	public int getCritical() {
		int n = 0;
		// 아이템으로 오르는 Critical
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getCritical();
			n += findItemByIndex(this.weapon).getCritical();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getCritical();
			n += findItemByIndex(this.shield).getCritical();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getCritical();
			n += findItemByIndex(this.helmet).getCritical();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getCritical();
			n += findItemByIndex(this.armor).getCritical();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getCritical();
			n += findItemByIndex(this.cape).getCritical();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getCritical();
			n += findItemByIndex(this.shoes).getCritical();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getCritical();
			n += findItemByIndex(this.accessory).getCritical();
		}
		return n;
	}

	// 회피율
	public int getAvoid() {
		int n = 0;
		// 아이템으로 오르는 Avoid
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getAvoid();
			n += findItemByIndex(this.weapon).getAvoid();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getAvoid();
			n += findItemByIndex(this.shield).getAvoid();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getAvoid();
			n += findItemByIndex(this.helmet).getAvoid();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getAvoid();
			n += findItemByIndex(this.armor).getAvoid();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getAvoid();
			n += findItemByIndex(this.cape).getAvoid();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getAvoid();
			n += findItemByIndex(this.shoes).getAvoid();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getAvoid();
			n += findItemByIndex(this.accessory).getAvoid();
		}
		return n;
	}

	// 명중률
	public int getHit() {
		int n = 0;
		// 아이템으로 오르는 Hit
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getHit();
			n += findItemByIndex(this.weapon).getHit();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getHit();
			n += findItemByIndex(this.shield).getHit();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getHit();
			n += findItemByIndex(this.helmet).getHit();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getHit();
			n += findItemByIndex(this.armor).getHit();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getHit();
			n += findItemByIndex(this.cape).getHit();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getHit();
			n += findItemByIndex(this.shoes).getHit();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getHit();
			n += findItemByIndex(this.accessory).getHit();
		}
		return n;
	}

	// 물리 데미지
	public int getDamage() {
		int n = 0;
		// 아이템으로 오르는 Damage
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getDamage();
			n += findItemByIndex(this.weapon).getDamage();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getDamage();
			n += findItemByIndex(this.shield).getDamage();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getDamage();
			n += findItemByIndex(this.helmet).getDamage();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getDamage();
			n += findItemByIndex(this.armor).getDamage();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getDamage();
			n += findItemByIndex(this.cape).getDamage();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getDamage();
			n += findItemByIndex(this.shoes).getDamage();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getDamage();
			n += findItemByIndex(this.accessory).getDamage();
		}
		return n;
	}

	// 마법 데미지
	public int getMagicDamage() {
		int n = 0;
		// 아이템으로 오르는 MagicDamage
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getMagicDamage();
			n += findItemByIndex(this.weapon).getMagicDamage();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getMagicDamage();
			n += findItemByIndex(this.shield).getMagicDamage();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getMagicDamage();
			n += findItemByIndex(this.helmet).getMagicDamage();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getMagicDamage();
			n += findItemByIndex(this.armor).getMagicDamage();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getMagicDamage();
			n += findItemByIndex(this.cape).getMagicDamage();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getMagicDamage();
			n += findItemByIndex(this.shoes).getMagicDamage();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getMagicDamage();
			n += findItemByIndex(this.accessory).getMagicDamage();
		}
		return n;
	}

	// 물리 방어력
	public int getDefense() {
		int n = 0;
		// 아이템으로 오르는 Defense
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getDefense();
			n += findItemByIndex(this.weapon).getDefense();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getDefense();
			n += findItemByIndex(this.shield).getDefense();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getDefense();
			n += findItemByIndex(this.helmet).getDefense();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getDefense();
			n += findItemByIndex(this.armor).getDefense();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getDefense();
			n += findItemByIndex(this.cape).getDefense();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getDefense();
			n += findItemByIndex(this.shoes).getDefense();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getDefense();
			n += findItemByIndex(this.accessory).getDefense();
		}
		return n;
	}

	// 마법 방어력
	public int getMagicDefense() {
		int n = 0;
		// 아이템으로 오르는 MagicDefense
		if (this.weapon > 0) {
			n += GameData.item.get(findItemByIndex(this.weapon).getNo()).getMagicDefense();
			n += findItemByIndex(this.weapon).getMagicDefense();
		}
		if (this.shield > 0) {
			n += GameData.item.get(findItemByIndex(this.shield).getNo()).getMagicDefense();
			n += findItemByIndex(this.shield).getMagicDefense();
		}
		if (this.helmet > 0) {
			n += GameData.item.get(findItemByIndex(this.helmet).getNo()).getMagicDefense();
			n += findItemByIndex(this.helmet).getMagicDefense();
		}
		if (this.armor > 0) {
			n += GameData.item.get(findItemByIndex(this.armor).getNo()).getMagicDefense();
			n += findItemByIndex(this.armor).getMagicDefense();
		}
		if (this.cape > 0) {
			n += GameData.item.get(findItemByIndex(this.cape).getNo()).getMagicDefense();
			n += findItemByIndex(this.cape).getMagicDefense();
		}
		if (this.shoes > 0) {
			n += GameData.item.get(findItemByIndex(this.shoes).getNo()).getMagicDefense();
			n += findItemByIndex(this.shoes).getMagicDefense();
		}
		if (this.accessory > 0) {
			n += GameData.item.get(findItemByIndex(this.accessory).getNo()).getMagicDefense();
			n += findItemByIndex(this.accessory).getMagicDefense();
		}
		return n;
	}

	// 필요 경험치
	public int getMaxExp() {
		// 필요 경험치 계산식
		int n = 0;
		n += this.level * this.level * 10;
		return n;
	}

	// 경험치 획득
	public void gainExp(int value) {
		int maxExp = getMaxExp();
		this.exp += value;
		// 현재 경험치가 최대 경험치를 초과한 경우
		if (this.exp >= maxExp) {
			// 레벨 업
			this.exp = 0;
			this.level++;
			this.statPoint += 5;
			this.skillPoint += 1;
			// HP 및 MP 회복
			this.hp = getMaxHp();
			this.mp = getMaxMp();
			// 변화한 스텟 정보를 보냄
			this.ctx.writeAndFlush(Packet.updateStatus(
					new int[]{Type.Status.LEVEL, Type.Status.STAT_POINT, Type.Status.SKILL_POINT, Type.Status.STR, Type.Status.DEX,
							Type.Status.AGI, Type.Status.HP, Type.Status.MAX_HP, Type.Status.MP, Type.Status.MAX_MP, Type.Status.MAX_EXP},
					new Integer[]{this.level, this.statPoint, this.skillPoint, getStr(), getDex(), getAgi(), this.hp, getMaxHp(), this.mp, getMaxMp(), getMaxExp()}));
			Map.getMap(map).getField(seed).sendToOthers(this, Packet.updateCharacter(characterType, no,
					new int[]{ Type.Status.LEVEL, Type.Status.HP, Type.Status.MAX_HP },
					new Integer[] { this.level, this.hp, getMaxHp() }));
			animation(25);
		}
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.EXP}, new Integer[]{this.exp}));
	}

	// 경험치 잃음
	public void loseExp(int value) {
		if (this.exp - value < 0) {
			value = this.exp;
		}
		gainExp(-value);
	}

	public void gainGold(int value) {
		this.gold += value;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.GOLD}, new Integer[]{this.gold}));
	}

	public boolean loseGold(int value) {
		if (this.gold < value) {
			return false;
		}
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
		loadSlot();
	}
	
	// 장착한 아이템 불러오기
	public void loadEquipItem() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `equip` WHERE `user_no` = '" + this.no + "';");
	    	if (rs.next()) {
	    		this.weapon = rs.getInt("weapon");
	    		this.shield = rs.getInt("shield");
	    		this.helmet = rs.getInt("helmet");
	    		this.armor = rs.getInt("armor");
	    		this.cape = rs.getInt("cape");
	    		this.shoes = rs.getInt("shoes");
	    		this.accessory = rs.getInt("accessory");
	    	} else {
				DataBase.insertEquip(this.no);
			}
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 인벤토리 불러오기
	public void loadInventory() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `item` WHERE `user_no` = '" + this.no + "';");
			while (rs.next()) {
				this.itemBag.put(rs.getInt("index"), new Item(rs));
				this.ctx.writeAndFlush(Packet.setItem(this.itemBag.get(rs.getInt("index"))));
			}
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 스킬 불러오기
	public void loadSkillList() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `skill` WHERE `user_no` = '" + this.no + "';");
			while (rs.next()) {
				this.skillBag.put(rs.getInt("skill_no"), new Skill(this.no, rs.getInt("skill_no")));
				this.ctx.writeAndFlush(Packet.setSkill(this.skillBag.get(rs.getInt("skill_no"))));
			}
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 길드 멤버 불러오기
	public void loadGuildMember() {
		if (this.guildNo == 0) {
			return;
		}
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `guild` = '" + this.guildNo + "';");
			while (rs.next()) {
				User member = User.get(rs.getInt("no"));
				if (member == null) {
					this.ctx.writeAndFlush(Packet.setGuildMember(rs.getInt("no"), rs.getString("name"), rs.getString("image"),
							rs.getInt("level"), rs.getInt("job"), rs.getInt("hp"), rs.getInt("hp")));
				} else {
					this.ctx.writeAndFlush(Packet.setGuildMember(member));
				}
			}
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	// 스텟 포인트 사용
	public void useStatPoint(int stat) {
		if (this.statPoint <= 0) {
			return;
		}
		// 올릴 수 있는 스텟만 올리고
		switch (stat) {
			case Type.Status.STR:
				this.pureStr++;
				this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getStr() }));
				break;

			case Type.Status.DEX:
				this.pureDex++;
				this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getDex() }));
				break;

			case Type.Status.AGI:
				this.pureAgi++;
				this.ctx.writeAndFlush(Packet.updateStatus(new int[]{ stat }, new Integer[]{ getAgi() }));
				break;

			default:
				return;
		}
		// 스포 하나 까자
		this.statPoint--;
		this.ctx.writeAndFlush(Packet.updateStatus(new int[]{Type.Status.STAT_POINT}, new Integer[]{this.statPoint}));
	}
	
	// 아이템 장착
	public void equipItem(int type, int index) {
		int oldEquip = 0;
		switch (type) {
			case Type.Item.WEAPON:
				oldEquip = this.weapon;
				this.weapon = index;
				break;

			case Type.Item.SHIELD:
				oldEquip = this.shield;
				this.shield = index;
				break;

			case Type.Item.HELMET:
				oldEquip = this.helmet;
				this.helmet = index;
				break;

			case Type.Item.ARMOR:
				oldEquip = this.armor;
				this.armor = index;
				break;

			case Type.Item.CAPE:
				oldEquip = this.cape;
				this.cape = index;
				break;

			case Type.Item.SHOES:
				oldEquip = this.shoes;
				this.shoes = index;
				break;

			case Type.Item.ACCESSORY:
				oldEquip = this.accessory;
				this.accessory = index;
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
			this.ctx.writeAndFlush(Packet.updateItem(1, lastEquippedItem));
		}
		if (nowEquipItem != null) {
			nowEquipItem.setEquipped(true);
			this.ctx.writeAndFlush(Packet.updateItem(1, nowEquipItem));
		}
		// HP, MP 보정
		if (getMaxHp() < this.hp) {
			this.hp = getMaxHp();
		}
		if (getMaxMp() < this.mp) {
			this.mp = getMaxMp();
		}
		// TODO : Type.Status.WEAPON + type는 임시. 수정 요망
		this.ctx.writeAndFlush(Packet.updateStatus(
				new int[]{ Type.Status.WEAPON + type, Type.Status.STR, Type.Status.DEX, Type.Status.AGI, Type.Status.MAX_HP, Type.Status.HP,
						Type.Status.MAX_MP, Type.Status.MP, Type.Status.CRITICAL, Type.Status.AVOID, Type.Status.HIT },
				new Integer[]{ index, getStr(), getDex(), getAgi(), getMaxHp(), this.hp, getMaxMp(), this.mp, getCritical(), getAvoid(), getHit() }));
		Map.getMap(this.map).getField(this.seed).sendToOthers(this, Packet.updateCharacter(Type.Character.USER, this.no,
				new int[]{ Type.Status.MAX_HP, Type.Status.HP }, new Integer[]{ getMaxHp(), this.hp }));
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
			this.ctx.writeAndFlush(Packet.updateItem(1, item));
		}
		while (num > 0) {
			if (index == -1) {
				// 나머지 아이템 드랍
				Map.getMap(this.map).getField(this.seed).loadDropItem(itemNo, num, this.x, this.y);
				return false;
			}
			// 계속해서 아이템 채우자
			this.itemBag.put(index, new Item(this.no, itemNo, num, index, itemData.isTradeable() ? 1 : 0));
			this.ctx.writeAndFlush(Packet.setItem(this.itemBag.get(index)));
			index = getEmptyIndex();
			num -= itemData.getMaxLoad();
		}
		return true;
	}

	// 능력치 있는 장비 아이템 획득
	public boolean gainItem(int itemNo, Item item) {
		int index = getEmptyIndex();
		if (index == -1) {
			return false;
		}
		this.itemBag.put(index, new Item(this.no, item.getNo(), index, item));
		this.ctx.writeAndFlush(Packet.setItem(this.itemBag.get(index)));
		return true;
	}

	// 아이템 No로 아이템 잃음 (퀘스트 등)
	public boolean loseItemByNo(int itemNo, int num) {
		if (itemNo <= 0 || num <= 0) {
			return false;
		}
		int gap = 0;
		Item item = findItemByNo(itemNo);
		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || getTotalItemAmount(item.getNo()) < num) {
			return false;
		}
		// 모든 아이템을 잃을 때까지 반복
		do {
			gap = num - item.getAmount();
			item.addAmount(-num);
			if (item.getAmount() == 0) {
				// 아이템 삭제
				this.itemBag.remove(item.getIndex());
				this.ctx.writeAndFlush(Packet.updateItem(0, item));
			} else {
				// 아이템 갯수 업데이트
				this.ctx.writeAndFlush(Packet.updateItem(1, item));
			}
			num = gap;
		} while (num > 0);
		return true;
	}

	// Index로 아이템 잃음 (직접 드랍하는 경우)
	public boolean loseItemByIndex(int index, int num) {
		Item item = findItemByIndex(index);
		// 아이템이 없거나 잃을 갯수가 더 많은 경우
		if (item == null || item.getAmount() < num) {
			return false;
		}
		item.addAmount(-num);
		if (item.getAmount() == 0) {
			// 아이템 삭제
			this.itemBag.remove(item.getIndex());
			this.ctx.writeAndFlush(Packet.updateItem(0, item));
		} else {
			// 아이템 갯수 업데이트
			this.ctx.writeAndFlush(Packet.updateItem(1, item));
		}
		return true;
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 1; i <= this.maxInventory; i++) {
			if (!this.itemBag.containsKey(i)) {
				return i;
			}
		}
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getTotalItemAmount(int itemNo) {
		int num = 0;
		for (Item item : this.itemBag.values()) {
			if (item.getNo() == itemNo) {
				num += item.getAmount();
			}
		}
		return num;
	}
	
	// Index로 아이템 검색
	public Item findItemByIndex(int index) {
		if (!this.itemBag.containsKey(index)) {
			return null;
		}
		return this.itemBag.get(index);
	}

	// No로 아이템 검색
	public Item findItemByNo(int itemNo) {
		for (Item item : this.itemBag.values()) {
			if (item.getNo() == itemNo) {
				return item;
			}
		}
		return null;
	}

	// No로 여유 있는 아이템 검색
	public Item findLazyItemByNo(int itemNo) {
		for (Item item : this.itemBag.values()) {
			// 아이템이 꽉 찬 경우가 아니라면
			if (item.getNo() == itemNo && item.getAmount() < GameData.item.get(item.getNo()).getMaxLoad()) {
				return item;
			}
		}
		return null;
	}

	// 아이템 인덱스 변경
	public void changeItemIndex(int index1, int index2) {
		Item presentItem = findItemByIndex(index1);
		Item targetItem = findItemByIndex(index2);
		// 아이템이 없으면 반환
		if (presentItem == null) {
			return;
		}
		if (presentItem.isEquipped()) {
			return;
		}
		if (targetItem != null) {
			if (targetItem.isEquipped()) {
				return;
			}
			// 아이템 간 인덱스 변경
			this.itemBag.remove(index1);
			this.itemBag.remove(index2);
			presentItem.setIndex(index2);
			targetItem.setIndex(index1);
			this.itemBag.put(index2, presentItem);
			this.itemBag.put(index1, targetItem);
			this.ctx.write(Packet.setItem(presentItem));
			this.ctx.writeAndFlush(Packet.setItem(targetItem));
		} else {
			// 빈 곳으로 아이템 이동
			this.ctx.write(Packet.updateItem(0, presentItem));
			this.itemBag.remove(index1);
			presentItem.setIndex(index2);
			this.itemBag.put(index2, presentItem);
			this.ctx.writeAndFlush(Packet.setItem(presentItem));
		}

	}

	// Index로 아이템 사용
	public boolean useItemByIndex(int index, int amount) {
		Item item = findItemByIndex(index);
		// 아이템이 없으면 반환
		if (item == null) {
			return false;
		}
		// 갯수가 적으면 반환
		if (item.getAmount() < amount) {
			return false;
		}
		ItemData itemData = GameData.item.get(item.getNo());
		// 레벨이 낮으면 반환
		if (this.level < itemData.getLimitLevel()) {
			return false;
		}
		// 직업이 다르고 아이템도 공용이 아니면 반환
		if (this.job != itemData.getJob() && itemData.getJob() != 0) {
			return false;
		}
		// 소모품이면 아이템 잃음
		if (itemData.isConsumable()) {
			loseItemByIndex(index, amount);
		}
		// 아이템이 아니라면 장착해보자
		if (itemData.getType() != Type.Item.ITEM) {
			equipItem(itemData.getType(), item.getIndex());
		}
		// 함수가 있을 경우 실행
		String function = itemData.getFunction();
		if (function != "") {
			Functions.execute(Functions.item, function, new Object[]{this, item});
		}
		return true;
	}

	// No로 아이템 사용
	public boolean useItemByNo(int itemNo, int amount) {
		Item item = findItemByNo(itemNo);
		// 아이템이 없으면 반환
		if (item == null) {
			return false;
		}
		// 갯수가 적으면 반환
		if (item.getAmount() < amount) {
			return false;
		}
		ItemData itemData = GameData.item.get(item.getNo());
		// 레벨이 낮으면 반환
		if (this.level < itemData.getLimitLevel()) {
			return false;
		}
		// 직업이 다르고 아이템도 공용이 아니면 반환
		if (this.job != itemData.getJob() && itemData.getJob() != 0) {
			return false;
		}
		// 소모품이면 아이템 잃음
		if (itemData.isConsumable()) {
			loseItemByNo(itemNo, amount);
		}
		// 함수가 있을 경우 실행
		String function = GameData.item.get(item.getNo()).getFunction();
		if (function != "") {
			Functions.execute(Functions.item, function, new Object[]{this, item});
		}
		return true;
	}

	// No로 아이템 버리기
	public boolean dropItemByNo(int itemNo, int amount) {
		Item item = findItemByNo(itemNo);
		// 아이템이 없으면 반환
		if (item == null) {
			return false;
		}
		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0) {
			return false;
		}
		ItemData itemData = GameData.item.get(item.getNo());
		loseItemByNo(itemNo, amount);
		if (itemData.getType() == Type.Item.ITEM) {
			Map.getMap(this.no).getField(this.seed).loadDropItem(itemNo, amount, this.x, this.y);
		} else {
			Map.getMap(this.no).getField(this.seed).loadDropItem(itemNo, item, this.x, this.y);
		}
		return true;
	}

	// Index로 아이템 버리기
	public boolean dropItemByIndex(int index, int amount) {
		Item item = findItemByIndex(index);
		// 아이템이 없으면 반환
		if (item == null) {
			return false;
		}
		// 갯수가 적으면 반환
		if (item.getAmount() < amount || amount <= 0) {
			return false;
		}
		ItemData itemData = GameData.item.get(item.getNo());
		loseItemByIndex(index, amount);
		if (itemData.getType() == Type.Item.ITEM) {
			Map.getMap(this.no).getField(this.seed).loadDropItem(item.getNo(), amount, this.x, this.y);
		} else {
			Map.getMap(this.no).getField(this.seed).loadDropItem(item.getNo(), item, this.x, this.y);
		}
		return true;
	}

	// 골드 버리기
	public boolean dropGold(int amount) {
		if (this.gold < amount) {
			return false;
		}
		loseGold(amount);
		Map.getMap(this.no).getField(this.seed).loadDropGold(amount, this.x, this.y);
		return true;
	}

	// 아이템 줍기
	public void pickItem() {
		Field field = Map.getMap(this.map).getField(this.seed);
		// 골드 먼저 줍자
		Field.DropGold dropGold = field.pickGold(this.x, this.y);
		Field.DropItem dropItem;
		// 골드가 없다면
		if (dropGold == null) {
			// 아이템을 줍자
			dropItem = field.pickItem(this.x, this.y);
			// 아이템도 없다면 반환
			if (dropItem == null) {
				return;
			}
		}
		else {
			// 골드가 있다면 획득하고 반환
			gainGold(dropGold.getAmount());
			field.removeDropGold(dropGold);
			return;
		}
		// 비어있는 인덱스를 획득
		int index = getEmptyIndex();
		if (index == -1) {
			return;
		}
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
		if (!this.skillBag.containsKey(skillNo)) {
			return null;
		}
		return this.skillBag.get(skillNo);
	}

	// Index로 스킬 검색
	public GameData.Skill findSkillByIndex(int itemNo) {
		for (GameData.Skill skill : this.skillBag.values()) {
			if (skill.getNo() == itemNo) {
				return skill;
			}
		}
		return null;
	}

	// 스킬 배우기
	public boolean studySkill(int skillNo) {
		if (this.skillBag.containsKey(skillNo)) {
			return false;
		}
		GameData.Skill skill = new GameData.Skill(this.no, skillNo);
		this.skillBag.put(skillNo, skill);
		this.ctx.writeAndFlush(Packet.setSkill(skill));
		return true;
	}

	// 스킬 지우기
	public boolean forgetSkill(int skillNo) {
		if (!this.skillBag.containsKey(skillNo)) {
			return false;
		}
		this.ctx.writeAndFlush(Packet.updateSkill(0, this.skillBag.get(skillNo)));
		this.skillBag.remove(skillNo);
		return true;
	}

	// No로 스킬 사용
	public boolean useSkill(int skillNo) {
		GameData.Skill skill = findSkillByNo(skillNo);
		if (skill == null) {
			return false;
		}
		if (this.coolTime.getCoolTime(skill.getNo()) > 0) {
			return false;
		}
		// 함수가 있을 경우 실행
		String function = GameData.skill.get(skill.getNo()).getFunction();
		if (function != "") {
			Functions.execute(Functions.skill, function, new Object[]{this, skill});
		}
		return true;
	}

	// 거래 요청
	public boolean requestTrade(int partnerNo) {
		User partner = User.get(partnerNo);
		// 거래 중이라면 반환
		if (nowTrading()) {
			return false;
		}
		// 파트너가 없으면 반환
		if (partner == null) {
			return false;
		}
		// 상대 유저가 거래중이라면 반환
		if (partner.nowTrading()) {
			return false;
		}
		// 거래 요청
		partner.getCtx().writeAndFlush(Packet.requestTrade(this.no));
		return true;
	}

	// 거래 수락 및 거절
	public void responseTrade(int type, int partnerNo) {
		User partner = User.get(partnerNo);
		// 파트너가 없으면 반환
		if (partner == null) {
			return;
		}
		// 파트너가 교환중이면 반환
		if (partner.nowTrading()) {
			return;
		}
		switch (type) {
			case 0:
				// 수락
				this.tradePartner = partnerNo;
				this.ctx.writeAndFlush(Packet.openTradeWindow(partnerNo));
				partner.tradePartner = this.no;
				partner.getCtx().writeAndFlush(Packet.openTradeWindow(this.no));
				break;

			case 1:
				// 거절
				//partner.finishTrade();
				break;

			default:
		}
	}

	// 거래 아이템 올리기
	public void loadTradeItem(int index, int amount, int tradeIndex) {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		// 거래 종료 대기 중이라면 반환
		if (this.isAcceptTrade || User.get(this.tradePartner).isAcceptTrade) {
			return;
		}
		Item item = findItemByIndex(index);
		// 아이템이 없다면 반환
		if (item == null) {
			return;
		}
		// 거래 불가능한 아이템일 경우 반환
		if (!item.isTradeable()) {
			return;
		}
		// 장착중이라면 반환
		if (item.isEquipped()) {
			return;
		}
		// 소지 갯수보다 거래하려는 갯수가 많을 경우 반환
		if (item.getAmount() < amount) {
			return;
		}
		// 해당 공간에 이미 아이템이 있는 경우 반환
		if (this.tradeItemList.containsKey(tradeIndex)) {
			return;
		}
		// 거래하려는 아이템을 거래 목록에 올림
		Item tradeItem = item.clone();
		tradeItem.setIndex(tradeIndex);
		tradeItem.setAmount(amount);
		this.tradeItemList.put(tradeIndex, tradeItem);
		// 아이템 잃음
		loseItemByIndex(index, amount);
		// 거래 아이템 로드
		this.ctx.writeAndFlush(Packet.loadTradeItem(tradeItem));
		User.get(this.tradePartner).getCtx().writeAndFlush(Packet.loadTradeItem(tradeItem));
	}

	// 거래 아이템 내리기
	public void dropTradeItem(int index) {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		// 거래 종료 대기 중이라면 반환
		if (this.isAcceptTrade || User.get(this.tradePartner).isAcceptTrade) {
			return;
		}
		// 아이템이 없으면 반환
		if (!this.tradeItemList.containsKey(index)) {
			return;
		}
		Item item = this.tradeItemList.get(index);
		ItemData itemData = GameData.item.get(item.getNo());
		// 일반 아이템일 경우 그냥 얻고, 장비 아이템일 경우 능력치 보존
		if (itemData.getType() == Type.Item.ITEM) {
			gainItem(item.getNo(), item.getAmount());
		} else {
			gainItem(item.getNo(), item);
		}
		// 거래 아이템 리스트에서 제거
		this.tradeItemList.remove(index);
		// 거래 아이템 삭제
		this.ctx.writeAndFlush(Packet.dropTradeItem(this.no, index));
		User.get(this.tradePartner).getCtx().writeAndFlush(Packet.dropTradeItem(this.no, index));
	}

	// 거래 골드 변경
	public void changeTradeGold(int value) {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		// 거래 종료 대기 중이라면 반환
		if (this.isAcceptTrade || User.get(this.tradePartner).isAcceptTrade) {
			return;
		}
		// 가진 골드와 거래중인 골드의 합보다 많으면 반환
		if (this.tradeGold + this.gold < value) {
			return;
		}
		gainGold(this.tradeGold);
		loseGold(value);
		this.tradeGold = value;
		// 골드 변경하렴
		this.ctx.writeAndFlush(Packet.changeTradeGold(this.no, this.tradeGold));
		User.get(this.tradePartner).getCtx().writeAndFlush(Packet.changeTradeGold(this.no, this.tradeGold));
	}

	// 거래 종료 대기
	public void acceptTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		User partner = User.get(this.tradePartner);
		// 상대방도 거래 종료 대기 중이라면
		if (partner.isAcceptTrade) {
			finishTrade();
		} else {
			this.isAcceptTrade = true;
		}
		this.ctx.writeAndFlush(Packet.acceptTrade(this.no));
		partner.getCtx().writeAndFlush(Packet.acceptTrade(this.no));
	}

	// 거래 종료
	public void finishTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		User partner = User.get(this.tradePartner);
		// 아이템 및 골드 획득
		for (Item i : partner.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());
			if (iData.getType() == Type.Item.ITEM) {
				gainItem(i.getNo(), i.getAmount());
			} else {
				gainItem(i.getNo(), i);
			}
		}
		gainGold(partner.tradeGold);
		// 파트너 아이템 및 골드 획득
		for (Item i : this.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());
			if (iData.getType() == Type.Item.ITEM) {
				partner.gainItem(i.getNo(), i.getAmount());
			} else {
				partner.gainItem(i.getNo(), i);
			}
		}
		partner.gainGold(this.tradeGold);
		// 거래 관련 변수 초기화
		this.tradePartner = 0;
		this.isAcceptTrade = false;
		this.tradeGold = 0;
		this.tradeItemList.clear();
		partner.tradePartner = 0;
		partner.isAcceptTrade = false;
		partner.tradeGold = 0;
		partner.tradeItemList.clear();
	}

	// 거래 취소
	public void cancelTrade() {
		// 거래 중 아니라면 반환
		if (!nowTrading()) {
			return;
		}
		// 아이템 및 골드 돌려받기
		for (Item i : this.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());
			if (iData.getType() == Type.Item.ITEM) {
				gainItem(i.getNo(), i.getAmount());
			} else {
				gainItem(i.getNo(), i);
			}
		}
		gainGold(this.tradeGold);
		// 파트너 아이템 및 골드 돌려받기
		User partner = User.get(this.tradePartner);
		for (Item i : partner.tradeItemList.values()) {
			ItemData iData = GameData.item.get(i.getNo());
			if (iData.getType() == Type.Item.ITEM) {
				partner.gainItem(i.getNo(), i.getAmount());
			} else {
				partner.gainItem(i.getNo(), i);
			}
		}
		partner.gainGold(partner.tradeGold);
		// 거래 관련 변수 초기화
		this.tradePartner = 0;
		this.isAcceptTrade = false;
		this.tradeGold = 0;
		this.tradeItemList.clear();
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
		if (this.tradePartner == 0) {
			return false;
		}
		// 거래 상대 없다면
		if (User.get(this.tradePartner) == null) {
			cancelTrade();
			return false;
		}
		return true;
	}

	// 상점 열기
	public void openShop(int no) {
		this.ctx.writeAndFlush(Packet.openShopWindow(no));
		for (ItemData shopItem : GameData.shop.get(no).getAllItems().values()) {
			this.ctx.writeAndFlush(Packet.setShopItem(shopItem.getNo(), shopItem.getPrice()));
		}
	}

	// 상점 아이템 구매
	public void buyShopItem(int shopNo, int index, int amount) {
		if (!GameData.shop.containsKey(shopNo)) {
			return;
		}
		Shop shop = GameData.shop.get(shopNo);
		if (shop.getItem(index) == null) {
			return;
		}
		ItemData item = shop.getItem(index);
		if (item.getType() == Type.Item.ITEM) {
			amount = amount > item.getMaxLoad() ? item.getMaxLoad() : amount;
		} else {
			amount = 1;
		}
		if (this.gold < item.getPrice() * amount) {
			return;
		}
		loseGold(item.getPrice() * amount);
		gainItem(item.getNo(), amount);
	}

	// 파티 번호 설정
	public void setPartyNo(int partyNo) {
		this.partyNo = partyNo;
		this.ctx.writeAndFlush(Packet.setParty(this.partyNo));
	}

	// 파티 번호 얻기
	public int getPartyNo() {
		return partyNo;
	}

	// 파티 생성
	public void createParty() {
		// 이미 파티가 있다면 반환
		if (nowJoinParty()) {
			return;
		}
		// 파티를 생성
		Party.add(this.no);
	}

	// 파티 요청
	public void inviteParty(int otherNo) {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty()) {
			return;
		}
		// 파티 멤버수가 최대라면 반환
		if (Party.get(this.partyNo).getMembers().size() >= 4) {
			return;
		}
		User other = User.get(otherNo);
		User master = User.get(this.partyNo);
		// 파티 마스터가 없다면 반환
		if (master == null) {
			return;
		}
		// 상대 유저가 없다면 반환
		if (other == null) {
			return;
		}
		// 상대에게 이미 파티가 있다면 반환
		if (other.partyNo > 0) {
			return;
		}
		// 파티 요청
		other.getCtx().writeAndFlush(Packet.inviteParty(this.partyNo, master.getName()));
	}

	// 파티 응답
	public void responseParty(int type, int partyNo) {
		// 이미 가입한 파티가 있다면 반환
		if (nowJoinParty()) {
			return;
		}
		switch (type) {
			case 0:
				// 수락
				Party.get(partyNo).join(this.no);
				break;

			case 1:
				// 거절
				break;

			default:
		}
	}

	// 파티 나가기
	public void quitParty() {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty()) {
			return;
		}
		// 파티 탈퇴
		Party.get(partyNo).exit(no);
	}

	// 파티 강퇴
	public void kickParty(int member) {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty()) {
			return;
		}
		// 파티 마스터가 아니라면 반환
		if (partyNo != no) {
			return;
		}
		// 마스터를 강퇴하려 하면 반환
		if (member == partyNo) {
			return;
		}
		Party.get(partyNo).exit(member);
	}

	// 파티 해체
	public void breakUpParty() {
		// 가입한 파티가 없다면 반환
		if (!nowJoinParty()) {
			return;
		}
		// 파티 마스터가 아니라면 반환
		if (partyNo != no) {
			return;
		}
		Party.get(partyNo).breakUp();
	}

	// 파티 가입 여부
	private boolean nowJoinParty() {
		// 가입한 파티가 없다면
		if (partyNo == 0) {
			return false;
		}
		Party party = Party.get(partyNo);
		// 해당 파티가 없다면
		if (party == null) {
			partyNo = 0;
			return false;
		}
		return true;
	}

	// 길드 생성
	public void createGuild(String guildName) {
		// 가입한 길드가 있다면 반환
		if (nowJoinGuild()) {
			return;
		}
		// 소지금이 적으면 반환
		if (gold < 100000) {
			return;
		}
		loseGold(100000);
		Guild.add(no, guildName);
	}

	// 길드 요청
	public void inviteGuild(int otherNo) {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild()) {
			return;
		}
		// 길드 멤버수가 최대라면 반환
		if (Guild.get(guildNo).getMembers().size() >= 40) {
			return;
		}
		User other = User.get(otherNo);
		User master = User.get(Guild.get(guildNo).getMaster());
		// 마스터가 없다면 반환
		if (master == null) {
			return;
		}
		// 자신이 마스터가 아니라면 반환
		if (!this.equals(master)) {
			return;
		}
		// 상대 유저가 없다면 반환
		if (other == null) {
			return;
		}
		// 상대에게 이미 길드가 있다면 반환
		if (other.guildNo > 0) {
			return;
		}
		// 길드 요청
		other.getCtx().writeAndFlush(Packet.inviteGuild(this.guildNo, master.getName()));
	}

	// 길드 응답
	public void responseGuild(int type, int guildNo) {
		// 이미 가입한 파티가 있다면 반환
		if (nowJoinGuild()) {
			return;
		}
		switch (type) {
			case 0:
				// 수락
				Guild.get(guildNo).join(this.no);
				break;

			case 1:
				// 거절
				break;

			default:
		}
	}
	
	// 길드 나가기
	public void quitGuild() {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild()) {
			return;
		}
		// 길드 탈퇴
		Guild.get(this.guildNo).exit(this.no);
	}

	// 길드 강퇴
	public void kickGuild(int member) {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild()) {
			return;
		}
		// 길드 마스터가 아니라면 반환
		if (this.guildNo != this.no) {
			return;
		}
		// 마스터를 강퇴하려 하면 반환
		if (member == this.guildNo) {
			return;
		}
		Guild.get(this.guildNo).exit(member);
	}

	// 길드 해체
	public void breakUpGuild() {
		// 가입한 길드가 없다면 반환
		if (!nowJoinGuild()) {
			return;
		}
		// 길드 마스터가 아니라면 반환
		if (this.guildNo != this.no) {
			return;
		}
		Guild.get(this.guildNo).breakUp();
	}

	// 길드 가입 여부
	private boolean nowJoinGuild() {
		// 가입한 파티가 없다면
		if (this.guildNo == 0) {
			return false;
		}
		Guild guild = Guild.get(this.guildNo);
		// 해당 길드가 없다면
		if (guild == null) {
			this.guildNo = 0;
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
		for (Npc npc : Map.getMap(this.map).getField(this.seed).getNPCs()) {
			if (npc.getNo() == this.message.getNpc()) {
				this.message.mySelect = select;
				Functions.execute(Functions.npc, npc.getFunction(), new Object[]{ this, npc });
				break;
			}
		}
	}

	// 스페이스바 누를 경우 액션
	public void action() {
		// 다른 작업 중이라면 반환
		if (isBusy()) {
			return;
		}
		int new_x = this.x + (this.direction == 6 ? 1 : this.direction == 4 ? -1 : 0);
		int new_y = this.y + (this.direction == 2 ? 1 : this.direction == 8 ? -1 : 0);
		// 에너미가 있을 경우 공격하고 반환
		for (Enemy enemy : Map.getMap(this.map).getField(this.seed).getAliveEnemies()) {
			if (enemy.getX() == new_x && enemy.getY() == new_y) {
				assault(enemy);
				return;
			}
		}
		// NPC가 있을 경우 대화하고 반환
		for (Npc npc : Map.getMap(this.map).getField(this.seed).getNPCs()) {
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
		boolean isFatal = getCritical() > this.random.nextInt(100);
		if (isFatal) {
			attackDamage *= 2;
		}
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
	public boolean chatCommand(String strMessage) {
		String command_param[] = strMessage.split(" ");
		// 콘솔 명령어가 실행되었는가
		boolean isCmdExecuted = true;
		switch (command_param[0]) {
			case "/공지":
				if (!this.admin) {
					isCmdExecuted = false;
					break;
				}
				for (User u : users.values()) {
					u.getCtx().writeAndFlush(Packet.chatAll(this.no, "[공지] " + strMessage.replaceFirst("/공지 ", ""), 255, 38, 19));
				}
				break;

			case "/귓":
				strMessage = strMessage.replaceFirst("/귓 ", "");
				strMessage = strMessage.replaceFirst(command_param[1] + " ", "");
				chatWhisper(command_param[1], strMessage);
				break;

			case "/w":
				strMessage = strMessage.replaceFirst("/w ", "");
				strMessage = strMessage.replaceFirst(command_param[1] + " ", "");
				chatWhisper(command_param[1], strMessage);
				break;

			case "/파티":
				strMessage = strMessage.replaceFirst("/파티 ", "");
				chatParty(strMessage);
				break;

			case "/p":
				strMessage = strMessage.replaceFirst("/p ", "");
				chatParty(strMessage);
				break;

			case "/길드":
				strMessage = strMessage.replaceFirst("/길드 ", "");
				chatGuild(strMessage);
				break;

			case "/g":
				strMessage = strMessage.replaceFirst("/g ", "");
				chatGuild(strMessage);
				break;

			case "/전체":
				strMessage = strMessage.replaceFirst("/전체 ", "");
				chatAll(strMessage);
				break;

			case "/a":
				strMessage = strMessage.replaceFirst("/a ", "");
				chatAll(strMessage);
				break;

			// 커맨드 콘솔이 입력되지 않은 경우
			default:
				isCmdExecuted = false;
		}
		return isCmdExecuted;
	}

	// 일반 채팅
	public void chatNormal(String strMessage) {
		if (chatCommand(strMessage)) {
			return;
		}
		Vector<User> mapUsers = Map.getMap(this.map).getField(this.seed).getUsers();
		for (User u : mapUsers) {
			u.getCtx().writeAndFlush(Packet.chatNormal(this.no, this.name + " : " + strMessage));
		}
		startShowingBalloon();
	}

	// 귓속말
	public void chatWhisper(String strTargetName, String strMessage) {
		if (chatCommand(strMessage)) {
			return;
		}
		User u_target = null;
		// 타겟이 본인일 경우
		if (this.name.equals(strTargetName)) {
			return;
		}
		// 검색하려는 닉네임이 공백인 경우
		if (strTargetName.equals("")) {
			return;
		}
		// 메세지가 존재하지 않을 경우
		if (strMessage == null || strMessage.equals("")) {
			return;
		}
		// 닉네임으로 타겟 유저 검색
		for (User u : users.values()) {
			if (u.getName().equals(strTargetName)) {
				u_target = u;
				break;
			}
		}
		// 타겟 유저가 접속 중이 아닐 경우
		if (u_target == null) {
			return;
		}
		// `상대`가 `나`로부터 받음
		u_target.getCtx().writeAndFlush(Packet.chatWhisper("[From:" + this.name + "] " + strMessage, 25, 181, 254, 32, 32, 32));
		// `나`가 `상대`에게 보냄
		this.ctx.writeAndFlush(Packet.chatWhisper("[To:" + u_target.getName() + "] " + strMessage, 25, 181, 254, 32, 32, 32));
	}

	// 파티 채팅
	public void chatParty(String strMessage) {
		if (chatCommand(strMessage)) {
			return;
		}
 		if (!nowJoinParty()) {
			return;
		}
 		for (int members : Party.get(this.partyNo).getMembers()) {
 			User u = User.get(members);
 			u.getCtx().writeAndFlush(Packet.chatParty("[파티] " + this.name + " : " + strMessage, 3, 201, 169, 32, 32, 32));
 		}
 	}
 
 	// 길드 채팅
 	public void chatGuild(String strMessage) {
		if (chatCommand(strMessage)) {
			return;
		}
 		if (!nowJoinGuild()) {
			return;
		}
 		for (int members : Guild.get(this.guildNo).getMembers()) {
 			User u = User.get(members);
 			u.getCtx().writeAndFlush(Packet.chatGuild("[길드] " + this.name + " : " + strMessage, 247, 202, 24, 32, 32, 32));
 		}
 	}

	// 전체 채팅
	public void chatAll(String strMessage) {
		if (chatCommand(strMessage)) {
			return;
		}
		for (User u : users.values()) {
			u.getCtx().writeAndFlush(Packet.chatAll(this.no, "[전체] " + this.name + " : " + strMessage, 255, 255, 255, 219, 10, 91));
		}
		startShowingBalloon();
	}

	// 다른 작업을 하고 있는지 (대화, 거래)
	private boolean isBusy() {
		// 대화 중
		if (this.message.isStart()) {
			return true;
		}
		// 거래 중
		if (nowTrading()) {
			return true;
		}
		return false;
	}

    // 채팅
    public void startShowingBalloon() {
	    // 옵션 DB 에서 말풍선 표시 시간 취득
        try {
            if (this.standardDelay < 0) {
                ResultSet rs = DataBase.executeQuery("SELECT `value` FROM `setting_option` WHERE `name` = 'chatting_balloon_delay';");
                if (rs.next()) {
					this.standardDelay = rs.getInt(1);
					this.standardDelay /= 100;
                }
                rs.close();
            }
        } catch (SQLException e) {
            logger.warning(e.toString());
        }
		this.isBalloonShowing = true;
		this.startChattingTime = System.currentTimeMillis() / 100;
    }

    public void endShowingBalloon(int no) {
        Vector<User> mapUsers = Map.getMap(this.map).getField(this.seed).getUsers();
        for (User u : mapUsers) {
			u.getCtx().writeAndFlush(Packet.removeChattingBalloon(no));
		}
		this.isBalloonShowing = false;
    }

	public void update() {
		long nowTime = System.currentTimeMillis() / 100;
		// 쿨타임
		if (nowTime > this.lastTime + 1)
		{
			this.lastTime = System.currentTimeMillis() / 100;
			this.coolTime.coolDown();
		}
        // 말풍선
		if (this.isBalloonShowing) {
            if (nowTime - this.startChattingTime >= this.standardDelay) {
                endShowingBalloon(this.no);
            }
        }
	}

	// 좌표 이동
	public void move(int type) {
		// 다른 작업 중이라면 리프레쉬
		if (isBusy()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
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

			default:
		}
		// 맵 이동 여부 판정
		Field gameField = Map.getMap(this.map).getField(this.seed);
		for (Portal portal : gameField.getPortals()) {
			if (portal.getX() == this.x && portal.getY() == this.y) {
				gameField.removeUser(this);
				this.map = portal.getNextMap();
				this.x = portal.getNextX();
				this.y = portal.getNextY();
				Map.getMap(portal.getNextMap()).getField(this.seed).addUser(this);
			}
		}
	}

	// 이동이 불가능한 경우 리프레쉬
	protected boolean moveUp() {
		if (!super.moveUp()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
		}
		return true;
	}

	protected boolean moveDown() {
		if (!super.moveDown()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
		}
		return true;
	}

	protected boolean moveLeft() {
		if (!super.moveLeft()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
		}
		return true;
	}

	protected boolean moveRight() {
		if (!super.moveRight()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
		}
		return true;
	}

	// 방향 전환
	public void turn(int type) {
		// 다른 작업 중이라면 리프레쉬
		if (isBusy()) {
			this.ctx.writeAndFlush(Packet.refreshCharacter(this.characterType, this.no, this.x, this.y, this.direction));
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

			default:
		}
	}

	// 슬롯 불러오기
	public void loadSlot() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `slot` WHERE `no` = '" + no + "';");
			if (!rs.next()) {
				DataBase.executeUpdate("INSERT `slot` SET " +
						"`no` = '" + this.no + "';");
			} else {
				for (int i = 2; i < 12; ++i) {
					this.ctx.writeAndFlush(Packet.setSlot(i - 2, rs.getInt(i)));
				}
				for (int i = 2; i < 12; ++i) {
					if (rs.getInt(i) != -1) {
						this.coolTime.initCoolTime(i - 2, GameData.skill.get(findSkillByIndex(rs.getInt(i)).getNo()).getDelay(), GameData.skill.get(findSkillByIndex(rs.getInt(i)).getNo()).getNo());
					}
				}
			}
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public void setSlot(int index, int itemidx) {
		if (GameData.skill.get(findSkillByIndex(itemidx).getNo()).getLimitLevel() > this.level) {
			return;
		}
		DataBase.setSlot(this, index, itemidx);
		this.coolTime.initCoolTime(index, GameData.skill.get(findSkillByIndex(itemidx).getNo()).getDelay(), GameData.skill.get(findSkillByIndex(itemidx).getNo()).getNo());
		loadSlot();
	}

	public void delSlot(int index) {
		DataBase.delSlot(this, index);
		loadSlot();
	}

	// 게임 종료
	public void exitGracefully() {
		// 거래중이라면 거래 종료
		if (nowTrading()) {
			cancelTrade();
		}
		// 파티 가입중이라면 파티 탈퇴
		if (nowJoinParty()) {
			if (this.partyNo == this.no) {
				breakUpParty();
			} else {
				quitParty();
			}
		}
		// 맵에서 나가기
		Map.getMap(this.map).getField(this.seed).removeUser(this);
		// 유저 정보 업데이트
		DataBase.updateUser(this);
		// 장착 아이템 정보 업데이트
		DataBase.updateEquip(this);
		// 아이템과 스킬을 지운다
		DataBase.deleteItem(this.no);
		DataBase.deleteSkill(this.no);
		// 가진 아이템과 스킬을 넣자
		for (Item item : this.itemBag.values()) {
			DataBase.insertItem(item);
		}
		for (GameData.Skill skill : this.skillBag.values()) {
			DataBase.insertSkill(skill);
		}
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
		public void open(int npcNo, int npcSelect) {
			this.npcNo = npcNo;
			this.npcMessage = 0;
			this.npcSelect = npcSelect;
			ctx.writeAndFlush(Packet.openMessageWindow(this.npcNo, this.npcMessage, this.npcSelect));
		}

		// 대화 종료
		public void close() {
			this.npcNo = 0;
			ctx.writeAndFlush(Packet.closeMessageWindow());
		}

		// 대화 진행
		public void update(int message, int select) {
			this.npcMessage = message;
			this.npcSelect = select;
			ctx.writeAndFlush(Packet.openMessageWindow(this.npcNo, this.npcMessage, this.npcSelect));
		}
	}

	class CoolTime
	{
		private Vector<int[]> slot = new Vector<>();
		private int basicAttack;
		private int global;

		public CoolTime() {
			for (int i = 0; i < 10; ++i) {
				int[] a = new int[3];
				this.slot.add(i, a);
			}
		}

		public int getSkillNo(int index) {
			return slot.get(index - 1)[0];
		}

		public int getBasicAttack() {
			return basicAttack;
		}

		public void setBasicAttack(int iValue) {
			basicAttack = iValue;
		}

		public void setGlobal(int value) {
			global = value;
		}

		public int getGlobal() {
			return global;
		}

		public void initCoolTime(int index, int value, int no) {
			this.slot.get(index)[0] = no;
			this.slot.get(index)[1] = 0;
			this.slot.get(index)[2] = value;
			ctx.writeAndFlush(Packet.setCoolTime(this.slot.get(index)[1], this.slot.get(index)[2], index));
		}

		public int getCoolTime(int no) {
			for (int i = 0; i < 10; ++i) {
				if (this.slot.get(i)[0] == no) {
					return this.slot.get(i)[1];
				}
			}
			return -1;
		}

		public void setCoolTime(int value, int no) {
			for (int i = 0; i < 10; ++i) {
				if (this.slot.get(i)[0] == no) {
					this.slot.get(i)[1] = value;
					ctx.writeAndFlush(Packet.setCoolTime(this.slot.get(i)[1], this.slot.get(i)[2], i));
				}
			}
		}

		public void coolDown() {
			for (int i = 0; i < 10; ++i) {
				if (this.slot.get(i)[1] > 0) {
					--this.slot.get(i)[1];
					ctx.writeAndFlush(Packet.setCoolTime(this.slot.get(i)[1], this.slot.get(i)[2], i));
				}
			}
			if (this.basicAttack > 0) {
				--this.basicAttack;
			}
			if (this.global > 0) {
				--this.global;
			}
		}
	}
}