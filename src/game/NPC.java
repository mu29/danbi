package game;

import database.GameData;

import java.util.logging.Logger;

public class NPC extends Character {

    private String function;
    private static Logger logger = Logger.getLogger(NPC.class.getName());

    public NPC(GameData.NPC npc) {
        no = npc.getNo();
        name = npc.getName();
        image = npc.getImage();
        map = npc.getMap();
        x = npc.getX();
        y = npc.getY();
        direction = npc.getDirection();
        function = npc.getFunction();
    }
}
