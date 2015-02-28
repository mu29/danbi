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

    public static void load() throws SQLException {
        ResultSet rs = DataBase.executeQuery("SELECT * FROM `guild`;");
        while (rs.next()) {
            int masterNo = rs.getInt("master");
            String guildName = rs.getString("name");
            Guild guild = new Guild(masterNo, guildName, true);

            ResultSet memberRs = DataBase.executeQuery("SELECT * FROM `user` WHERE `guild` = '" + masterNo +"';");
            while (memberRs.next())
                guild.members.addElement(rs.getInt("no"));
            memberRs.close();

            guildList.put(masterNo, guild);
        }
        rs.close();
        logger.info("길드 정보 로드 완료.");
    }

    public static boolean add(int masterNo, String name) {
        if (guildList.containsKey(masterNo))
            return false;

        guildList.put(masterNo, new Guild(masterNo, name));
        return true;
    }

    public static Guild get(int masterNo) {
        if (!guildList.containsKey(masterNo))
            return null;

        return guildList.get(masterNo);
    }

    public Guild(int _master, String _name) {
        master = _master;
        name = _name;
        members = new Vector<>();
        join(master);
    }

    public Guild(int _master, String _name, boolean loading) {
        master = _master;
        name = _name;
        members = new Vector<>();
        if (!loading)
            join(master);
    }

    public boolean join(int userNo) {
        if (members.contains(userNo))
            return false;

        User newMember = User.get(userNo);
        for (Integer member : members) {
            User guildMember = User.get(member);

            guildMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setGuildMember(guildMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setGuildMember(newMember));

        newMember.setGuild(master);
        members.addElement(userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!members.contains(userNo))
            return false;

        for (Integer member : members) {
            User guildMember = User.get(member);

            guildMember.getCtx().writeAndFlush(Packet.removeGuildMember(userNo));
        }

        User.get(userNo).setGuild(0);
        members.removeElement(userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : members) {
            User guildMember = User.get(member);

            guildMember.setGuild(0);
        }
        members.clear();
        if (guildList.containsKey(master))
            guildList.remove(master);
    }

    public Vector<Integer> getMembers() {
        return members;
    }
}