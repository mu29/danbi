package game;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;
import java.util.logging.Logger;

public class Map {
	private int mNo;
	private String mName;
	private int mWidth;
	private int mHeight;
	private int[] mData;
	private Hashtable<Integer, Field> mFieldsHashtable = new Hashtable<Integer, Field>();

	private static Hashtable<Integer, Map> maps = new Hashtable<Integer, Map>();
	private static Logger logger = Logger.getLogger(Map.class.getName());

	// 생성자
	public Map(String fileName) {
		if (loadMapData(fileName)) {
			maps.put(mNo, this);
		}
	}

	// 필드를 넣음
	public boolean addField(int seed) {
		if (mFieldsHashtable.containsKey(seed)) {
			return false;
		}
		mFieldsHashtable.put(seed, new Field(mNo, seed));
		return true;
	}

	// 필드를 얻음
	public Field getField(int seed) {
		return mFieldsHashtable.get(seed);
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
	public static void loadMap() {
		File curDir = new File("Map");
		File listFiles[] = curDir.listFiles();
		if (listFiles.length > 0) {
			for (File file : listFiles) {
				String name = file.getName();
				String ext = name.substring(name.length() - 4);
				if (file.isFile() && ext.equals(".map")) {
					new Map(file.getPath());
				}
			}
		}
		for (Map map : maps.values()) {
			map.addField(0);
		}
		logger.info("맵 " + maps.size() + "개 로드 완료.");
	}

	// 맵 데이터 로드
	private boolean loadMapData(String fileName) {
		try {
			FileReader fr = new FileReader(fileName);
			BufferedReader br = new BufferedReader(fr);
			String read = br.readLine();
			String[] readData = read.split(",");
			mNo = Integer.parseInt(readData[0]);
			mName = readData[1];
			mWidth = Integer.parseInt(readData[2]);
			mHeight = Integer.parseInt(readData[3]);
			mData = new int[mWidth * mHeight];
			for (int y = 0; y < mHeight; y++) {
				for (int x = 0; x < mWidth; x++) {
					mData[mWidth * y + x] = Integer.parseInt(readData[mWidth * y + x + 4]);
				}
			}
			br.close();
			fr.close();
		} catch (IOException e) {
			logger.warning(e.getMessage());
			return false;
		}
		return true;
	}

	public boolean isPassable(int x, int y) {
		if (!isValid(x, y)) {
			return false;
		}
		if (mData[mWidth * y + x] == 1) {
			return false;
		}
		return true;
	}
	
	private boolean isValid(int x, int y) {
		return x >= 0 && y >= 0 && x < mWidth && y < mHeight;
	}

	public void update() {
		try {
			for (Field field : mFieldsHashtable.values()) {
				field.update();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}