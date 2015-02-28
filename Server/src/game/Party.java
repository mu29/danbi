package game;

import packet.Packet;

import java.util.Hashtable;
import java.util.Vector;

public class Party {
    private Vector<Integer> members;
    private int master;

    private static Hashtable<Integer, Party> partyList = new Hashtable<>();

    public static boolean add(int masterNo) {
        if (partyList.containsKey(masterNo))
            return false;

        partyList.put(masterNo, new Party(masterNo));
        return true;
    }

    public static Party get(int masterNo) {
        if (!partyList.containsKey(masterNo))
            return null;

        return partyList.get(masterNo);
    }

    public Party(int masterNo) {
        master = masterNo;
        members = new Vector<>();
        join(master);
    }

    public boolean join(int userNo) {
        if (members.contains(userNo))
            return false;

        User newMember = User.get(userNo);
        for (Integer member : members) {
            User partyMember = User.get(member);

            partyMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setPartyMember(partyMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));

        newMember.setPartyNo(master);
        members.addElement(userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!members.contains(userNo))
            return false;

        for (Integer member : members) {
            User partyMember = User.get(member);

            partyMember.getCtx().writeAndFlush(Packet.removePartyMember(userNo));
        }

        User.get(userNo).setPartyNo(0);
        members.removeElement(userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : members) {
            User partyMember = User.get(member);

            partyMember.setPartyNo(0);
        }
        members.clear();
        if (partyList.containsKey(master))
            partyList.remove(master);
    }

    public Vector<Integer> getMembers() {
        return members;
    }
}
