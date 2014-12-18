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
	
	private int weapon = 0;
	private int shield = 0;
	private int helmet = 0;
	private int armor = 0;
	private int cape = 0;
	private int shoes = 0;
	private int accessory = 0;
	
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
	}
	
	public ChannelHandlerContext getCtx() {
		return this.ctx;
	}
	
	public int getNo() {
		return this.no;
	}
	
	public String getID() {
		return this.id;
	}
	
	public String getPass() {
		return this.pass;
	}
	
	public String getName() {
		return this.name;
	}
	
	public int getTitle() {
		return this.title;
	}
	
	public String getGuild() {
		return this.guild;
	}
	
	public String getMail() {
		return this.mail;
	}
	
	public String getImage() {
		return this.image;
	}
	
	public int getJob() {
		return this.job;
	}
	
	public int getStr() {
		int n = 0;
		n += pureStr;
		n += GameData.job.get(this.job).getStr() * this.level;
		return n;
	}
	
	public int getPureStr() {
		return this.pureStr;
	}
	
	public int getDex() {
		int n = 0;
		n += pureDex;
		n += GameData.job.get(this.job).getDex() * this.level;
		return n;
	}
	
	public int getPureDex() {
		return this.pureDex;
	}
	
	public int getAgi() {
		int n = 0;
		n += pureAgi;
		n += GameData.job.get(this.job).getAgi() * this.level;
		return n;
	}
	
	public int getPureAgi() {
		return this.pureAgi;
	}
	
	public int getMaxHp() {
		int n = 0;
		n += GameData.job.get(this.job).getHp() * this.level;
		return n;
	}
	
	public int getMaxMp() {
		int n = 0;
		n += GameData.job.get(this.job).getMp() * this.level;
		return n;
	}
	
	public int getMaxExp() {
		int n = 0;
		n += this.level * this.level * 10;
		return n;
	}
	
	public int getHp() {
		return this.hp;
	}
	
	public int getMp() {
		return this.mp;
	}
	
	public int getCritical() {
		return 0;
	}
	
	public int getAvoid() {
		return 0;
	}
	
	public int getHit() {
		return 0;
	}
	
	public int getLevel() {
		return this.level;
	}
	
	public int getExp() {
		return this.exp;
	}
	
	public int getGold() {
		return this.gold;
	}
	
	public int getMap() {
		return this.map;
	}
	
	public int getX() {
		return this.x;
	}
	
	public int getY() {
		return this.y;
	}
	
	public int getDirection() {
		return this.direction;
	}
	
	public int getSpeed() {
		return this.speed;
	}
	
	public int getStatPoint() {
		return this.statPoint;
	}
	
	public int getSkillPoint() {
		return this.skillPoint;
	}
	
	public boolean isAdmin() {
		return this.admin;
	}

	public int getWeapon() {
		return this.weapon;
	}
	
	public int getShield() {
		return this.shield;
	}
	
	public int getHelmet() {
		return this.helmet;
	}
	
	public int getArmor() {
		return this.armor;
	}
	
	public int getCape() {
		return this.cape;
	}
	
	public int getShoes() {
		return this.shoes;
	}
	
	public int getAccessory() {
		return this.accessory;
	}
	
	public void loadData() {
		loadEquipItem();
		loadInventory();
	}
	
	// 데이터베이스로부터 장착한 아이템 로드
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
	    	}
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public void loadInventory() {
		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `inventory` WHERE `user_no` = '" + this.no + "';");
    	
	    	while (rs.next()) {
	    		this.inventory.put(rs.getInt("index"), 
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
	    		
	    		this.ctx.writeAndFlush(Packet.setInventory(inventory.get(rs.getInt("index"))));
	    	}
	    	
			rs.close();
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
		
	}
	
	// 아이템 장착
	public void equipItem(int type, int no) {
		switch (type) {
		// 끼던거 돌려주고 낀건 뺏어
		case GameData.ItemType.WEAPON:
			removeItemByNo(no, 1);
			addItem(this.weapon, 1);
			this.weapon = no;
			break;
		case GameData.ItemType.SHIELD:
			removeItemByNo(no, 1);
			addItem(this.shield, 1);
			this.shield = no;
			break;
		case GameData.ItemType.HELMET:
			removeItemByNo(no, 1);
			addItem(this.helmet, 1);
			this.helmet = no;
			break;
		case GameData.ItemType.ARMOR:
			removeItemByNo(no, 1);
			addItem(this.armor, 1);
			this.armor = no;
			break;
		case GameData.ItemType.CAPE:
			removeItemByNo(no, 1);
			addItem(this.cape, 1);
			this.cape = no;
			break;
		case GameData.ItemType.SHOES:
			removeItemByNo(no, 1);
			addItem(this.shoes, 1);
			this.shoes = no;
			break;
		case GameData.ItemType.ACCESSORY:
			removeItemByNo(no, 1);
			addItem(this.accessory, 1);
			this.accessory = no;
			break;
		}
	}
	
	public void useStatPoint(String stat) {
		if (this.statPoint <= 0) {
			return;
		}
		
		switch (stat) {
			case "str":
				this.pureStr++;
				this.ctx.writeAndFlush(Packet.updateStatus(stat, this.pureStr));
				break;
			case "dex":
				this.pureDex++;
				this.ctx.writeAndFlush(Packet.updateStatus(stat, this.pureDex));
				break;
			case "agi":
				this.pureAgi++;
				this.ctx.writeAndFlush(Packet.updateStatus(stat, this.pureAgi));
				break;
			default:
				return;
		}

		this.statPoint--;
		this.ctx.writeAndFlush(Packet.updateStatus("statPoint", this.statPoint));
	}

	// NPC로부터 아이템 획득 (번호만으로 아이템 획득)
	public void addItem(int no, int num) {
		int index = getEmptyIndex();
		GameData.Item i = GameData.item.get(no);

		// 새로 얻은 아이템일 경우
		if (findItemByNo(no) == null) {
			if (index == -1) {
				return;
			}
			inventory.put(index, new GameData.InventoryItem(this.no, no, num, index, i.isTradeable() ? 1 : 0));
		} else {
			// 이미 있던 아이템일 경우
			int gap = findItemByNo(no).getAmount() + num - i.getMaxLoad();
			findItemByNo(no).setUpAmount(num);
			if (gap > 0) {
				if (index == -1) {
					// gap만큼 아이템 드랍한다
					return;
				} else {
					inventory.put(index, new GameData.InventoryItem(this.no, no, gap, index, i.isTradeable() ? 1 : 0));
				}
			}
		}
	}
	
	// No로 아이템 제거
	public void removeItemByNo(int no, int num) {
		if (no == 0 || num < 0) {
			return;
		}
		
		int gap = 0;
		GameData.InventoryItem i = null;
		do {
			i = findItemByNo(no);
			if (i != null) {
				gap = i.getAmount() - num;
				i.setUpAmount(-num);
				if (i.getAmount() == 0) {
					inventory.remove(i.getIndex());
				}
				num = gap;
			} else {
				break;
			}
		} while (num < 0);
	}
	
	// Index로 아이템 제거
	public void removeItemByIndex(int index, int num) {
		GameData.InventoryItem i = findItemByIndex(index);
		if (i != null) {
			i.setUpAmount(-num);
			if (i.getAmount() == 0) {
				inventory.remove(i.getIndex());
			}
		}
	}
	
	// 비어있는 인덱스를 획득
	public int getEmptyIndex() {
		for (int i = 0; i < 35; i++) {
			if (!inventory.containsKey(i))
				return i;
		}
		
		return -1;
	}
	
	// 가지고 있는 아이템 총량을 획득
	public int getItemTotalAmount(int no) {
		int num = 0;
		for (GameData.InventoryItem item : this.inventory.values()) {
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
		for (GameData.InventoryItem item : this.inventory.values()) {
			if (item.getItemNo() == no)
				return item;
		}
		
		return null;
	}

	public void moveUp() {
		this.direction = GameData.Direction.UP;
		if (Handler.getMap().get(this.map).isPassable(this.x, this.y - 1)) {
			this.y -= 1;
			Handler.getMap().get(this.map).sendMessage(Packet.moveCharacter(0, this.no, this.x, this.y, this.direction));
		} else {
			Handler.getMap().get(this.map).sendMessage(Packet.userRefresh(this));
		}
	}
	
	public void moveDown() {
		this.direction = GameData.Direction.DOWN;
		if (Handler.getMap().get(this.map).isPassable(this.x, this.y + 1)) {
			this.y += 1;
			Handler.getMap().get(this.map).sendMessage(Packet.moveCharacter(0, this.no, this.x, this.y, this.direction));
		} else {
			Handler.getMap().get(this.map).sendMessage(Packet.userRefresh(this));
		}
	}
	
	public void moveLeft() {
		this.direction = GameData.Direction.LEFT;
		if (Handler.getMap().get(this.map).isPassable(this.x - 1, this.y)) {
			this.x -= 1;
			Handler.getMap().get(this.map).sendMessage(Packet.moveCharacter(0, this.no, this.x, this.y, this.direction));
		} else {
			Handler.getMap().get(this.map).sendMessage(Packet.userRefresh(this));
		}
	}
	
	public void moveRight() {
		this.direction = GameData.Direction.RIGHT;
		if (Handler.getMap().get(this.map).isPassable(this.x + 1, this.y)) {
			this.x += 1;
			Handler.getMap().get(this.map).sendMessage(Packet.moveCharacter(0, this.no, this.x, this.y, this.direction));
		} else {
			Handler.getMap().get(this.map).sendMessage(Packet.userRefresh(this));
		}
	}
	
}
