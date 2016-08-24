package database;

import game.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

public class DataBase {
	private static Connection connection = null;
	private static Logger logger = Logger.getLogger(DataBase.class.getName());
	
	public static void connect(String host, String id, String pass) throws Exception {
		try {
			Class.forName("com.mysql.jdbc.Driver"); 
			connection = DriverManager.getConnection(host, id, pass);
			logger.info("데이터베이스 연결 완료.");
		} catch (SQLException sqex) {
			logger.warning(sqex.getMessage());
		}
	}
	
	// Select
	public static ResultSet executeQuery(String query) throws SQLException {
		return connection.createStatement().executeQuery(query);//statement.executeQuery(query);
	}
	
	// Insert
	public static int executeUpdate(String query) throws SQLException {
		return connection.createStatement().executeUpdate(query);//statement.executeUpdate(query);
	}
	
	public static void insertUser(String _id, String _pass, String _name, String _mail, String _image, int _job,
								int _map, int _x, int _y, int _level)  {
		try {
			connection.createStatement().executeUpdate("INSERT `user` SET " +
					"`id` = '" + _id + "', " +
					"`pass` = '" + _pass + "', " +
					"`name` = '" + _name + "', " +
					"`mail` = '" + _mail + "', " +
					"`image` = '" + _image + "', " +
					"`job` = '" + _job + "', " +
					"`map` = '" + _map + "', " +
					"`x` = '" + _x + "', " +
					"`y` = '" + _y + "', " +
					"`level` = '" + _level + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertEquip(int _userNo) {
		try {
			connection.createStatement().executeUpdate("INSERT INTO `equip` (`user_no`) VALUES ('" + _userNo + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertItem(GameData.Item _item) {
		try {
			connection.createStatement().executeUpdate("INSERT `item` SET " +
					"`user_no` = '" + _item.getUserNo() + "', " +
					"`item_no` = '" + _item.getNo() + "', " +
					"`amount` = '" + _item.getAmount() + "', " +
					"`index` = '" + _item.getIndex() + "', " +
					"`damage` = '" + _item.getDamage() + "', " +
					"`magic_damage` = '" + _item.getMagicDamage() + "', " +
					"`defense` = '" + _item.getDefense() + "', " +
					"`magic_defense` = '" + _item.getMagicDefense() + "', " +
					"`str` = '" + _item.getStr() + "', " +
					"`dex` = '" + _item.getDex() + "', " +
					"`agi` = '" + _item.getAgi() + "', " +
					"`hp` = '" + _item.getHp() + "', " +
					"`mp` = '" + _item.getMp() + "', " +
					"`critical` = '" + _item.getCritical() + "', " +
					"`avoid` = '" + _item.getAvoid() + "', " +
					"`hit` = '" + _item.getHit() + "', " +
					"`reinforce` = '" + _item.getReinforce() + "', " +
					"`trade` = '" + (_item.isTradeable() ? 1 : 0) + "', " +
					"`equipped` = '" + (_item.isEquipped() ? 1 : 0) + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertSkill(GameData.Skill _skill) {
		try {
			connection.createStatement().executeUpdate("INSERT `skill` SET " +
					"`user_no` = '" + _skill.getUserNo() + "', " +
					"`skill_no` = '" + _skill.getNo() + "', " +
					"`rank` = '" + _skill.getRank() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertGuild(int _masterNo, String _name) {
		try {
			connection.createStatement().executeUpdate("INSERT `guild` SET " +
					"`master` = '" + _masterNo + "', " +
					"`guild_name` = '" + _name + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertGuildMember(int _guildNo, int _userNo) {
		try {
			connection.createStatement().executeUpdate(
					"INSERT INTO `guild_member` (`guild_no`, `user_no`) VALUES ('" + _guildNo + "', '" + _userNo + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void updateUser(User _user) {
		try {
			connection.createStatement().executeUpdate("UPDATE `user` SET " +
					"`title` = '" + _user.getTitle() + "', " +
					"`guild` = '" + _user.getGuild() + "', " +
					"`image` = '" + _user.getImage() + "', " +
					"`job` = '" + _user.getJob() + "', " +
					"`str` = '" + _user.getPureStr() + "', " +
					"`dex` = '" + _user.getPureDex() + "', " +
					"`agi` = '" + _user.getPureAgi() + "', " +
					"`title` = '" + _user.getTitle() + "', " +
					"`hp` = '" + _user.getHp() + "', " +
					"`mp` = '" + _user.getMp() + "', " +
					"`level` = '" + _user.getLevel() + "', " +
					"`exp` = '" + _user.getExp() + "', " +
					"`gold` = '" + _user.getGold() + "', " +
					"`map` = '" + _user.getMap() + "', " +
					"`x` = '" + _user.getX() + "', " +
					"`y` = '" + _user.getY() + "', " +
					"`direction` = '" + _user.getDirection() + "', " +
					"`speed` = '" + _user.getMoveSpeed() + "', " +
					"`stat_point` = '" + _user.getStatPoint() + "', " +
					"`skill_point` = '" + _user.getSkillPoint() + "' " +
					"WHERE `no` = '" + _user.getNo() + "';");

		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void updateGuildExit(int _userNo) {
		try {
			connection.createStatement().executeUpdate("UPDATE `user` SET " +
					"`guild` = '0' WHERE `no` = '" + _userNo + "';");

		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateEquip(User _user) {
		try {
			connection.createStatement().executeUpdate("UPDATE `equip` SET " +
					"`weapon` = '" + _user.getWeapon() + "', " +
					"`shield` = '" + _user.getShield() + "', " +
					"`helmet` = '" + _user.getHelmet() + "', " +
					"`armor` = '" + _user.getArmor() + "', " +
					"`cape` = '" + _user.getCape() + "', " +
					"`shoes` = '" + _user.getShoes() + "', " +
					"`accessory` = '" + _user.getAccessory() + "' " +
					"WHERE `user_no` = '" + _user.getNo() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void deleteItem(int _userNo) {
		try {
			connection.createStatement().executeUpdate("DELETE FROM `item` WHERE `user_no` = '" + _userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteSkill(int _userNo) {
		try {
			connection.createStatement().executeUpdate("DELETE FROM `skill` WHERE `user_no` = '" + _userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteGuild(int _masterNo) {
		try {
			connection.createStatement().executeUpdate("DELETE FROM `guild` WHERE `master` = '" + _masterNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteGuildMember(int _guildNo, int _userNo) {
		try {
			connection.createStatement().executeUpdate(
					"DELETE FROM `guild_member` WHERE `guild_no` = '" + _guildNo + "' AND `user_no` ='" + _userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
