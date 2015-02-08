package game;

import database.Type;
import packet.Packet;

public class Character {
    protected int no;
    protected String name;
    protected String image;
    protected int hp;
    protected int maxHp;
    protected int mp;
    protected int maxMp;
    protected int level;
    protected int exp;
    protected int gold;
    protected int map;
    protected int seed;
    protected int x;
    protected int y;
    protected int direction;
    protected int moveSpeed;
    protected int team;
    protected int characterType;

    public int getNo() {
        return no;
    }

    public String getName() {
        return name;
    }

    public String getImage() {
        return image;
    }

    public int getHp() {
        return hp;
    }

    public int getMaxHp() {
        return maxHp;
    }

    public int getMp() {
        return mp;
    }

    public int getMaxMp() {
        return maxMp;
    }

    public int getLevel() {
        return level;
    }

    public int getExp() {
        return exp;
    }

    public int getGold() {
        return gold;
    }

    public int getMap() {
        return map;
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

    public int getDirection() {
        return direction;
    }

    public int getMoveSpeed() {
        return moveSpeed;
    }

    public int getTeam() {
        return team;
    }

    public int getDamage() {
        return 0;
    }

    public int getMagicDamage() {
        return 0;
    }

    public int getDefense() {
        return 0;
    }

    public int getMagicDefense() {
        return 0;
    }

    // 애니메이션 재생
    protected void animation(int ani) {
        Map.get(map).sendToAll(seed, Packet.animationCharacter(characterType, no, ani));
    }

    // 위를 바라봄
    protected void turnUp() {
        if (direction == Type.Direction.UP)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.UP;

        gameMap.sendToAll(seed, Packet.turnCharacter(characterType, no, direction));
    }

    // 아래를 바라봄
    protected void turnDown() {
        if (direction == Type.Direction.DOWN)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.DOWN;

        gameMap.sendToAll(seed, Packet.turnCharacter(characterType, no, direction));
    }

    // 왼쪽을 바라봄
    protected void turnLeft() {
        if (direction == Type.Direction.LEFT)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.LEFT;

        gameMap.sendToAll(seed, Packet.turnCharacter(characterType, no, direction));
    }

    // 오른쪽을 바라봄
    protected void turnRight() {
        if (direction == Type.Direction.RIGHT)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.RIGHT;

        gameMap.sendToAll(seed, Packet.turnCharacter(characterType, no, direction));
    }

    // 위로 이동
    protected boolean moveUp() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x, y - 1)) {
            direction = Type.Direction.UP;
            y -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(characterType, no, x, y, direction));
            return true;
        }

        return false;
    }

    // 아래로 이동
    protected boolean moveDown() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x, y + 1)) {
            direction = Type.Direction.DOWN;
            y += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(characterType, no, x, y, direction));
            return true;
        }

        return false;
    }

    // 왼쪽으로 이동
    protected boolean moveLeft() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x - 1, y)) {
            direction = Type.Direction.LEFT;
            x -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(characterType, no, x, y, direction));
            return true;
        }

        return false;
    }

    // 오른쪽으로 이동
    protected boolean moveRight() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x + 1, y)) {
            direction = Type.Direction.RIGHT;
            x += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(characterType, no, x, y, direction));
            return true;
        }

        return false;
    }

    // 점프
    protected void jump(int type, int value) {
        switch (type) {
            case Type.Direction.DOWN:
                y += value;
                break;
            case Type.Direction.LEFT:
                x -= value;
                break;
            case Type.Direction.RIGHT:
                x += value;
                break;
            case Type.Direction.UP:
                y -= value;
                break;
        }
        Map.get(map).sendToAll(seed, Packet.jumpCharacter(characterType, no, x, y));
    }
}
