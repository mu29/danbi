package game;

import database.GameData;
import java.util.logging.Logger;

public class Npc extends Character {
    private String mFunctionName;

    private static Logger logger = Logger.getLogger(Npc.class.getName());

    public Npc(GameData.NPC npc) {
        mNo = npc.getNo();
        mName = npc.getName();
        mImage = npc.getImage();
        mMap = npc.getMap();
        mX = npc.getX();
        mY = npc.getY();
        mDirection = npc.getDirection();
        mFunctionName = npc.getFunction();
    }

    public String getFunctionName() {
        return mFunctionName;
    }
}
