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
	private static Statement statement = null;
	private static Logger logger = Logger.getLogger(DataBase.class.getName());
	
	public static void connect(String host, String id, String pass) throws Exception {
		try {
			Class.forName("com.mysql.jdbc.Driver"); 
			connection = DriverManager.getConnection(host, id, pass);
			statement = connection.createStatement();
			logger.info("데이터베이스 연결 완료.");
		} catch (SQLException sqex) {
			logger.warning(sqex.getMessage());
		}
	}
	
	// Select
	public static ResultSet executeQuery(String query) throws SQLException {
		return statement.executeQuery(query);
	}
	
	// Insert
	public static int executeUpdate(String query) throws SQLException {
		return statement.executeUpdate(query);
	}
	
	public static void insertUser(String id, String pass, String name, String mail, String image, int job, 
								int map, int x, int y, int level)  {
		try {
			statement.executeUpdate("INSERT `user` SET " +
									"`id` = '" + id + "', " +
									"`pass` = '" + pass + "', " +
									"`name` = '" + name + "', " +
									"`mail` = '" + mail + "', " +
									"`image` = '" + image + "', " +
									"`job` = '" + job + "', " +
									"`map` = '" + map + "', " +
									"`x` = '" + x + "', " +
									"`y` = '" + y + "', " +
									"`level` = '" + level + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertEquip(int userNo) {
		try {
			statement.executeUpdate("INSERT INTO `equip` (`user_no`) VALUES ('" + userNo + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertItem(GameData.Item item) {
		try {
			statement.executeUpdate("INSERT `item` SET " +
					"`user_no` = '" + item.getUserNo() + "', " +
					"`item_no` = '" + item.getNo() + "', " +
					"`amount` = '" + item.getAmount() + "', " +
					"`index` = '" + item.getIndex() + "', " +
					"`damage` = '" + item.getDamage() + "', " +
					"`magic_damage` = '" + item.getMagicDamage() + "', " +
					"`defense` = '" + item.getDefense() + "', " +
					"`magic_defense` = '" + item.getMagicDefense() + "', " +
					"`str` = '" + item.getStr() + "', " +
					"`dex` = '" + item.getDex() + "', " +
					"`agi` = '" + item.getAgi() + "', " +
					"`hp` = '" + item.getHp() + "', " +
					"`mp` = '" + item.getMp() + "', " +
					"`critical` = '" + item.getCritical() + "', " +
					"`avoid` = '" + item.getAvoid() + "', " +
					"`hit` = '" + item.getHit() + "', " +
					"`reinforce` = '" + item.getReinforce() + "', " +
					"`trade` = '" + (item.isTradeable() ? 1 : 0) + "', " +
					"`equipped` = '" + (item.isEquipped() ? 1 : 0) + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertSkill(GameData.Skill skill) {
		try {
			statement.executeUpdate("INSERT `skill` SET " +
					"`user_no` = '" + skill.getUserNo() + "', " +
					"`skill_no` = '" + skill.getNo() + "', " +
					"`rank` = '" + skill.getRank() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateUser(User user) {
		try {
			statement.executeUpdate("UPDATE `user` SET " +
									"`image` = '" + user.getImage() + "', " +
									"`job` = '" + user.getJob() + "', " +
									"`str` = '" + user.getPureStr() + "', " +
									"`dex` = '" + user.getPureDex() + "', " +
									"`agi` = '" + user.getPureAgi() + "', " +
									"`title` = '" + user.getTitle() + "', " +
									"`hp` = '" + user.getHp() + "', " +
									"`mp` = '" + user.getMp() + "', " +
									"`level` = '" + user.getLevel() + "', " +
									"`exp` = '" + user.getExp() + "', " +
									"`gold` = '" + user.getGold() + "', " +
									"`map` = '" + user.getMap() + "', " +
									"`x` = '" + user.getX() + "', " +
									"`y` = '" + user.getY() + "', " +
									"`direction` = '" + user.getDirection() + "', " +
									"`speed` = '" + user.getMoveSpeed() + "', " +
									"`stat_point` = '" + user.getStatPoint() + "', " +
									"`skill_point` = '" + user.getSkillPoint() + "' " +
									"WHERE `no` = '" + user.getNo() +"';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateEquip(User user) {
		try {
			statement.executeUpdate("UPDATE `equip` SET `weapon` = '" + user.getWeapon() + "', " +
									"`shield` = '" + user.getShield() + "', " +
									"`helmet` = '" + user.getHelmet() + "', " +
									"`armor` = '" + user.getArmor() + "', " +
									"`cape` = '" + user.getCape() + "', " +
									"`shoes` = '" + user.getShoes() + "', " +
									"`accessory` = '" + user.getAccessory() + "' " +
									"WHERE `user_no` = '" + user.getNo() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void deleteItem(int userNo) {
		try {
			statement.executeUpdate("DELETE FROM `item` WHERE `user_no` = '" + userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteSkill(int userNo) {
		try {
			statement.executeUpdate("DELETE FROM `skill` WHERE `user_no` = '" + userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
