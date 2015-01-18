package network;
import game.Map;
import game.User;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Logger;

import org.json.simple.JSONObject;

import packet.CTSHeader;
import packet.Packet;
import database.DataBase;
import database.GameData;

public final class Handler extends ChannelInboundHandlerAdapter {

	public static HashMap<ChannelHandlerContext, User>  user = new HashMap<ChannelHandlerContext, User>();
	public static HashMap<Integer, Map> map = new HashMap<Integer, Map>();
    private static Logger logger = Logger.getLogger(Handler.class.getName());
    
    @Override
	public void channelRead (ChannelHandlerContext ctx, Object msg) {
		JSONObject packet = (JSONObject) msg;
		switch ((int) packet.get("header")) {
	    	case CTSHeader.LOGIN:
	    		login(ctx, packet); break;
	    	case CTSHeader.REGISTER:
	    		register(ctx, packet); break;
			case CTSHeader.MOVE_CHARACTER:
				moveUser(ctx, packet); break;
			case CTSHeader.TURN_CHARACTER:
				turnUser(ctx, packet); break;
	    	case CTSHeader.REMOVE_EQUIP_ITEM:
				user.get(ctx).equipItem((int) packet.get("type"), 0); break;
	    	case CTSHeader.USE_STAT_POINT:
				user.get(ctx).useStatPoint((int) packet.get("type")); break;
	    	case CTSHeader.OPEN_REGISTER_WINDOW:
				ctx.writeAndFlush(Packet.openRegisterWindow()); break;
	    	case CTSHeader.CHANGE_ITEM_INDEX:
				changeItemIndex(ctx, packet); break;
    	}
    }

    void login(ChannelHandlerContext ctx, JSONObject packet) {
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	
    	if (readID.equals("") || readPass.equals(""))
    		return;

		try {
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `id` = '" + readID + "';");
 
	    	if (rs.next()) {
	    		if (readPass.equals(rs.getString("pass"))) {
	    			user.put(ctx, new User(ctx,
	    					rs.getInt("no"), 
	    					rs.getString("id"), 
	    					rs.getString("pass"), 
	    					rs.getString("name"),
	    					rs.getInt("title"), 
	    					rs.getString("mail"), 
	    					rs.getString("image"), 
	    					rs.getInt("job"),
	    					rs.getInt("str"), 
	    					rs.getInt("dex"), 
	    					rs.getInt("agi"), 
	    					rs.getInt("stat_point"), 
	    					rs.getInt("skill_point"), 
	    					rs.getInt("hp"), 
	    					rs.getInt("mp"), 
	    					rs.getInt("level"), 
	    					rs.getInt("exp"), 
	    					rs.getInt("gold"), 
	    					rs.getInt("map"), 
	    					rs.getInt("x"), 
	    					rs.getInt("y"), 
	    					rs.getInt("direction"), 
	    					rs.getInt("speed"),
	    					rs.getInt("admin")));
	    			
	    			User u = user.get(ctx);
	    			u.loadData();
	    			
	    			ctx.writeAndFlush(Packet.loginMessage(u));
	    	    	map.get(u.getMap()).sendToOthers(u, Packet.createCharacter(u));
	    	    	map.get(u.getMap()).addUser(u);
	    		} else {
	    			ctx.writeAndFlush(Packet.loginMessage(1));
	    		}
	    	} else {
				ctx.writeAndFlush(Packet.loginMessage(1));
	    	}
		} catch (SQLException e) {
			ctx.writeAndFlush(Packet.loginMessage(2));
			logger.warning(e.toString());
		}
    }
    
    void register(ChannelHandlerContext ctx, JSONObject packet) {
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	String readName = (String) packet.get("name");
    	String readMail = (String) packet.get("mail");
    	int readNo = (int) packet.get("no");
    	
    	if (readID.equals("") || readPass.equals("") || readName.equals("") || readMail.equals(""))
    		return;

		if (!GameData.register.containsKey(readNo))
			return;

		try {
			ResultSet checkID = DataBase.executeQuery("SELECT * FROM `user` WHERE `id` = '" + readID + "';");
	    	if (checkID.next()) {
	    		ctx.writeAndFlush(Packet.registerMessage(1));
	    		return;
	    	}
	    	ResultSet checkName = DataBase.executeQuery("SELECT * FROM `user` WHERE `name` = '" + readName + "';");
	    	if (checkName.next()) {
	    		ctx.writeAndFlush(Packet.registerMessage(2));
	    		return;
	    	}
		} catch (SQLException e) {
			ctx.writeAndFlush(Packet.loginMessage(3));
			logger.warning(e.toString());
			return;
		}
    	GameData.Register r = GameData.register.get(readNo);
    	DataBase.insertUser(readID, readPass, readName, readMail, r.getImage(), r.getJob(), r.getMap(), r.getX(), r.getY(), r.getLevel());
    	ctx.writeAndFlush(Packet.registerMessage(0));
    }

	void moveUser(ChannelHandlerContext ctx, JSONObject packet) {
		switch ((int) packet.get("type")) {
			case 2:
				user.get(ctx).moveDown();
				break;
			case 4:
				user.get(ctx).moveLeft();
				break;
			case 6:
				user.get(ctx).moveRight();
				break;
			case 8:
				user.get(ctx).moveUp();
				break;
		}
	}

	void turnUser(ChannelHandlerContext ctx, JSONObject packet) {
		switch ((int) packet.get("type")) {
			case 2:
				user.get(ctx).turnDown();
				break;
			case 4:
				user.get(ctx).turnLeft();
				break;
			case 6:
				user.get(ctx).turnRight();
				break;
			case 8:
				user.get(ctx).turnUp();
				break;
		}
	}

	void changeItemIndex(ChannelHandlerContext ctx, JSONObject packet) {
		switch ((int) packet.get("type")) {
			case 0:
				// 아이템
				user.get(ctx).changeItemIndex((int) packet.get("index1"), (int) packet.get("index2"));
				break;
		}
	}
    
    public static void loadMap(int num) throws IOException {
    	for (int i = 1; i <= num; i++)
    		map.put(i, new Map("./Map/MAP" + i + ".map"));
    	
		logger.info("맵 로드 완료.");
    }
    
    @Override
	public void channelRegistered (ChannelHandlerContext ctx) {
    	logger.info(ctx.channel().toString() + " Registered.");
    }
    
    @Override
	public void channelUnregistered (ChannelHandlerContext ctx) throws SQLException {
    	if (user.containsKey(ctx)) {
    		DataBase.updateUser(user.get(ctx));
    		user.remove(ctx);
    	}
    	logger.info(ctx.channel().toString() + " Unregistered.");
    }
    
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        ctx.fireExceptionCaught(cause);
    }
    
}