package game;

import database.GameData;
import database.Type;
import org.json.simple.JSONObject;
import packet.Packet;

import java.util.Hashtable;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

public class Field {
    private int mapNo;
    private int seed;
    private Random random;

    private Vector<User> users = new Vector<User>();
    private Vector<Enemy> enemies = new Vector<Enemy>();
    private Hashtable<Integer, NPC> npcs = new Hashtable<Integer, NPC>();
    private Vector<DropItem> dropItems = new Vector<DropItem>();
    private Vector<DropGold> dropGolds = new Vector<DropGold>();

    private static Logger logger = Logger.getLogger(Field.class.getName());

    public Field(int _mapNo, int _seed) {
        mapNo = _mapNo;
        seed = _seed;
        random = new Random();

        loadTroops();
        loadNPCs();
    }

    // Enemy 로드
    private void loadTroops() {
        for (GameData.Troop troop : GameData.troop.values()) {
            if (troop.getMap() == mapNo) {
                for (int i = 0; i < troop.getNum(); i++) {
                    int x = troop.getX() - troop.getRange() / 2;
                    int y = troop.getY() - troop.getRange() / 2;
                    do {
                        x += random.nextInt(troop.getRange());
                        y += random.nextInt(troop.getRange());
                    } while (!isPassable(null, x, y));
                    enemies.addElement(new Enemy(seed, enemies.size(), x, y, troop));
                }
            }
        }
        logger.info(mapNo + "번 맵 (" + seed + ") 에너미 등록 완료");
    }

    // NPC 로드
    private void loadNPCs() {
        for (GameData.NPC npc : GameData.npc.values()) {
            if (npc.getMap() == mapNo) {
                npcs.put(npc.getNo(), new NPC(npc));
            }
        }
        logger.info(mapNo + "번 맵 (" + seed + ") NPC 등록 완료");
    }

    public boolean isPassable(Character c, int x, int y) {
        if (!Map.getMap(mapNo).isPassable(x, y))
            return false;

        for (User other : users) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        for (Enemy other : getAliveEnemies()) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        for (NPC other : npcs.values()) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        return true;
    }

    public boolean isIsolated(Character c) {
        int blocked = 0;
        for (int i = 0; i < 4; i++) {
            int x = c.getX() + (i == 0 ? -1 : i == 2 ? + 1 : 0);
            int y = c.getY() + (i == 1 ? -1 : i == 3 ? + 1 : 0);

            if (!Map.getMap(mapNo).isPassable(x ,y))
                blocked += 1;

            for (User other : users)
                if (other.getX() == x && other.getY() == y)
                    blocked += 1;

            for (Enemy other : enemies)
                if (other.getX() == x && other.getY() == y)
                    blocked += 1;

            for (NPC other : npcs.values())
                if (other.getX() == x && other.getY() == y)
                    blocked += 1;

        }

        return blocked >= 4;
    }

    public void addUser(User u) {
        for (User other : users) {
            other.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, u));
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, other));
        }

        for (Enemy other : getAliveEnemies())
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.ENEMY, other));

        for (NPC other : npcs.values())
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.NPC, other));

        for (DropItem item : dropItems)
            if (item.getSeed() == u.getSeed())
                u.getCtx().writeAndFlush(Packet.loadDropItem(item));

        users.addElement(u);
    }

    public void removeUser(User u) {
        users.removeElement(u);

        for (User other : users)
            other.getCtx().writeAndFlush(Packet.removeCharacter(Type.Character.USER, u.getNo()));

        for (Enemy enemy : getAliveEnemies())
            if (enemy.getTarget().equals(u))
                enemy.findTarget();
    }

    public Vector<User> getUsers() {
        Vector<User> aliveUsers = new Vector<User>();

        for (User user : users)
            aliveUsers.addElement(user);

        return aliveUsers;
    }

    public Vector<Enemy> getAliveEnemies() {
        Vector<Enemy> aliveEnemies = new Vector<Enemy>();

        for (Enemy enemy : enemies)
            if (enemy.isAlive())
                aliveEnemies.addElement(enemy);

        return aliveEnemies;
    }

    public void loadDropItem(int itemNo, int num, int x, int y) {
        DropItem item = new DropItem(seed, dropItems.size(), itemNo, num, x, y);
        dropItems.addElement(item);
        sendToAll(Packet.loadDropItem(item));
    }

    public void update() {
        if (users.size() < 1)
            return;

        for (Enemy e : enemies) {
            e.update();
        }
    }

    public void sendToAll(JSONObject msg) {
        for (User other : users)
            other.getCtx().writeAndFlush(msg);
    }

    public void sendToOthers(User me, JSONObject msg) {
        for (User other : users) {
            if (other.equals(me))
                continue;

            other.getCtx().writeAndFlush(msg);
        }
    }

    public static class DropItem {
        private int no;
        private int itemNo;
        private int num;
        private int seed;
        private int x;
        private int y;
        private String image;

        public DropItem(int _seed, int _no, int _itemNo, int _num, int _x, int _y) {
            seed = _seed;
            no = _no;
            itemNo = _itemNo;
            num = _num;
            x = _x;
            y = _y;
            image = GameData.item.get(itemNo).getImage();
        }

        public int getNo() {
            return no;
        }

        public int getItemNo() {
            return itemNo;
        }

        public int getNum() {
            return num;
        }

        public int getSeed() {
            return seed;
        }

        public int getX() {
            return x;
        }

        public int getY() {
            return y;
        }

        public String getImage() {
            return image;
        }
    }

    public static class DropGold {
        private int amount;

        public DropGold(int _amount) {
            amount = _amount;
        }
    }
}
