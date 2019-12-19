package game;

import packet.Packet;
import java.util.Hashtable;
import java.util.Vector;

public class Party {
    private Vector<Integer> mMembers;
    private int mMaster;

    private static Hashtable<Integer, Party> partyList = new Hashtable<>();

    public Party(int masterNo) {
        mMaster = masterNo;
        mMembers = new Vector<>();
        join(mMaster);
    }

    public boolean join(int userNo) {
        if (mMembers.contains(userNo)) {
            return false;
        }
        User newMember = User.get(userNo);
        for (Integer member : mMembers) {
            User partyMember = User.get(member);
            partyMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setPartyMember(partyMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));

        newMember.setPartyNo(mMaster);
        mMembers.addElement(userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!mMembers.contains(userNo)) {
            return false;
        }
        for (Integer member : mMembers) {
            User partyMember = User.get(member);
            partyMember.getCtx().writeAndFlush(Packet.removePartyMember(userNo));
        }
        User.get(userNo).setPartyNo(0);
        mMembers.removeElement(userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : mMembers) {
            User partyMember = User.get(member);
            partyMember.setPartyNo(0);
        }
        mMembers.clear();
        if (partyList.containsKey(mMaster))
            partyList.remove(mMaster);
    }

    public Vector<Integer> getMembers() {
        return mMembers;
    }

    public static boolean add(int masterNo) {
        if (partyList.containsKey(masterNo)) {
            return false;
        }
        partyList.put(masterNo, new Party(masterNo));
        return true;
    }

    public static Party get(int masterNo) {
        if (!partyList.containsKey(masterNo)) {
            return null;
        }
        return partyList.get(masterNo);
    }
}
