package game;

import packet.Packet;
import java.util.Hashtable;
import java.util.Vector;

public class Party {
    private int mMaster;
    private Vector<Integer> mMembersVector;

    private static Hashtable<Integer, Party> partiesHashtable = new Hashtable<>();

    public Party(int masterNo) {
        mMaster = masterNo;
        mMembersVector = new Vector<>();
        join(mMaster);
    }

    public boolean join(int userNo) {
        if (mMembersVector.contains(userNo)) {
            return false;
        }
        User newMember = User.get(userNo);
        for (Integer member : mMembersVector) {
            User partyMember = User.get(member);
            partyMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));
            newMember.getCtx().writeAndFlush(Packet.setPartyMember(partyMember));
        }
        newMember.getCtx().writeAndFlush(Packet.setPartyMember(newMember));

        newMember.setPartyNo(mMaster);
        mMembersVector.addElement(userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!mMembersVector.contains(userNo)) {
            return false;
        }
        for (Integer member : mMembersVector) {
            User partyMember = User.get(member);
            partyMember.getCtx().writeAndFlush(Packet.removePartyMember(userNo));
        }
        User.get(userNo).setPartyNo(0);
        mMembersVector.removeElement(userNo);
        return true;
    }

    public void breakUp() {
        for (Integer member : mMembersVector) {
            User partyMember = User.get(member);
            partyMember.setPartyNo(0);
        }
        mMembersVector.clear();
        if (partiesHashtable.containsKey(mMaster))
            partiesHashtable.remove(mMaster);
    }

    public Vector<Integer> getMembers() {
        return mMembersVector;
    }

    public static boolean add(int masterNo) {
        if (partiesHashtable.containsKey(masterNo)) {
            return false;
        }
        partiesHashtable.put(masterNo, new Party(masterNo));
        return true;
    }

    public static Party get(int masterNo) {
        if (!partiesHashtable.containsKey(masterNo)) {
            return null;
        }
        return partiesHashtable.get(masterNo);
    }
}
