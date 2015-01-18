package game;

import io.netty.channel.ChannelHandlerContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.logging.Logger;

import network.Handler;
import packet.Packet;
import database.DataBase;
import database.GameData;

public class User {
	
	private Logger logger = Logger.getLogger(User.class.getName());
	private ChannelHandlerContext ctx;
	private int no;
	private String id;
	private String pass;
	private String name;
	private String mail;
	private String image;
	private String guild;
	private int job;
	private int pureStr;
	private int pureDex;
	private int pureAgi;
	private int statPoint;
	private int skillPoint;
	private int title;
	private int hp;
	private int mp;
	private int level;
	private int exp;
	private int gold;
	private int map;
	private int x;
	private int y;
	private int direction;
	private int speed;
	private boolean admin;
	
	private int weapon = -1;
	private int shield = -1;
	private int helmet = -1;
	private int armor = -1;
	private int cape = -1;
	private int shoes = -1;
	private int accessory = -1;

	private int maxInventory = 35;
	
	private Hashtable<Integer, GameData.InventoryItem> inventory = new Hashtable<Integer, GameData.InventoryItem>();
	
	public User(ChannelHandlerContext ctx, int no, String id, String pass, String name, int title, String mail, String image, int job, 
				int str, int dex, int agi, int statPoint, int skillPoint, int hp, int mp, int level, int exp, int gold, int map, int x, 
				int y, int d, int speed, int admin) {
		this.ctx = ctx;
		this.no = no;
		this.id = id;
		this.pass = pass;
		this.name = name;
		this.title = title;
		this.guild = "";
		this.mail = mail;
		this.image = image;
		this.job = job;
		this.pureStr = str;
		this.pureDex = dex;
		this.pureAgi = agi;
		this.statPoint = statPoint;
		this.skillPoint = skillPoint;
		this.hp = hp;
		this.mp = mp;
		this.level = level;
		this.exp = exp;
		this.map = map;
		this.gold = gold;
		this.x = x;
		this.y = y;
		this.direction = d;
		this.speed = speed;
		this.admin = admin == 0 ? false : true;

		// 35번 인덱스에 빈 아이템 넣음
		inventory.put(35, new GameData.InventoryItem(no, 0, 0, 35, 0));
	}
	
	public ChannelHandlerContext getCtx() {
		return ctx;
	}
	
	public int getNo() {
		return no;
	}
	
	public String getID() {
		return id;
	}
	
	public String getPass() {
		return pass;
	}
	
	public String getName() {
		return name;
	}
	
	public int getTitle() {
		return title;
	}

	public void setTitle(int t) {
		title = t;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.TITLE, t));
	}
	
	public String getGuild() {
		return guild;
	}
	
	public String getMail() {
		return mail;
	}
	
	public String getImage() {
		return image;
	}

	public void setImage(String i) {
		image = i;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.IMAGE, i));
	}
	
	public int getJob() {
		return job;
	}

	public void setJob(int j) {
		job = j;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.JOB, j));
	}
	
	public int getStr() {
		int n = 0;
		// 스텟 Str
		n += pureStr;
		// 직업 기본 Str
		n += GameData.job.get(job).getStr() * level;
		// 아이템으로 오르는 Str
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getStr();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getStr();
		// 아이템 추가 능력치로 오르는 Str
		n += findItemByIndex(weapon).getStr();
		n += findItemByIndex(shield).getStr();
		n += findItemByIndex(helmet).getStr();
		n += findItemByIndex(armor).getStr();
		n += findItemByIndex(cape).getStr();
		n += findItemByIndex(shoes).getStr();
		n += findItemByIndex(accessory).getStr();
		
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
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getDex();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getDex();
		// 아이템 추가 능력치로 오르는 Dex
		n += findItemByIndex(weapon).getDex();
		n += findItemByIndex(shield).getDex();
		n += findItemByIndex(helmet).getDex();
		n += findItemByIndex(armor).getDex();
		n += findItemByIndex(cape).getDex();
		n += findItemByIndex(shoes).getDex();
		n += findItemByIndex(accessory).getDex();
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
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getAgi();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getAgi();
		// 아이템 추가 능력치로 오르는 Agi
		n += findItemByIndex(weapon).getAgi();
		n += findItemByIndex(shield).getAgi();
		n += findItemByIndex(helmet).getAgi();
		n += findItemByIndex(armor).getAgi();
		n += findItemByIndex(cape).getAgi();
		n += findItemByIndex(shoes).getAgi();
		n += findItemByIndex(accessory).getAgi();
		return n;
	}
	
	public int getPureAgi() {
		return pureAgi;
	}

	public int getHp() {
		return hp;
	}

	public void gainHp(int value) {
		if (hp + value > getMaxHp())
			value = getMaxHp() - hp;

		hp += value;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.HP, hp));
	}

	public void loseHp(int value) {
		if (hp - value < 0) {
			// 쥬금
			return;
		}

		gainHp(-value);
	}
	
	public int getMaxHp() {
		int n = 0;
		// 직업 기본 Hp
		n += GameData.job.get(job).getHp() * level;
		// 아이템으로 오르는 Hp
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getHp();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getHp();
		// 아이템 추가 능력치로 오르는 Hp
		n += findItemByIndex(weapon).getHp();
		n += findItemByIndex(shield).getHp();
		n += findItemByIndex(helmet).getHp();
		n += findItemByIndex(armor).getHp();
		n += findItemByIndex(cape).getHp();
		n += findItemByIndex(shoes).getHp();
		n += findItemByIndex(accessory).getHp();

		return n;
	}

	public int getMp() {
		return mp;
	}

	public void gainMp(int value) {
		if (mp + value > getMaxMp())
			value = getMaxMp() - mp;

		mp += value;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.MP, mp));
	}

	public boolean loseMp(int value) {
		if (mp - value < 0)
			return false;

		gainMp(-value);
		return true;
	}
	
	public int getMaxMp() {
		int n = 0;
		// 직업 기본 Mp
		n += GameData.job.get(job).getMp() * level;
		// 아이템으로 오르는 Mp
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getMp();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getMp();
		// 아이템 추가 능력치로 오르는 Mp
		n += findItemByIndex(weapon).getMp();
		n += findItemByIndex(shield).getMp();
		n += findItemByIndex(helmet).getMp();
		n += findItemByIndex(armor).getMp();
		n += findItemByIndex(cape).getMp();
		n += findItemByIndex(shoes).getMp();
		n += findItemByIndex(accessory).getMp();
		
		return n;
	}
	
	public int getCritical() {
		int n = 0;
		// 아이템으로 오르는 Critical
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getCritical();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getCritical();
		// 아이템 추가 능력치로 오르는 Critical
		n += findItemByIndex(weapon).getCritical();
		n += findItemByIndex(shield).getCritical();
		n += findItemByIndex(helmet).getCritical();
		n += findItemByIndex(armor).getCritical();
		n += findItemByIndex(cape).getCritical();
		n += findItemByIndex(shoes).getCritical();
		n += findItemByIndex(accessory).getCritical();
		
		return n;
	}
	
	public int getAvoid() {
		int n = 0;
		// 아이템으로 오르는 Avoid
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getAvoid();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getAvoid();
		// 아이템 추가 능력치로 오르는 Avoid
		n += findItemByIndex(weapon).getAvoid();
		n += findItemByIndex(shield).getAvoid();
		n += findItemByIndex(helmet).getAvoid();
		n += findItemByIndex(armor).getAvoid();
		n += findItemByIndex(cape).getAvoid();
		n += findItemByIndex(shoes).getAvoid();
		n += findItemByIndex(accessory).getAvoid();

		return n;
	}
	
	public int getHit() {
		int n = 0;
		// 아이템으로 오르는 Hit
		n += GameData.item.get(findItemByIndex(weapon).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(shield).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(helmet).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(armor).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(cape).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(shoes).getItemNo()).getHit();
		n += GameData.item.get(findItemByIndex(accessory).getItemNo()).getHit();
		// 아이템 추가 능력치로 오르는 Hit
		n += findItemByIndex(weapon).getHit();
		n += findItemByIndex(shield).getHit();
		n += findItemByIndex(helmet).getHit();
		n += findItemByIndex(armor).getHit();
		n += findItemByIndex(cape).getHit();
		n += findItemByIndex(shoes).getHit();
		n += findItemByIndex(accessory).getHit();

		return n;
	}
	
	public int getLevel() {
		return level;
	}
	
	public int getExp() {
		return exp;
	}

	public int getMaxExp() {
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

			ctx.write(Packet.updateStatus(GameData.StatusType.LEVEL, level));
			ctx.write(Packet.updateStatus(GameData.StatusType.STAT_POINT, statPoint));
			ctx.write(Packet.updateStatus(GameData.StatusType.SKILL_POINT, skillPoint));
			ctx.write(Packet.updateStatus(GameData.StatusType.MAX_EXP, getMaxExp()));
		}

		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.EXP, exp));
	}

	public void loseExp(int value) {
		if (exp - value < 0)
			value = exp;

		gainExp(-value);
	}

	public int getGold() {
		return gold;
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
	
	public int getSpeed() {
		return speed;
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
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `inventory` WHERE `user_no` = '" + no + "';");
    	
	    	while (rs.next()) {
	    		inventory.put(rs.getInt("index"), 
				    				new GameData.InventoryItem(
				    				rs.getInt("user_no"),
				    				rs.getInt("item_no"),
				    				rs.getInt("amount"),
				    				rs.getInt("index"),
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
				    				rs.getInt("reinforce"),
				    				rs.getInt("trade")));

	    		ctx.writeAndFlush(Packet.setInventory(inventory.get(rs.getInt("index"))));
	    	}

			ctx.writeAndFlush(Packet.setInventory(inventory.get(35)));
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
		
	}
	
	// 아이템 장착
	public void equipItem(int type, int index) {
		switch (type) {
		case GameData.ItemType.WEAPON:
			weapon = index;
			break;
		case GameData.ItemType.SHIELD:
			shield = index;
			break;
		case GameData.ItemType.HELMET:
			helmet = index;
			break;
		case GameData.ItemType.ARMOR:
			armor = index;
			break;
		case GameData.ItemType.CAPE:
			cape = index;
			break;
		case GameData.ItemType.SHOES:
			shoes = index;
			break;
		case GameData.ItemType.ACCESSORY:
			accessory = index;
			break;
		}
	}
	
	public void useStatPoint(int stat) {
		if (statPoint <= 0)
			return;
		
		switch (stat) {
			case GameData.StatusType.STR:
				pureStr++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getStr()));
				break;
			case GameData.StatusType.DEX:
				pureDex++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getDex()));
				break;
			case GameData.StatusType.AGI:
				pureAgi++;
				ctx.writeAndFlush(Packet.updateStatus(stat, getAgi()));
				break;
			default:
				return;
		}

		statPoint--;
		ctx.writeAndFlush(Packet.updateStatus(GameData.StatusType.STAT_POINT, statPoint));
	}

	// NPC로부터 아이템 획득 (번호만으로 아이템 획득)
	public boolean gainItem(int itemNo, int num) {
		int gap = 0;
		int index = getEmptyIndex();
		GameData.Item i = GameData.item.get(itemNo);
		GameData.InventoryItem item = findLazyItemByNo(itemNo);

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
			inventory.put(index, new GameData.InventoryItem(no, itemNo, num, index, i.isTradeable() ? 1 : 0));
			ctx.writeAndFlush(Packet.setInventory(inventory.get(index)));
			index = getEmptyIndex();
			num -= i.getMaxLoad();
		}

		return true;
	}

	public boolean loseItemByNo(int itemNo, int num) {
		if (itemNo <= 0 || num <= 0)
			return false;
		
		int gap = 0;
		GameData.InventoryItem i = findItemByNo(itemNo);

		if (i == null || getTotalItemAmount(i.getItemNo()) < num)
			return false;

		do {
			gap = num - i.getAmount();
			i.changeAmount(-num);
			if (i.getAmount() == 0) {
				inventory.remove(i.getIndex());
				ctx.writeAndFlush(Packet.updateInventory(0, i));
			} else {
				ctx.writeAndFlush(Packet.updateInventory(1, i));
			}
			num = gap;
		} while (num > 0);

		return true;
	}

	public boolean loseItemByIndex(int index, int num) {
		GameData.InventoryItem i = findItemByIndex(index);

		if (i == null || i.getAmount() < num)
			return false;

		i.changeAmount(-num);
		if (i.getAmount() == 0) {
			inventory.remove(i.getIndex());
			ctx.writeAndFlush(Packet.updateInventory(0, i));
		} else {
			ctx.writeAndFlush(Packet.updateInventory(1, i));
		}

		return true;
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 0; i < maxInventory; i++) {
			if (!inventory.containsKey(i))
				return i;
		}
		
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getTotalItemAmount(int no) {
		int num = 0;
		for (GameData.InventoryItem item : inventory.values()) {
			if (item.getItemNo() == no)
				num += item.getAmount();
		}
		
		return num;
	}
	
	// Index로 아이템 검색
	public GameData.InventoryItem findItemByIndex(int index) {
		if (!inventory.containsKey(index))
			return null;
		
		return inventory.get(index);
	}

	// No로 아이템 검색
	public GameData.InventoryItem findItemByNo(int no) {
		for (GameData.InventoryItem item : inventory.values()) {
			if (item.getItemNo() == no)
				return item;
		}

		return null;
	}

	// No로 아이템 검색
	public GameData.InventoryItem findLazyItemByNo(int no) {
		for (GameData.InventoryItem item : inventory.values()) {
			if (item.getItemNo() == no && item.getAmount() < GameData.item.get(item.getItemNo()).getMaxLoad())
				return item;
		}

		return null;
	}

	public void changeItemIndex(int index1, int index2) {
		if (!inventory.containsKey(index1) || !inventory.containsKey(index2))
			return;

		GameData.InventoryItem item1 = inventory.get(index1);
		GameData.InventoryItem item2 = inventory.get(index2);
		inventory.remove(index1);
		inventory.remove(index2);
		item1.setIndex(index2);
		item2.setIndex(index1);
		inventory.put(index2, item1);
		inventory.put(index1, item2);

		ctx.write(Packet.setInventory(item1));
		ctx.writeAndFlush(Packet.setInventory(item2));
	}

	public void turnUp() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.UP;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnDown() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.DOWN;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnLeft() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.LEFT;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}

	public void turnRight() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.RIGHT;

		gameMap.sendToOthers(this, Packet.turnCharacter(0, no, direction));
	}
	
	public void moveUp() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.UP;

		if (gameMap.isPassable(x, y - 1)) {
			y -= 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveDown() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.DOWN;

		if (gameMap.isPassable(x, y + 1)) {
			y += 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveLeft() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.LEFT;

		if (gameMap.isPassable(x - 1, y)) {
			x -= 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
	public void moveRight() {
		Map gameMap = Handler.map.get(map);
		direction = GameData.Direction.RIGHT;

		if (gameMap.isPassable(x + 1, y)) {
			x += 1;
			gameMap.sendToOthers(this, Packet.moveCharacter(0, no, x, y, direction));
		} else {
			ctx.writeAndFlush(Packet.userRefresh(this));
		}
	}
	
}
