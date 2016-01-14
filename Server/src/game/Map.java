package game;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;
import java.util.logging.Logger;

public class Map {
	private int no;
	private String name;
	private int width;
	private int height;
	private int[] data;
	private Hashtable<Integer, Field> fields = new Hashtable<Integer, Field>();

	private static Hashtable<Integer, Map> maps = new Hashtable<Integer, Map>();
	private static Logger logger = Logger.getLogger(Map.class.getName());

	public Map(String fileName) {
		//String[] test = getClass().getResource("").getPath().split("\\!");
		//loadMapData(test[0].substring(6) + fileName);
		loadMapData(fileName);
	}

	// 필드를 넣음
	public boolean addField(int seed) {
		if (fields.containsKey(seed))
			return false;

		fields.put(seed, new Field(no, seed));
		return true;
	}

	// 필드를 얻음
	public Field getField(int seed) {
		return fields.get(seed);
	}

	// 맵을 얻음
	public static Map getMap(int no) {
		return maps.get(no);
	}

	// 모든 맵을 얻음
	public static Hashtable<Integer, Map> getAll() {
		return maps;
	}

	// 모든 맵을 로드
	public static void loadMap(int num) {

		for (int i = 1; i <= num; i++) {
			maps.put(i, new Map("./Map/MAP" + i + ".map"));
		}

		for (Map map : maps.values()) {
			map.addField(0);
		}

		logger.info("맵 로드 완료.");
	}

	// 맵 데이터 로드
	private void loadMapData(String fileName) {
		try {
			FileReader fr = new FileReader(fileName);
			BufferedReader br = new BufferedReader(fr);
			String read = br.readLine();
			String[] readData = read.split(",");
			no = Integer.parseInt(readData[0]);
			name = readData[1];
			width = Integer.parseInt(readData[2]);
			height = Integer.parseInt(readData[3]);
			data = new int[width * height];
			for (int y = 0; y < height; y++) {
				for (int x = 0; x < width; x++) {
					data[width * y + x] = Integer.parseInt(readData[width * y + x + 4]);
				}
			}

			br.close();
			fr.close();
		} catch (IOException e) {
			logger.warning(e.getMessage());
		}
	}

	public boolean isPassable(int x, int y) {
		if (!isValid(x, y))
			return false;

		if (data[width * y + x] == 1)
			return false;

		return true;
	}
	
	private boolean isValid(int x, int y) {
		return x >= 0 && y >= 0 && x < width && y < height;
	}

	public void update() {
		try {
			for (Field field : fields.values())
				field.update();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}