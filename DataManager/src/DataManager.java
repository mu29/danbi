import java.io.BufferedWriter;
import java.io.FileWriter;
import java.sql.*;
import java.util.Scanner;

/**
 * Created by 정인중 on 2015-01-14.
 */
public class DataManager {

    private static Connection connection = null;
    private static Statement statement = null;

    public static void main(String[] args) {
        System.out.println("데이터베이스와 연결합니다..");
        try {
            connectMySQL("jdbc:mysql://localhost:3306/danbi?useUnicode=true&characterEncoding=utf8", "root", "projectDanbi");
            System.out.println("데이터베이스 연결 성공");

            Scanner sc = new Scanner(System.in);
            String command;
            ResultSet rs;
            BufferedWriter bw;
            while (!(command = sc.nextLine()).equals("-1")) {
                switch (command) {
                    case "0":
                        // 아이템
                        rs = statement.executeQuery("SELECT * FROM `item`");
                        bw = new BufferedWriter(new FileWriter("./item.txt"));
                        bw.write("0||||0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0");
                        while (rs.next()) {
                            bw.write("\n"
                                    + rs.getInt("no") + "|"
                                    + rs.getString("name") + "|"
                                    + rs.getString("description") + "|"
                                    + rs.getString("image") + "|"
                                    + rs.getInt("job") + "|"
                                    + rs.getInt("limit_level") + "|"
                                    + rs.getInt("type") + "|"
                                    + rs.getInt("price") + "|"
                                    + rs.getInt("damage") + "|"
                                    + rs.getInt("magic_damage") + "|"
                                    + rs.getInt("defense") + "|"
                                    + rs.getInt("magic_defense") + "|"
                                    + rs.getInt("str") + "|"
                                    + rs.getInt("dex") + "|"
                                    + rs.getInt("agi") + "|"
                                    + rs.getInt("hp") + "|"
                                    + rs.getInt("mp") + "|"
                                    + rs.getInt("critical") + "|"
                                    + rs.getInt("avoid") + "|"
                                    + rs.getInt("hit") + "|"
                                    + rs.getInt("delay") + "|"
                                    + rs.getInt("consume") + "|"
                                    + rs.getInt("max_load") + "|"
                                    + rs.getInt("trade"));
                            bw.flush();
                        }
                        bw.close();
                        System.out.println("아이템 데이터 추출 완료");
                        break;
                    case "1":
                        // 스킬
                        rs = statement.executeQuery("SELECT * FROM `skill`");
                        bw = new BufferedWriter(new FileWriter("./skill.txt"));
                        while (rs.next()) {
                            bw.write("\n"
                                    + rs.getInt("no") + "|"
                                    + rs.getString("name") + "|"
                                    + rs.getString("description") + "|"
                                    + rs.getString("type") + "|"
                                    + rs.getInt("job") + "|"
                                    + rs.getInt("delay") + "|"
                                    + rs.getInt("limit_level") + "|"
                                    + rs.getInt("max_rank") + "|"
                                    + rs.getInt("user_animation") + "|"
                                    + rs.getInt("target_animation") + "|"
                                    + rs.getString("image") + "|"
                                    + rs.getString("function"));
                                    bw.flush();
                        }
                        bw.close();
                        System.out.println("스킬 데이터 추출 완료");
                        break;
                }
            }

            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void connectMySQL(String host, String id, String pass) throws Exception {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(host, id, pass);
            statement = connection.createStatement();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return;
    }

    // Select
    public static ResultSet executeQuery(String query) throws SQLException {
        return statement.executeQuery(query);
    }

    public static void insertShop(String name, String category, String desc, String phone, String add, String roadAdd, int x, int y)  {
        try {
            statement.executeUpdate("INSERT INTO `shop` (`name`, `category`, `description`, `telephone`, `address`, `road_address`, `map_x`, `map_y`) VALUES ('" +
                    name + "', '" + category + "', '" + desc + "', '" + phone + "', '" + add + "', '" + roadAdd + "', '" + x + "', '" + y + "');");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
