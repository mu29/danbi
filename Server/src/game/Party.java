package game;

import java.util.Hashtable;
import java.util.Vector;

public class Party {
    private Vector<Integer> users;
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
        users = new Vector<>();
        users.addElement(masterNo);
        master = masterNo;
    }

    public boolean join(int userNo) {
        if (users.contains(userNo))
            return false;

        users.addElement(userNo);
        return true;
    }

    public boolean exit(int userNo) {
        if (!users.contains(userNo))
            return false;

        users.removeElement(userNo);
        return true;
    }

    public void breakUp() {
        //
    }

    public Vector<Integer> getMembers() {
        return users;
    }
}
