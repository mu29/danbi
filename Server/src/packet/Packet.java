package packet;

import database.Type;
import game.Field;
import game.Guild;
import game.User;
import game.Character;

import org.json.simple.JSONObject;

import database.GameData;

@SuppressWarnings("unchecked")
public final class Packet {
	
	// success(0), id/pass error(1), sql error(2)
	public static JSONObject loginMessage(int type) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.LOGIN);
		packet.put("type", type);
		
		return packet;
	}

	public static JSONObject loginMessage(User user) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.LOGIN);
		packet.put("type", 0);
		packet.put("no", user.getNo());
		packet.put("id", user.getID());
		packet.put("name", user.getName());
		packet.put("title", user.getTitle());
		packet.put("image", user.getImage());
		packet.put("job", user.getJob());
		packet.put("guild", Guild.get(user.getGuild()) != null ? Guild.get(user.getGuild()).getName() : "");
		packet.put("guildNo", user.getGuild());
		packet.put("str", user.getStr());
		packet.put("dex", user.getDex());
		packet.put("agi", user.getAgi());
		packet.put("statPoint", user.getStatPoint());
		packet.put("skillPoint", user.getSkillPoint());
		packet.put("critical", user.getCritical());
		packet.put("avoid", user.getAvoid());
		packet.put("hit", user.getHit());
		packet.put("hp", user.getHp());
		packet.put("maxHp", user.getMaxHp());
		packet.put("mp", user.getMp());
		packet.put("maxMp", user.getMaxMp());
		packet.put("level", user.getLevel());
		packet.put("exp", user.getExp());
		packet.put("maxExp", user.getMaxExp());
		packet.put("gold", user.getGold());
		packet.put("map", user.getMap());
		packet.put("x", user.getX());
		packet.put("y", user.getY());
		packet.put("direction", user.getDirection());

		packet.put("weapon", user.getWeapon());
		packet.put("shield", user.getShield());
		packet.put("helmet", user.getHelmet());
		packet.put("armor", user.getArmor());
		packet.put("cape", user.getCape());
		packet.put("shoes", user.getShoes());
		packet.put("accessory", user.getAccessory());
		
		return packet;
	}

	// success(0), id exists(1), nick exists(2), SQL error(3)
	public static JSONObject registerMessage(int type) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REGISTER);
		packet.put("type", type);
		
		return packet;
	}

	public static JSONObject createCharacter(int type, Character c) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CREATE_CHARACTER);
		packet.put("type", type);
		packet.put("no", c.getNo());
		packet.put("name", c.getName());
		packet.put("image", c.getImage());
		packet.put("speed", c.getMoveSpeed());
		packet.put("hp", c.getHp());
		packet.put("maxHp", c.getMaxHp());
		packet.put("x", c.getX());
		packet.put("y", c.getY());
		packet.put("d", c.getDirection());

		if (type == Type.Character.USER) {
			User u = (User) c;
			packet.put("guild", Guild.get(u.getGuild()) != null ? Guild.get(u.getGuild()).getName() : "");
			packet.put("title", u.getTitle());
		}
		
		return packet;
	}

	public static JSONObject removeCharacter(int type, int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		
		return packet;
	}

	public static JSONObject refreshCharacter(int type, int no, int x, int y, int d) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REFRESH_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("x", x);
		packet.put("y", y);
		packet.put("d", d);
		
		return packet;
	}

	public static JSONObject moveCharacter(int type, int no, int x, int y, int d) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.MOVE_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("x", x);
		packet.put("y", y);
		packet.put("d", d);
		
		return packet;
	}

	public static JSONObject turnCharacter(int type, int no, int d) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.TURN_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("d", d);

		return packet;
	}

	public static JSONObject jumpCharacter(int type, int no, int x, int y) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.JUMP_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("x", x);
		packet.put("y", y);

		return packet;
	}

	public static JSONObject animationCharacter(int type, int no, int ani) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.ANIMATION_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("ani", ani);

		return packet;
	}

	public static JSONObject updateCharacter(int type, int no, int[] keys, Object[] values) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		for (int i = 0; i < keys.length; i++)
			packet.put(keys[i], values[i]);

		return packet;
	}

	public static JSONObject damageCharacter(int type, int no, int value, boolean critical) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.DAMAGE_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("value", value);
		if (critical) packet.put("critical", 1);

		return packet;
	}

	public static JSONObject loadDropItem(Field.DropItem item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.LOAD_DROP_ITEM);
		packet.put("no", item.getNo());
		packet.put("x", item.getX());
		packet.put("y", item.getY());
		packet.put("image", item.getImage());

		return packet;
	}

	public static JSONObject loadDropGold(Field.DropGold gold) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.LOAD_DROP_GOLD);
		packet.put("no", gold.getNo());
		packet.put("x", gold.getX());
		packet.put("y", gold.getY());
		packet.put("amount", gold.getAmount());

		return packet;
	}

	public static JSONObject removeDropItem(Field.DropItem item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_DROP_ITEM);
		packet.put("no", item.getNo());

		return packet;
	}

	public static JSONObject removeDropGold(Field.DropGold gold) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_DROP_GOLD);
		packet.put("no", gold.getNo());

		return packet;
	}

	public static JSONObject notify(String message) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.NOTIFY);
		packet.put("message", message);

		return packet;
	}

	public static JSONObject notify(String message, int r, int g, int b) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.NOTIFY);
		packet.put("message", message);
		packet.put("r", r);
		packet.put("g", g);
		packet.put("b", b);

		return packet;
	}

	public static JSONObject notify(String message, int r, int g, int b, int r2, int g2, int b2) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.NOTIFY);
		packet.put("message", message);
		packet.put("r", r);
		packet.put("g", g);
		packet.put("b", b);
		packet.put("r2", r2);
		packet.put("g2", g2);
		packet.put("b2", b2);

		return packet;
	}

	public static JSONObject moveMap(User u) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.MOVE_MAP);
		packet.put("map", u.getMap());
		packet.put("x", u.getX());
		packet.put("y", u.getY());

		return packet;
	}

	public static JSONObject chat(String message) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CHAT);
		packet.put("message", message);

		return packet;
	}

	public static JSONObject chat(String message, int r, int g, int b) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CHAT);
		packet.put("message", message);
		packet.put("r", r);
		packet.put("g", g);
		packet.put("b", b);

		return packet;
	}

	public static JSONObject chat(String message, int r, int g, int b, int r2, int g2, int b2) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CHAT);
		packet.put("message", message);
		packet.put("r", r);
		packet.put("g", g);
		packet.put("b", b);
		packet.put("r2", r2);
		packet.put("g2", g2);
		packet.put("b2", b2);

		return packet;
	}
	
	public static JSONObject openRegisterWindow() {
		String[] image = new String[GameData.register.size()];
		int[] job = new int[GameData.register.size()];
		for (int i = 0; i < GameData.register.size(); i++) {
			image[i] = GameData.register.get(i + 1).getImage();
			job[i] = GameData.register.get(i + 1).getJob();
		}
		
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.OPEN_REGISTER_WINDOW);
		packet.put("image", image);
		packet.put("job", job);
		
		return packet;
	}

	public static JSONObject updateStatus(int[] keys, Object[] values) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_STATUS);
		for (int i = 0; i < keys.length; i++)
			packet.put(keys[i], values[i]);

		return packet;
	}
	
	public static JSONObject setItem(GameData.Item item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_ITEM);
		packet.put("userNo", item.getUserNo());
		packet.put("itemNo", item.getNo());
		packet.put("amount", item.getAmount());
		packet.put("index", item.getIndex());
		packet.put("damage", item.getDamage());
		packet.put("magicDamage", item.getMagicDamage());
		packet.put("defense", item.getDefense());
		packet.put("magicDefense", item.getMagicDefense());
		packet.put("str", item.getStr());
		packet.put("dex", item.getDex());
		packet.put("agi", item.getAgi());
		packet.put("hp", item.getHp());
		packet.put("mp", item.getMp());
		packet.put("critical", item.getCritical());
		packet.put("avoid", item.getAvoid());
		packet.put("hit", item.getHit());
		packet.put("reinforce", item.getReinforce());
		packet.put("trade", item.isTradeable() ? 1 : 0);
		packet.put("equipped", item.isEquipped() ? 1 : 0);

		return packet;
	}

	// 삭제(0), 갯수(1)
	public static JSONObject updateItem(int type, GameData.Item item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_ITEM);
		packet.put("type", type);
		packet.put("index", item.getIndex());
		packet.put("amount", item.getAmount());
		packet.put("damage", item.getDamage());
		packet.put("magicDamage", item.getMagicDamage());
		packet.put("defense", item.getDefense());
		packet.put("magicDefense", item.getMagicDefense());
		packet.put("str", item.getStr());
		packet.put("dex", item.getDex());
		packet.put("agi", item.getAgi());
		packet.put("hp", item.getHp());
		packet.put("mp", item.getMp());
		packet.put("critical", item.getCritical());
		packet.put("avoid", item.getAvoid());
		packet.put("hit", item.getHit());
		packet.put("reinforce", item.getReinforce());
		packet.put("trade", item.isTradeable() ? 1 : 0);
		packet.put("equipped", item.isEquipped() ? 1 : 0);

		return packet;
	}

	public static JSONObject setSkill(GameData.Skill skill) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_SKILL);
		packet.put("no", skill.getNo());
		packet.put("rank", skill.getRank());

		return packet;
	}

	// 삭제(0), 랭크(1)
	public static JSONObject updateSkill(int type, GameData.Skill skill) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_SKILL);
		packet.put("type", type);
		packet.put("no", skill.getNo());
		packet.put("rank", skill.getRank());

		return packet;
	}

	public static JSONObject requestTrade(int partnerNo) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REQUEST_TRADE);
		packet.put("partnerNo", partnerNo);

		return packet;
	}

	public static JSONObject openTradeWindow(int partnerNo) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.OPEN_TRADE_WINDOW);
		packet.put("partnerNo", partnerNo);

		return packet;
	}

	public static JSONObject loadTradeItem(GameData.Item item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.LOAD_TRADE_ITEM);
		packet.put("userNo", item.getUserNo());
		packet.put("itemNo", item.getNo());
		packet.put("amount", item.getAmount());
		packet.put("index", item.getIndex());
		packet.put("damage", item.getDamage());
		packet.put("magicDamage", item.getMagicDamage());
		packet.put("defense", item.getDefense());
		packet.put("magicDefense", item.getMagicDefense());
		packet.put("str", item.getStr());
		packet.put("dex", item.getDex());
		packet.put("agi", item.getAgi());
		packet.put("hp", item.getHp());
		packet.put("mp", item.getMp());
		packet.put("critical", item.getCritical());
		packet.put("avoid", item.getAvoid());
		packet.put("hit", item.getHit());
		packet.put("reinforce", item.getReinforce());

		return packet;
	}

	public static JSONObject dropTradeItem(int no, int index) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.DROP_TRADE_ITEM);
		packet.put("no", no);
		packet.put("index", index);

		return packet;
	}

	public static JSONObject changeTradeGold(int no, int amount) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CHANGE_TRADE_GOLD);
		packet.put("no", no);
		packet.put("amount", amount);

		return packet;
	}

	public static JSONObject acceptTrade(int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.FINISH_TRADE);
		packet.put("no", no);

		return packet;
	}

	public static JSONObject cancelTrade() {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CANCEL_TRADE);

		return packet;
	}

	// 닫기(-1), 다음(0), 선택지 갯수 (1~)
	public static JSONObject openMessageWindow(int no, int message, int select) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.OPEN_MESSAGE_WINDOW);
		packet.put("no", no);
		packet.put("message", message);
		packet.put("select", select);

		return packet;
	}

	public static JSONObject closeMessageWindow() {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CLOSE_MESSAGE_WINDOW);

		return packet;
	}

	public static JSONObject setShopItem(int no, int price) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_SHOP_ITEM);
		packet.put("no", no);
		packet.put("price", price);

		return packet;
	}

	public static JSONObject setParty(int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_PARTY);
		packet.put("no", no);

		return packet;
	}

	public static JSONObject inviteParty(int partyNo, String master) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.INVITE_PARTY);
		packet.put("master", master);
		packet.put("partyNo", partyNo);

		return packet;
	}

	public static JSONObject setPartyMember(User user) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_PARTY_MEMBER);
		packet.put("no", user.getNo());
		packet.put("name", user.getName());
		packet.put("image", user.getImage());
		packet.put("level", user.getLevel());
		packet.put("job", user.getJob());
		packet.put("hp", user.getHp());
		packet.put("maxHp", user.getMaxHp());

		return packet;
	}

	public static JSONObject removePartyMember(int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_PARTY_MEMBER);
		packet.put("no", no);

		return packet;
	}

	public static JSONObject createGuild(int amount) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.CREATE_GUILD);
		packet.put("amount", amount);

		return packet;
	}

	public static JSONObject setGuild(int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_GUILD);
		packet.put("no", no);

		return packet;
	}

	public static JSONObject inviteGuild(int guildNo, String master) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.INVITE_GUILD);
		packet.put("master", master);
		packet.put("guildNo", guildNo);

		return packet;
	}

	public static JSONObject setGuildMember(User user) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_GUILD_MEMBER);
		packet.put("no", user.getNo());
		packet.put("name", user.getName());
		packet.put("image", user.getImage());
		packet.put("level", user.getLevel());
		packet.put("job", user.getJob());
		packet.put("hp", user.getHp());
		packet.put("maxHp", user.getMaxHp());

		return packet;
	}

	public static JSONObject setGuildMember(int no, String name, String image, int level, int job, int hp, int maxHp) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_GUILD_MEMBER);
		packet.put("no", no);
		packet.put("name", name);
		packet.put("image", image);
		packet.put("level", level);
		packet.put("job", job);
		packet.put("hp", hp);
		packet.put("maxHp", maxHp);

		return packet;
	}

	public static JSONObject removeGuildMember(int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_GUILD_MEMBER);
		packet.put("no", no);

		return packet;
	}
}
