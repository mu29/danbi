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
				User.get(ctx).dropGold((int) packet.get("amount"));
				break;

			case CTSHeader.PICK_ITEM:
				User.get(ctx).pickItem();
				break;

			case CTSHeader.CHAT_NORMAL:
				User.get(ctx).chatNormal((String) packet.get("message"));
				break;

			case CTSHeader.CHAT_WHISPER:
				User.get(ctx).chatWhisper((String) packet.get("to"), (String) packet.get("message"));
				break;

			case CTSHeader.CHAT_PARTY:
				User.get(ctx).chatParty((String) packet.get("message"));
				break;

			case CTSHeader.CHAT_GUILD:
				User.get(ctx).chatGuild((String) packet.get("message"));
				break;

			case CTSHeader.CHAT_ALL:
				User.get(ctx).chatAll((String) packet.get("message"));
				break;

            case CTSHeader.CHAT_BALLOON_START:
                User.get(ctx).startShowingBalloon();
                break;

	    	case CTSHeader.OPEN_REGISTER_WINDOW:
				ctx.writeAndFlush(Packet.openRegisterWindow());
				break;

	    	case CTSHeader.CHANGE_ITEM_INDEX:
				User.get(ctx).changeItemIndex((int) packet.get("index1"), (int) packet.get("index2"));
				break;

			case CTSHeader.REQUEST_TRADE:
				User.get(ctx).requestTrade((int) packet.get("partner"));
				break;

			case CTSHeader.RESPONSE_TRADE:
				User.get(ctx).responseTrade((int) packet.get("type"), (int) packet.get("partner"));
				break;

			case CTSHeader.LOAD_TRADE_ITEM:
				User.get(ctx).loadTradeItem((int) packet.get("index"), (int) packet.get("amount"), (int) packet.get("tradeIndex"));
				break;

			case CTSHeader.DROP_TRADE_ITEM:
				User.get(ctx).dropTradeItem((int) packet.get("index"));
				break;

			case CTSHeader.CHANGE_TRADE_GOLD:
				User.get(ctx).changeTradeGold((int) packet.get("amount"));
				break;

			case CTSHeader.FINISH_TRADE:
				User.get(ctx).acceptTrade();
				break;

			case CTSHeader.CANCEL_TRADE:
				User.get(ctx).cancelTrade();
				break;

			case CTSHeader.SELECT_MESSAGE:
				User.get(ctx).updateMessage((int) packet.get("select"));
				break;

			case CTSHeader.CREATE_PARTY:
				User.get(ctx).createParty();
				break;

			case CTSHeader.INVITE_PARTY:
				User.get(ctx).inviteParty((int) packet.get("other"));
				break;

			case CTSHeader.RESPONSE_PARTY:
				User.get(ctx).responseParty((int) packet.get("type"), (int) packet.get("partyNo"));
				break;

			case CTSHeader.QUIT_PARTY:
				User.get(ctx).quitParty();
				break;

			case CTSHeader.KICK_PARTY:
				User.get(ctx).kickParty((int) packet.get("member"));
				break;

			case CTSHeader.BREAK_UP_PARTY:
				User.get(ctx).breakUpParty();
				break;

			case CTSHeader.CREATE_GUILD:
				User.get(ctx).createGuild((String) packet.get("name"));
				break;

			case CTSHeader.INVITE_GUILD:
				User.get(ctx).inviteGuild((int) packet.get("other"));
				break;

			case CTSHeader.RESPONSE_GUILD:
				User.get(ctx).responseGuild((int) packet.get("type"), (int) packet.get("guildNo"));
				break;

			case CTSHeader.QUIT_GUILD:
				User.get(ctx).quitGuild();
				break;

			case CTSHeader.KICK_GUILD:
				User.get(ctx).kickGuild((int) packet.get("member"));
				break;

			case CTSHeader.BREAK_UP_GUILD:
				User.get(ctx).breakUpGuild();
				break;

			case CTSHeader.BUY_SHOP_ITEM:
				User.get(ctx).buyShopItem((int) packet.get("shopNo"), (int) packet.get("index"), (int) packet.get("amount"));
				break;

			case CTSHeader.SET_SLOT:
				User.get(ctx).setSlot((int) packet.get("index"), (int) packet.get("itemidx"));
				break;

			case CTSHeader.DEL_SLOT:
				User.get(ctx).delSlot((int) packet.get("index"));
				break;
    	}
    }

	// 로그인
    private void login(ChannelHandlerContext ctx, JSONObject packet) {
		// 아이디와 비밀번호를 읽어온다
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	
    	if (readID.equals("") || readPass.equals("")) {
			return;
		}
		try {
			// 아이디로 검색
			ResultSet rs = DataBase.executeQuery("SELECT * FROM `user` WHERE `id` = '" + readID + "';");

			// 아이디가 있을 경우
	    	if (rs.next()) {
				// 비밀번호를 암호화
				readPass = Crypto.encrypt(readPass);
				// 비밀번호가 같다면
	    		if (readPass.equals(rs.getString("pass"))) {
					// 먼저 접속중인 계정이 있다면
					if (User.get(rs.getInt("no")) != null)
						return;

					// 로그인 처리
					User u = new User(ctx, rs);
	    			User.put(ctx, u);

	    			ctx.writeAndFlush(Packet.loginMessage(u));
	    	    	Map.getMap(u.getMap()).getField(u.getSeed()).addUser(u);
					u.loadData();
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
    private void register(ChannelHandlerContext ctx, JSONObject packet) {
		// 가입 정보를 읽어온다
    	String readID = (String) packet.get("id");
    	String readPass = (String) packet.get("pass");
    	String readName = (String) packet.get("name");
    	String readMail = (String) packet.get("mail");
    	int readNo = (int) packet.get("no");
    	if (readID.equals("") || readPass.equals("") || readName.equals("") || readMail.equals("")) {
			return;
		}
		// 직업 리스트에 없는 직업일 경우
		if (!GameData.register.containsKey(readNo)) {
			return;
		}
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
		GameData.Job j = GameData.job.get(r.getJob());
		// 데이터베이스에 넣자
    	DataBase.insertUser(readID, readPass, readName, readMail, r.getImage(), r.getJob(), r.getMap(), r.getX(), r.getY(), r.getLevel(), j.getHp());
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