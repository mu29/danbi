package network;
import database.Crypto;
import game.Map;
import game.User;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

import org.json.simple.JSONObject;

import packet.CTSHeader;
import packet.Packet;
import database.DataBase;
import database.GameData;

public final class Handler extends ChannelInboundHandlerAdapter {
	public static boolean isRunning = true;
    private static Logger logger = Logger.getLogger(Handler.class.getName());
    
    @Override
	public void channelRead (ChannelHandlerContext ctx, Object msg) {
		JSONObject packet = (JSONObject) msg;
		switch ((int) packet.get("header")) {
	    	case CTSHeader.LOGIN:
	    		login(ctx, packet);
				break;
	    	case CTSHeader.REGISTER:
	    		register(ctx, packet);
				break;
			case CTSHeader.MOVE_CHARACTER:
				User.get(ctx).move((int) packet.get("type"));
				break;
			case CTSHeader.TURN_CHARACTER:
				User.get(ctx).turn((int) packet.get("type"));
				break;
	    	case CTSHeader.REMOVE_EQUIP_ITEM:
				User.get(ctx).equipItem((int) packet.get("type"), 0);
				break;
	    	case CTSHeader.USE_STAT_POINT:
				User.get(ctx).useStatPoint((int) packet.get("type"));
				break;
			case CTSHeader.ACTION:
				User.get(ctx).action();
				break;
			case CTSHeader.USE_ITEM:
				User.get(ctx).useItemByIndex((int) packet.get("index"), (int) packet.get("amount"));
				break;
			case CTSHeader.USE_SKILL:
				User.get(ctx).useSkill((int) packet.get("no"));
				break;
			case CTSHeader.DROP_ITEM:
				User.get(ctx).dropItemByIndex((int) packet.get("index"), (int) packet.get("amount"));
				break;
			case CTSHeader.DROP_GOLD:
				//User.get(ctx).dropItemByIndex((int) packet.get("index"), (int) packet.get("amount"));
				break;
			case CTSHeader.PICK_ITEM:
				User.get(ctx).pickItem();
				break;
	    	case CTSHeader.OPEN_REGISTER_WINDOW:
				ctx.writeAndFlush(Packet.openRegisterWindow());
				break;
	    	case CTSHeader.CHANGE_ITEM_INDEX:
				User.get(ctx).changeItemIndex((int) packet.get("index1"), (int) packet.get("index2"));
				break;
    	}
    }

	// 로그인
    void login(ChannelHandlerContext ctx, JSONObject packet) {
		// 아이디와 비밀번호를 읽어온다
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	
    	if (readID.equals("") || readPass.equals(""))
    		return;

		try {
			// 아이디로 검색
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `id` = '" + readID + "';");

			// 아이디가 있을 경우
	    	if (rs.next()) {
				// 비밀번호를 암호화
				readPass = Crypto.encrypt(readPass);
				// 비밀번호가 같다면
	    		if (readPass.equals(rs.getString("pass"))) {
					// 로그인 처리
					User u = new User(ctx, rs);
	    			User.put(ctx, u);
	    			u.loadData();

	    			ctx.writeAndFlush(Packet.loginMessage(u));
	    	    	Map.getMap(u.getMap()).getField(u.getSeed()).addUser(u);
	    		} else {
	    			ctx.writeAndFlush(Packet.loginMessage(1));
	    		}
	    	} else {
				ctx.writeAndFlush(Packet.loginMessage(1));
	    	}

			rs.close();
		} catch (SQLException e) {
			// SQL Error
			ctx.writeAndFlush(Packet.loginMessage(2));
			logger.warning(e.toString());
		}
    }

	// 회원가입
    void register(ChannelHandlerContext ctx, JSONObject packet) {
		// 가입 정보를 읽어온다
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	String readName = (String) packet.get("name");
    	String readMail = (String) packet.get("mail");
    	int readNo = (int) packet.get("no");
    	
    	if (readID.equals("") || readPass.equals("") || readName.equals("") || readMail.equals(""))
    		return;

		// 직업 리스트에 없는 직업일 경우
		if (!GameData.register.containsKey(readNo))
			return;

		try {
			// 아이디로 검색
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `id` = '" + readID + "';");
	    	if (rs.next()) {
	    		ctx.writeAndFlush(Packet.registerMessage(1));
				rs.close();
	    		return;
	    	}

			// 닉네임으로 검색
	    	rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `name` = '" + readName + "';");
	    	if (rs.next()) {
	    		ctx.writeAndFlush(Packet.registerMessage(2));
				rs.close();
	    		return;
	    	}

			rs.close();
		} catch (SQLException e) {
			// SQL Error
			ctx.writeAndFlush(Packet.loginMessage(3));
			logger.warning(e.toString());
			return;
		}

		// 비밀번호를 암호화
		readPass = Crypto.encrypt(readPass);
		// 직업 정보 불러오기
    	GameData.Register r = GameData.register.get(readNo);
		// 데이터베이스에 넣자
    	DataBase.insertUser(readID, readPass, readName, readMail, r.getImage(), r.getJob(), r.getMap(), r.getX(), r.getY(), r.getLevel());
    	ctx.writeAndFlush(Packet.registerMessage(0));
    }
    
    @Override
	public void channelRegistered (ChannelHandlerContext ctx) {
		logger.info(ctx.channel().remoteAddress().toString() + " 접속");
    }
    
    @Override
	public void channelUnregistered (ChannelHandlerContext ctx) {
		User.remove(ctx);
		logger.info(ctx.channel().remoteAddress().toString() + " 접속 해제");
    }
    
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
		ctx.fireExceptionCaught(cause);
	}
}