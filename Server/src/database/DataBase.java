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
	
	public static void insertUser(String id, String pass, String name, String mail, String image, int job,
								int map, int x, int y, int level, int hp)  {
		try {
			connection.createStatement().executeUpdate("INSERT `user` SET " +
					"`id` = '" + id + "', " +
					"`pass` = '" + pass + "', " +
					"`name` = '" + name + "', " +
					"`mail` = '" + mail + "', " +
					"`image` = '" + image + "', " +
					"`job` = '" + job + "', " +
					"`map` = '" + map + "', " +
					"`x` = '" + x + "', " +
					"`y` = '" + y + "', " +
					"`level` = '" + level + "', " +
					"`hp` = '" + hp + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertEquip(int userNo) {
		try {
			connection.createStatement().executeUpdate("INSERT INTO `equip` (`user_no`) VALUES ('" + userNo + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertItem(GameData.Item item) {
		try {
			connection.createStatement().executeUpdate("INSERT `item` SET " +
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
			connection.createStatement().executeUpdate("INSERT `skill` SET " +
					"`user_no` = '" + skill.getUserNo() + "', " +
					"`skill_no` = '" + skill.getNo() + "', " +
					"`rank` = '" + skill.getRank() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertGuild(int masterNo, String guildName) {
		try {
			connection.createStatement().executeUpdate("INSERT `guild` SET " +
					"`master` = '" + masterNo + "', " +
					"`guild_name` = '" + guildName + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void insertGuildMember(int guildNo, int userNo) {
		try {
			connection.createStatement().executeUpdate(
					"INSERT INTO `guild_member` (`guild_no`, `user_no`) VALUES ('" + guildNo + "', '" + userNo + "');");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void updateUser(User user) {
		try {
			connection.createStatement().executeUpdate("UPDATE `user` SET " +
					"`title` = '" + user.getTitle() + "', " +
					"`guild` = '" + user.getGuild() + "', " +
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
					"WHERE `no` = '" + user.getNo() + "';");

		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void updateGuildExit(int userNo) {
		try {
			connection.createStatement().executeUpdate("UPDATE `user` SET " +
					"`guild` = '0' WHERE `no` = '" + userNo + "';");

		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
	
	public static void updateEquip(User user) {
		try {
			connection.createStatement().executeUpdate("UPDATE `equip` SET " +
					"`weapon` = '" + user.getWeapon() + "', " +
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
			connection.createStatement().executeUpdate("DELETE FROM `item` WHERE `user_no` = '" + userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteSkill(int userNo) {
		try {
			connection.createStatement().executeUpdate("DELETE FROM `skill` WHERE `user_no` = '" + userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteGuild(int masterNo) {
		try {
			connection.createStatement().executeUpdate("DELETE FROM `guild` WHERE `master` = '" + masterNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void deleteGuildMember(int guildNo, int userNo) {
		try {
			connection.createStatement().executeUpdate(
					"DELETE FROM `guild_member` WHERE `guild_no` = '" + guildNo + "' AND `user_no` ='" + userNo + "';");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void setSlot(User user, int slotIndex, int index) {
		try {
			ResultSet rs = connection.createStatement().executeQuery("SELECT * FROM `slot` WHERE `no` = '" + user.getNo() + "';");
			if (!rs.next()) {
				connection.createStatement().executeUpdate("INSERT `slot` SET " +
						"`no` = '" + user.getNo() + "';");
				rs.close();
			}
			if (slotIndex < 0 || slotIndex > 9) {
				return;
			}
			for (int i = 0; i < 10; ++i) {
				if (rs.getInt("slot" + i) == index) {
					return;
				}
			}
			String itemType = "slot" + slotIndex;
			connection.createStatement().executeUpdate("UPDATE `slot` SET " +
					"`" + itemType + "` = '" + index + "' " +
					"WHERE `no` = '" + user.getNo() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}

	public static void delSlot(User user, int slotIndex) {
		try {
			ResultSet rs = connection.createStatement().executeQuery("SELECT * FROM `slot` WHERE `no` = '" + user.getNo() + "';");
			if (!rs.next()) {
				connection.createStatement().executeUpdate("INSERT `slot` SET " +
						"`no` = '" + user.getNo() + "';");
				rs.close();
			}
			if (slotIndex < 0 || slotIndex > 9) {
				return;
			}
			String itemType = "slot" + slotIndex;
			connection.createStatement().executeUpdate("UPDATE `slot` SET " +
					"`" + itemType + "` = '" + -1 + "' " +
					"WHERE `no` = '" + user.getNo() + "';");
		} catch (SQLException e) {
			logger.warning(e.toString());
		}
	}
}