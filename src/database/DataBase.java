package database;

import game.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

public class DataBase {
	
    static String connectionString = "";
	static Connection connection = null;
	static Statement statement = null;
	static Logger logger = Logger.getLogger(DataBase.class.getName());
	
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
			statement.executeUpdate("INSERT INTO `user` (`id`, `pass`, `name`, `mail`, `image`, `job`, `map`, `x`, `y`, `level`) VALUES ('" + 
									id + "', '" + pass + "', '" + name + "', '" + mail + "', '" + image + "', '" + job + "', '" + 
									map + "', '" + x + "', '" + y + "', '" + level + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void insertEquip(int no) {
		try {
			statement.executeUpdate("INSERT INTO `equip` (`user_no`) VALUES ('" + no + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateUser(User user) {
		try {
			statement.executeUpdate("UPDATE `user` SET `image` = '" + user.getImage() +
									"', `job` = '" + user.getJob() + "', `str` = '" + user.getPureStr() + 
									"', `dex` = '" + user.getPureDex() + "', `agi` = '" + user.getPureAgi() + 
									"', `title` = '" + user.getTitle() + "', `hp` = '" + user.getHp() +
									"', `mp` = '" + user.getMp() + "', `level` = '" + user.getLevel() + 
									"', `exp` = '" + user.getExp() + "', `gold` = '" + user.getGold() + 
									"', `map` = '" + user.getMap() + "', `x` = '" + user.getX() +
									"', `y` = '" + user.getY() + "', `direction` = '" + user.getDirection() + 
									"', `speed` = '" + user.getMoveSpeed() + "', `stat_point` = '" + user.getStatPoint() +
									"', `skill_point` = '" + user.getSkillPoint() + "' WHERE `no` = '" + user.getNo() +"';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateEquip() {
		
	}
	
}
