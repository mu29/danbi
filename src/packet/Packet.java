package packet;

import database.Type;
import game.User;
import game.Character;

import org.json.simple.JSONObject;

import database.GameData;

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
			packet.put("guild", u.getGuild());
			packet.put("title", u.getTitle());
		}
		
		return packet;
	}

	public static JSONObject removeCharacter(int type, String name, int no) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.REMOVE_CHARACTER);
		packet.put("type", type);
		packet.put("name", name);
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

	public static JSONObject updateCharacter(int type, int no, int status, Object value) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_CHARACTER);
		packet.put("type", type);
		packet.put("no", no);
		packet.put("status", status);
		packet.put("value", value);

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

	public static JSONObject updateStatus(int type, Object value) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_STATUS);
		packet.put("type", type);
		packet.put("value", value);

		return packet;
	}
	
	public static JSONObject setInventory(GameData.Item item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_INVENTORY);
		packet.put("userNo", item.getUserNo());
		packet.put("itemNo", item.getItemNo());
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

		return packet;
	}

	// 삭제(0), 갯수(1)
	public static JSONObject updateInventory(int type, GameData.Item item) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.UPDATE_INVENTORY);
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

		return packet;
	}

	public static JSONObject setSkillList(GameData.Skill skill) {
		JSONObject packet = new JSONObject();
		packet.put("header", STCHeader.SET_SKILL_LIST);
		packet.put("no", skill.getNo());
		packet.put("rank", skill.getRank());

		return packet;
	}
}
