package game;

import database.GameData;
import java.util.logging.Logger;

public class Npc extends Character {

    private String function;
    private static Logger logger = Logger.getLogger(Npc.class.getName());

    public Npc(GameData.NPC npc) {
        no = npc.getNo();
        name = npc.getName();
        image = npc.getImage();
        map = npc.getMap();
        x = npc.getX();
        y = npc.getY();
        direction = npc.getDirection();
        function = npc.getFunction();
    }

    public String getFunction() {
        return function;
    }
}
