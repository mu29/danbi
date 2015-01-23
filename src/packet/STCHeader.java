package packet;

public final class STCHeader {
	public final static int LOGIN = 0;
	public final static int REGISTER = 1;
	public final static int MOVE_CHARACTER = 2;
	public final static int TURN_CHARACTER = 3;
	public final static int CREATE_CHARACTER = 4;
	public final static int REMOVE_CHARACTER = 5;
	public final static int REFRESH_CHARACTER = 6;
	
	public final static int OPEN_REGISTER_WINDOW = 100;
	public final static int UPDATE_STATUS = 101;
	public final static int SET_INVENTORY = 102;
	public final static int UPDATE_INVENTORY = 103;
}
