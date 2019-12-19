package game;

import database.DataBase;
import packet.Packet;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Logger;

public class Guild {
    private Vector<Integer> mMembers;
    private int mMaster;
    private String mName;

    private static Hashtable<Integer, Guild> guildList = new Hashtable<>();
    private static Logger logger = Logger.getLogger(Guild.class.getName());

    public Guild(int master, String name) {
        mMaster = master;
        mName = name;
        mMembers = new Vector<>();
        join(master);
        DataBase.insertGuild(master, name);
    }

    public Guild(int master, String name, boolean loading) {
        mMaster = master;
        mName = name;
        mMembers = new Vector<>();
        if (!loading) {
            join(master);
        }
    }

    public Vector<Integer> getMembers() {
        return mMembers;
    }

    public int getMaster() {
        return mMaster;
    }

    public String getName() {
        return mName;
    }

    public static void load() throws SQLException {
        ResultSet rs = DataBase.executeQuery("SELECT * FROM `guild`;");
        while (rs.next()) {
            int masterNo = rs.getInt("master");
            String guildName = rs.getString("guild_name");
            Guild guild = new Guild(masterNo, guildName, true);
            ResultSet memberRs = DataBase.executeQuery("SELECT * FROM `user` WHERE `guild` = '" + masterNo +"';");
            while (memberRs.next()) {
                guild.mMembers.addElement(memberRs.getInt("no"));
            }
            memberRs.close();
            guildList.put(masterNo, guild);
        }
        rs.close();
        logger.info("길드 정보 로드 완료.");
    }

    public static boolean add(int masterNo, String name) {
        if (guildList.containsKey(masterNo)) {
            return false;
        }
        guildList.put(masterNo, new Guild(masterNo, name));
        return true;
    }

    public static Guild get(int masterNo) {
        if (!guildList.containsKey(masterNo)) {
            return null;
        }
        return guildList.get(masterNo);
    }

    public boolean join(int userNo) {
        if (mMembers.contains(userNo)) {
            return false;
        }
        User newMember = User.get(userNo);
        for (Integer member : mMembers) {
            User guildMember = User.get(member);
            guildMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setGuildMember(guildMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));
        newMember.setGuild(mMaster);
        mMembers.addElement(userNo);
        DataBase.insertGuildMember(mMaster, userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!mMembers.contains(userNo)) {
            return false;
        }
        for (Integer member : mMembers) {
            User guildMember = User.get(member);
            if (guildMember != null) {
                guildMember.getCtx().writeAndFlush(Packet.removeGuildMember(userNo));
            }
        }
        User exitUser = User.get(userNo);
        if (exitUser != null) {
            exitUser.setGuild(0);
        } else {
            DataBase.updateGuildExit(userNo);
        }
        mMembers.removeElement(userNo);
        DataBase.deleteGuildMember(mMaster, userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : mMembers) {
            User guildMember = User.get(member);
            guildMember.setGuild(0);
        }
        mMembers.clear();
        if (guildList.containsKey(mMaster)) {
            guildList.remove(mMaster);
        }
    }
}