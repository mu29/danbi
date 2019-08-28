package game;

import database.DataBase;
import packet.Packet;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Logger;

public class Guild {
    private Vector<Integer> members;
    private int master;
    private String name;

    private static Hashtable<Integer, Guild> guildList = new Hashtable<>();
    private static Logger logger = Logger.getLogger(Guild.class.getName());

    public Guild(int master, String name) {
        this.master = master;
        this.name = name;
        this.members = new Vector<>();
        join(master);
        DataBase.insertGuild(master, name);
    }

    public Guild(int master, String name, boolean loading) {
        this.master = master;
        this.name = name;
        this.members = new Vector<>();
        if (!loading) {
            join(master);
        }
    }

    public Vector<Integer> getMembers() {
        return members;
    }

    public int getMaster() {
        return master;
    }

    public String getName() {
        return name;
    }

    public static void load() throws SQLException {
        ResultSet rs = DataBase.executeQuery("SELECT * FROM `guild`;");
        while (rs.next()) {
            int masterNo = rs.getInt("master");
            String guildName = rs.getString("guild_name");
            Guild guild = new Guild(masterNo, guildName, true);
            ResultSet memberRs = DataBase.executeQuery("SELECT * FROM `user` WHERE `guild` = '" + masterNo +"';");
            while (memberRs.next()) {
                guild.members.addElement(memberRs.getInt("no"));
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
        if (this.members.contains(userNo)) {
            return false;
        }
        User newMember = User.get(userNo);
        for (Integer member : this.members) {
            User guildMember = User.get(member);
            guildMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setGuildMember(guildMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));
        newMember.setGuild(this.master);
        this.members.addElement(userNo);
        DataBase.insertGuildMember(this.master, userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!this.members.contains(userNo)) {
            return false;
        }
        for (Integer member : this.members) {
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
        this.members.removeElement(userNo);
        DataBase.deleteGuildMember(this.master, userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : this.members) {
            User guildMember = User.get(member);
            guildMember.setGuild(0);
        }
        this.members.clear();
        if (guildList.containsKey(this.master)) {
            guildList.remove(this.master);
        }
    }
}