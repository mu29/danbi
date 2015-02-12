package packet;

public final class CTSHeader {
	public final static int LOGIN = 0;
	public final static int REGISTER = 1;
	public final static int MOVE_CHARACTER = 2;
	public final static int TURN_CHARACTER = 3;
	public final static int REMOVE_EQUIP_ITEM = 4;
	public final static int USE_STAT_POINT = 5;
	public final static int ACTION = 6;
	public final static int USE_ITEM = 7;
	public final static int USE_SKILL = 8;
	public final static int DROP_ITEM = 9;
	public final static int DROP_GOLD = 10;
	public final static int PICK_ITEM = 11;
	
	public final static int OPEN_REGISTER_WINDOW = 100;
	public final static int CHANGE_ITEM_INDEX = 101;
}
