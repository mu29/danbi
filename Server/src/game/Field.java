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
    private int mMapNo;
    private int mSeed;
    private Random mRandom;
    private int mDropItemNo = 0;

    private Vector<User> mUsers = new Vector<>();
    private Vector<Enemy> mEnemies = new Vector<>();
    private Hashtable<Integer, Npc> mNpcs = new Hashtable<>();
    private Vector<GameData.Portal> mPortals = new Vector<>();
    private Vector<DropItem> mDropItems = new Vector<>();
    private Vector<DropGold> mDropGolds = new Vector<>();

    private static Logger logger = Logger.getLogger(Field.class.getName());

    public Field(int mapNo, int seed) {
        mMapNo = mapNo;
        mSeed = seed;
        mRandom = new Random();
        loadTroops();
        loadNPCs();
        loadPortals();
    }

    // Enemy 로드
    private void loadTroops() {
        for (GameData.Troop troop : GameData.troop.values()) {
            if (troop.getMap() == mMapNo) {
                for (int i = 0; i < troop.getNum(); i++) {
                    // 범위 내 임의의 위치 설정
                    int x = troop.getX() - troop.getRange() / 2;
                    int y = troop.getY() - troop.getRange() / 2;
                    do {
                        x += mRandom.nextInt(troop.getRange());
                        y += mRandom.nextInt(troop.getRange());
                    } while (!isPassable(null, x, y));
                    mEnemies.addElement(new Enemy(mSeed, mEnemies.size(), x, y, troop));
                }
            }
        }
        logger.info(mMapNo + "번 맵 (" + mSeed + ") 에너미 등록 완료");
    }

    // NPC 로드
    private void loadNPCs() {
        for (GameData.NPC npc : GameData.npc.values()) {
            if (npc.getMap() == mMapNo) {
                mNpcs.put(npc.getNo(), new Npc(npc));
            }
        }
        logger.info(mMapNo + "번 맵 (" + mSeed + ") NPC 등록 완료");
    }

    // Portal 로드
    private void loadPortals() {
        for (GameData.Portal portal : GameData.portal) {
            if (portal.getMap() == mMapNo) {
                mPortals.addElement(portal);
            }
        }
        logger.info(mMapNo + "번 맵 (" + mSeed + ") 포탈 등록 완료");
    }

    // 통행 가능 여부
    public boolean isPassable(Character c, int x, int y) {
        // 통행 불가 타일일 경우 반환
        if (!Map.getMap(mMapNo).isPassable(x, y)) {
            return false;
        }
        // 유저가 있을 경우 반환
        for (User other : mUsers) {
            if (other.equals(c)) {
                continue;
            }
            if (other.getX() == x && other.getY() == y) {
                return false;
            }
        }
        // 에너미가 있을 경우 반환
        for (Enemy other : getAliveEnemies()) {
            if (other.equals(c)) {
                continue;
            }
            if (other.getX() == x && other.getY() == y) {
                return false;
            }
        }
        // NPC가 있을 경우 반환
        for (Npc other : mNpcs.values()) {
            if (other.equals(c)) {
                continue;
            }
            if (other.getX() == x && other.getY() == y) {
                return false;
            }
        }
        return true;
    }

    // 고립(사방이 통행 불가) 여부
    public boolean isIsolated(Character c) {
        int blocked = 0;
        for (int i = 0; i < 4; i++) {
            int x = c.getX() + (i == 0 ? -1 : i == 2 ? + 1 : 0);
            int y = c.getY() + (i == 1 ? -1 : i == 3 ? + 1 : 0);
            if (!Map.getMap(mMapNo).isPassable(x, y)) {
                blocked++;
            }
            for (User other : mUsers) {
                if (other.getX() == x && other.getY() == y) {
                    blocked++;
                }
            }
            for (Enemy other : mEnemies) {
                if (other.getX() == x && other.getY() == y) {
                    blocked++;
                }
            }
            for (Npc other : mNpcs.values()) {
                if (other.getX() == x && other.getY() == y) {
                    blocked++;
                }
            }
        }
        return blocked >= 4;
    }

    // 맵에 유저 들어옴
    public void addUser(User u) {
        // 맵 이동 패킷
        u.getCtx().writeAndFlush(Packet.moveMap(u));
        // 캐릭터를 생성하자
        for (User other : mUsers) {
            other.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, u));
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.USER, other));
        }
        // 살아있는 에너미를 보내자
        for (Enemy other : getAliveEnemies()) {
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.ENEMY, other));
        }
        // 모든 NPC를 보내자
        for (Npc other : mNpcs.values()) {
            u.getCtx().writeAndFlush(Packet.createCharacter(Type.Character.NPC, other));
        }
        // 떨어진 아이템을 보내자
        for (DropItem item : mDropItems) {
            u.getCtx().writeAndFlush(Packet.loadDropItem(item));
        }
        // 떨어진 골드를 보내자
        for (DropGold gold : mDropGolds) {
            u.getCtx().writeAndFlush(Packet.loadDropGold(gold));
        }
        mUsers.addElement(u);
    }

    // 맵에서 나감
    public void removeUser(User u) {
        // 유저 지우고
        for (User other : mUsers) {
            if (other.equals(u)) {
                continue;
            }
            other.getCtx().writeAndFlush(Packet.removeCharacter(Type.Character.USER, u.getNo()));
        }
        // 해당 유저를 타겟으로 한 에너미는 새 타겟을 찾자
        for (Enemy enemy : getAliveEnemies()) {
            if (enemy.getTarget() != null && enemy.getTarget().equals(u)) {
                enemy.findTarget(u);
            }
        }
        // 유저 목록에서 삭제
        mUsers.removeElement(u);
    }

    // 모든 유저를 반환
    public Vector<User> getUsers() {
        Vector<User> aliveUsers = new Vector<User>();
        for (User user : mUsers) {
            aliveUsers.addElement(user);
        }
        return aliveUsers;
    }

    // 모든 NPC를 반환
    public Vector<Npc> getNPCs() {
        Vector<Npc> aliveNpcs = new Vector<Npc>();
        for (Npc npc : mNpcs.values()) {
            aliveNpcs.addElement(npc);
        }
        return aliveNpcs;
    }

    // 살아있는 모든 에너미를 반환
    public Vector<Enemy> getAliveEnemies() {
        Vector<Enemy> aliveEnemies = new Vector<Enemy>();
        for (Enemy enemy : mEnemies) {
            if (enemy.isAlive()) {
                aliveEnemies.addElement(enemy);
            }
        }
        return aliveEnemies;
    }

    // 모든 포탈을 반환
    public Vector<GameData.Portal> getPortals() {
        return mPortals;
    }

    // 아이템 드랍
    public void loadDropItem(int itemNo, int num, int x, int y) {
        DropItem item = new DropItem(mDropItemNo, itemNo, num, x, y);
        mDropItems.addElement(item);
        mDropItemNo++;
        sendToAll(Packet.loadDropItem(item));
    }

    // 아이템 드랍 (능력치 유지)
    public void loadDropItem(int itemNo, GameData.Item _item, int x, int y) {
        DropItem item = new DropItem(mDropItemNo, itemNo, _item, x, y);
        mDropItems.addElement(item);
        mDropItemNo++;
        sendToAll(Packet.loadDropItem(item));
    }

    // 골드 드랍
    public void loadDropGold(int amount, int x, int y) {
        DropGold gold = new DropGold(mDropItemNo, amount, x, y);
        mDropGolds.addElement(gold);
        mDropItemNo++;
        sendToAll(Packet.loadDropGold(gold));
    }

    // 아이템 삭제
    public void removeDropItem(DropItem item) {
        if (!mDropItems.contains(item)) {
            return;
        }
        sendToAll(Packet.removeDropItem(item));
        mDropItems.removeElement(item);
    }

    // 골드 삭제
    public void removeDropGold(DropGold gold) {
        if (!mDropGolds.contains(gold)) {
            return;
        }
        sendToAll(Packet.removeDropGold(gold));
        mDropGolds.removeElement(gold);
    }

    // 아이템 줍기
    public DropItem pickItem(int x, int y) {
        for (DropItem item : mDropItems) {
            if (item.getX() == x && item.getY() == y) {
                return item;
            }
        }
        return null;
    }

    // 골드 줍기
    public DropGold pickGold(int x, int y) {
        for (DropGold gold : mDropGolds) {
            if (gold.getX() == x && gold.getY() == y) {
                return gold;
            }
        }
        return null;
    }

    // 유저가 있다면 업데이트
    public void update() {
        if (mUsers.size() < 1) {
            return;
        }
        for (Enemy e : mEnemies) {
            e.update();
        }
    }

    // 모든 유저에게 메시지 전송
    public void sendToAll(JSONObject msg) {
        for (User other : mUsers) {
            other.getCtx().writeAndFlush(msg);
        }
    }

    // 다른 모든 유저에게 메시지 전송
    public void sendToOthers(User me, JSONObject msg) {
        for (User other : mUsers) {
            if (other.equals(me)) {
                continue;
            }
            other.getCtx().writeAndFlush(msg);
        }
    }

    public static class DropItem {
        private int mNo;
        private int mItemNo;
        private int mAmount;
        private int mX;
        private int mY;
        private GameData.Item mItem;
        private String mImage;

        public DropItem(int no, int itemNo, int amount, int x, int y) {
            mNo = no;
            mItemNo = itemNo;
            mAmount = amount;
            mX = x;
            mY = y;
            mImage = GameData.item.get(mItemNo).getImage();
            mItem = new GameData.Item(0, mItemNo, mAmount, 0, GameData.item.get(mItemNo).isTradeable() ? 1 : 0);
        }

        public DropItem(int no, int itemNo, GameData.Item item, int x, int y) {
            mNo = no;
            mItemNo = itemNo;
            mAmount = 1;
            mX = x;
            mY = y;
            mImage = GameData.item.get(itemNo).getImage();
            mItem = item;
        }

        public int getNo() {
            return mNo;
        }

        public int getItemNo() {
            return mItemNo;
        }

        public int getAmount() {
            return mAmount;
        }

        public int getX() {
            return mX;
        }

        public int getY() {
            return mY;
        }

        public GameData.Item getItem() {
            return mItem;
        }

        public String getImage() {
            return mImage;
        }
    }

    public static class DropGold {
        private int mNo;
        private int mX;
        private int mY;
        private int mAmount;

        public DropGold(int no, int amount, int x, int y) {
            mNo = no;
            mAmount = amount;
            mX = x;
            mY = y;
        }

        public int getNo() {
            return mNo;
        }

        public int getX() {
            return mX;
        }

        public int getY() {
            return mY;
        }

        public int getAmount() {
            return mAmount;
        }
    }
}
