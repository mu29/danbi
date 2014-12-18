package game;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Logger;

import org.json.simple.JSONObject;

import packet.Packet;

public final class Map {
	
	private String texture;
	private int no;
	private String name;
	private int width;
	private int height;
	private int[] data;
	
	private static Logger logger = Logger.getLogger(Map.class.getName());
	private ArrayList<User> user = new ArrayList<User>();
	//public HashMap<String, NPC> NPC = new HashMap<String, NPC>();
	//public HashMap<String, Enemy> enemy = new HashMap<String, Enemy>();
	//public HashMap<String, DropGold> dropGold = new HashMap<String, DropGold>();
	//public HashMap<String, DropItem> dropItem = new HashMap<String, DropItem>();
	

	public Map(String name) throws IOException {
		FileReader fr = new FileReader(name);
		BufferedReader br = new BufferedReader(fr);
		String read = br.readLine();
		String[] readData = read.split(",");
		texture = readData[0];
		no = Integer.parseInt(readData[1]);
		name = readData[2];
		width = Integer.parseInt(readData[3]);
		height = Integer.parseInt(readData[4]);
		data = new int[width * height];
		for (int y = 0; y < height; y++)
			for (int x = 0; x < width; x++)
				data[width * y + x] = Integer.parseInt(readData[width * y + x + 5]);
		br.close();
		fr.close();
	}
	
	public boolean isValid(int x, int y) {
		int index = this.width * y + x;
		return index < 0 ? false : index >= width * height ? false : true;
	}
	
	public boolean isPassable(int x, int y) {
		if (!isValid(x, y)) {
			return false;
		}
		return data[width * y + x] == 1 ? true : false;
	}
	
	public void addUser(User u) {
		for (User other : user) {
			u.getCtx().writeAndFlush(Packet.createCharacter(other));
		}
		this.user.add(u);
	}
	
	public void removeUser(User u) {
		for (User other : user) {
			other.getCtx().writeAndFlush(Packet.removeCharacter(0, u.getName(), u.getNo()));
		}
		this.user.remove(u);
	}
	
	public ArrayList<User> getUser() {
		return user;
	}
	
	public void sendMessage(JSONObject msg) {
		for (User u : user) {
			u.getCtx().writeAndFlush(msg);
		}
	}
	
}