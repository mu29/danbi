package game;

import database.GameData;
import java.util.logging.Logger;

public class Npc extends Character {
    private String function;

    private static Logger logger = Logger.getLogger(Npc.class.getName());

    public Npc(GameData.NPC npc) {
        this.no = npc.getNo();
        this.name = npc.getName();
        this.image = npc.getImage();
        this.map = npc.getMap();
        this.x = npc.getX();
        this.y = npc.getY();
        this.direction = npc.getDirection();
        this.function = npc.getFunction();
    }

    public String getFunction() {
        return function;
    }
}
