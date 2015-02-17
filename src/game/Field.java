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
    private int dropItemNo = 0;

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
                    // 범위 내 임의의 위치 설정
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

    // 통행 가능 여부
    public boolean isPassable(Character c, int x, int y) {
        // 통행 불가 타일일 경우 반환
        if (!Map.getMap(mapNo).isPassable(x, y))
            return false;

        // 유저가 있을 경우 반환
        for (User other : users) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        // 에너미가 있을 경우 반환
        for (Enemy other : getAliveEnemies()) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        // NPC가 있을 경우 반환
        for (NPC other : npcs.values()) {
            if (other.equals(c))
                continue;
            if (other.getX() == x && other.getY() == y)
                return false;
        }

        return true;
    }

    // 고립(사방이 통행 불가) 여부
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

    // 맵에 유저 들어옴
    public void addUser(User u) {
        // 캐릭터를 생성하자
        for (User other : users) {
            other.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, u));
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, other));
        }

        // 살아있는 에너미를 보내자
        for (Enemy other : getAliveEnemies())
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.ENEMY, other));

        // 모든 NPC를 보내자
        for (NPC other : npcs.values())
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.NPC, other));

        // 떨어진 아이템을 보내자
        for (DropItem item : dropItems)
            u.getCtx().writeAndFlush(Packet.loadDropItem(item));

        // 떨어진 골드를 보내자
        for (DropGold gold : dropGolds)
            u.getCtx().writeAndFlush(Packet.loadDropGold(gold));

        users.addElement(u);
    }

    // 맵에서 나감
    public void removeUser(User u) {
        // 유저 지우고
        for (User other : users) {
            if (other.equals(u))
                continue;

            other.getCtx().writeAndFlush(Packet.removeCharacter(Type.Character.USER, u.getNo()));
        }

        // 해당 유저를 타겟으로 한 에너미는 새 타겟을 찾자
        for (Enemy enemy : getAliveEnemies())
            if (enemy.getTarget() != null && enemy.getTarget().equals(u))
                enemy.findTarget(u);

        // 유저 목록에서 삭제
        users.removeElement(u);
    }

    // 모든 유저를 반환
    public Vector<User> getUsers() {
        Vector<User> aliveUsers = new Vector<User>();

        for (User user : users)
            aliveUsers.addElement(user);

        return aliveUsers;
    }

    // 살아있는 모든 에너미를 반환
    public Vector<Enemy> getAliveEnemies() {
        Vector<Enemy> aliveEnemies = new Vector<Enemy>();

        for (Enemy enemy : enemies)
            if (enemy.isAlive())
                aliveEnemies.addElement(enemy);

        return aliveEnemies;
    }

    // 아이템 드랍
    public void loadDropItem(int itemNo, int num, int x, int y) {
        DropItem item = new DropItem(dropItemNo, itemNo, num, x, y);
        dropItems.addElement(item);
        dropItemNo++;
        sendToAll(Packet.loadDropItem(item));
    }

    // 아이템 드랍 (능력치 유지)
    public void loadDropItem(int itemNo, GameData.Item _item, int x, int y) {
        DropItem item = new DropItem(dropItemNo, itemNo, _item, x, y);
        dropItems.addElement(item);
        dropItemNo++;
        sendToAll(Packet.loadDropItem(item));
    }

    // 골드 드랍
    public void loadDropGold(int amount, int x, int y) {
        DropGold gold = new DropGold(dropItemNo, amount, x, y);
        dropGolds.addElement(gold);
        dropItemNo++;
        sendToAll(Packet.loadDropGold(gold));
    }

    // 아이템 삭제
    public void removeDropItem(DropItem item) {
        if (!dropItems.contains(item))
            return;

        sendToAll(Packet.removeDropItem(item));
        dropItems.removeElement(item);
    }

    // 골드 삭제
    public void removeDropGold(DropGold gold) {
        if (!dropGolds.contains(gold))
            return;

        sendToAll(Packet.removeDropGold(gold));
        dropGolds.removeElement(gold);
    }

    // 아이템 줍기
    public DropItem pickItem(int x, int y) {
        for (DropItem item : dropItems)
            if (item.getX() == x && item.getY() == y)
                return item;

        return null;
    }

    // 골드 줍기
    public DropGold pickGold(int x, int y) {
        for (DropGold gold : dropGolds)
            if (gold.getX() == x && gold.getY() == y)
                return gold;

        return null;
    }

    // 유저가 있다면 업데이트
    public void update() {
        if (users.size() < 1)
            return;

        for (Enemy e : enemies)
            e.update();
    }

    // 모든 유저에게 메시지 전송
    public void sendToAll(JSONObject msg) {
        for (User other : users)
            other.getCtx().writeAndFlush(msg);
    }

    // 다른 모든 유저에게 메시지 전송
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
        private int amount;
        private int x;
        private int y;
        private GameData.Item item;
        private String image;

        public DropItem( int _no, int _itemNo, int _amount, int _x, int _y) {
            no = _no;
            itemNo = _itemNo;
            amount = _amount;
            x = _x;
            y = _y;
            image = GameData.item.get(itemNo).getImage();
            item = new GameData.Item(0, itemNo, amount, 0, GameData.item.get(itemNo).isTradeable() ? 1 : 0);
        }

        public DropItem(int _no, int _itemNo, GameData.Item _item, int _x, int _y) {
            no = _no;
            itemNo = _itemNo;
            amount = 1;
            x = _x;
            y = _y;
            image = GameData.item.get(itemNo).getImage();
            item = _item;
        }

        public int getNo() {
            return no;
        }

        public int getItemNo() {
            return itemNo;
        }

        public int getAmount() {
            return amount;
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

        public GameData.Item getItem() {
            return item;
        }
    }

    public static class DropGold {
        private int no;
        private int x;
        private int y;
        private int amount;

        public DropGold(int _no, int _amount, int _x, int _y) {
            no = _no;
            amount = _amount;
            x = _x;
            y = _y;
        }

        public int getNo() {
            return no;
        }

        public int getX() {
            return x;
        }

        public int getY() {
            return y;
        }

        public int getAmount() {
            return amount;
        }
    }
}
