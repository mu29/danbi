package packet;

public final class STCHeader {
	public final static int LOGIN = 0;
	public final static int REGISTER = 1;
	public final static int MOVE_CHARACTER = 2;
	public final static int TURN_CHARACTER = 3;
	public final static int CREATE_CHARACTER = 4;
	public final static int REMOVE_CHARACTER = 5;
	public final static int REFRESH_CHARACTER = 6;
	public final static int JUMP_CHARACTER = 7;
	public final static int ANIMATION_CHARACTER = 8;
	public final static int MOTION_CHARACTER = 9;
	public final static int UPDATE_CHARACTER = 10;
	public final static int DAMAGE_CHARACTER = 11;
	public final static int LOAD_DROP_ITEM = 12;
	public final static int LOAD_DROP_GOLD = 13;
	public final static int REMOVE_DROP_ITEM = 14;
	public final static int REMOVE_DROP_GOLD = 15;
	public final static int NOTIFY = 16;
	public final static int MOVE_MAP = 17;
	public final static int CHAT = 18;
	public final static int CHAT_BALLOON_END = 19;
	public final static int PLAY_MUSIC = 20;
	
	public final static int OPEN_REGISTER_WINDOW = 100;
	public final static int UPDATE_STATUS = 101;
	public final static int SET_ITEM = 102;
	public final static int UPDATE_ITEM = 103;
	public final static int SET_SKILL = 104;
	public final static int UPDATE_SKILL = 105;
	public final static int REQUEST_TRADE = 106;
	public final static int OPEN_TRADE_WINDOW = 107;
	public final static int LOAD_TRADE_ITEM = 108;
	public final static int DROP_TRADE_ITEM = 109;
	public final static int CHANGE_TRADE_GOLD = 110;
	public final static int FINISH_TRADE = 111;
	public final static int CANCEL_TRADE = 112;
	public final static int OPEN_MESSAGE_WINDOW = 113;
	public final static int CLOSE_MESSAGE_WINDOW = 114;
	public final static int SET_SHOP_ITEM = 115;
	public final static int SET_PARTY  = 116;
	public final static int INVITE_PARTY = 117;
	public final static int SET_PARTY_MEMBER = 118;
	public final static int REMOVE_PARTY_MEMBER = 119;
	public final static int CREATE_GUILD = 120;
	public final static int SET_GUILD = 121;
	public final static int INVITE_GUILD = 122;
	public final static int SET_GUILD_MEMBER = 123;
	public final static int REMOVE_GUILD_MEMBER = 124;
	public final static int OPEN_SHOP_WINDOW = 125;

	public final static int SET_SLOT = 200;
	public final static int SET_COOLTIME = 201;
}