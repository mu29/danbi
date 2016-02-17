package setting;

import java.io.IOException;
import java.io.FileInputStream;
import java.util.Properties;

public class Setting {
    public static Properties load() {
        Properties properties = new Properties();
        try {
            properties.load(new FileInputStream("setting.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return properties;
    }
}
