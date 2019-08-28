package game;

import database.Type;
import packet.Packet;

import java.util.Random;

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
    protected int damage;
    protected int magicDamage;
    protected int defense;
    protected int magicDefense;
    protected Random random;

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

    public int getCharacterType() {
        return characterType;
    }

    public int getDamage() {
        return damage;
    }

    public int getMagicDamage() {
        return magicDamage;
    }

    public int getDefense() {
        return defense;
    }

    public int getMagicDefense() {
        return magicDefense;
    }

    public Random getRandom() {
        return random;
    }

    protected void displayDamage(int value, boolean cri) {
        Map.getMap(this.map).getField(this.seed).sendToAll(Packet.damageCharacter(this.characterType, this.no, value, cri));
    }

    // 애니메이션 재생
    protected void animation(int ani) {
        Map.getMap(this.map).getField(this.seed).sendToAll(Packet.animationCharacter(this.characterType, this.no, ani));
    }

    // 위를 바라봄
    protected void turnUp() {
        if (this.direction == Type.Direction.UP) {
            return;
        }
        Field gameField = Map.getMap(this.map).getField(this.seed);
        this.direction = Type.Direction.UP;
        gameField.sendToAll(Packet.turnCharacter(this.characterType, this.no, this.direction));
    }

    // 아래를 바라봄
    protected void turnDown() {
        if (this.direction == Type.Direction.DOWN) {
            return;
        }
        Field gameField = Map.getMap(this.map).getField(this.seed);
        this.direction = Type.Direction.DOWN;
        gameField.sendToAll(Packet.turnCharacter(this.characterType, this.no, this.direction));
    }

    // 왼쪽을 바라봄
    protected void turnLeft() {
        if (this.direction == Type.Direction.LEFT) {
            return;
        }
        Field gameField = Map.getMap(this.map).getField(this.seed);
        this.direction = Type.Direction.LEFT;
        gameField.sendToAll(Packet.turnCharacter(this.characterType, this.no, this.direction));
    }

    // 오른쪽을 바라봄
    protected void turnRight() {
        if (this.direction == Type.Direction.RIGHT) {
            return;
        }
        Field gameField = Map.getMap(this.map).getField(this.seed);
        this.direction = Type.Direction.RIGHT;
        gameField.sendToAll(Packet.turnCharacter(this.characterType, this.no, this.direction));
    }

    // 위로 이동
    protected boolean moveUp() {
        Field gameField = Map.getMap(this.map).getField(this.seed);
        if (gameField.isPassable(this, this.x, this.y - 1)) {
            this.direction = Type.Direction.UP;
            this.y -= 1;
            gameField.sendToAll(Packet.moveCharacter(this.characterType, this.no, this.x, this.y, this.direction));
            return true;
        }
        return false;
    }

    // 아래로 이동
    protected boolean moveDown() {
        Field gameField = Map.getMap(this.map).getField(this.seed);
        if (gameField.isPassable(this, this.x, this.y + 1)) {
            this.direction = Type.Direction.DOWN;
            this.y += 1;
            gameField.sendToAll(Packet.moveCharacter(this.characterType, this.no, this.x, this.y, this.direction));
            return true;
        }
        return false;
    }

    // 왼쪽으로 이동
    protected boolean moveLeft() {
        Field gameField = Map.getMap(map).getField(seed);
        if (gameField.isPassable(this, this.x - 1, this.y)) {
            this.direction = Type.Direction.LEFT;
            this.x -= 1;
            gameField.sendToAll(Packet.moveCharacter(this.characterType, this.no, this.x, this.y, this.direction));
            return true;
        }
        return false;
    }

    // 오른쪽으로 이동
    protected boolean moveRight() {
        Field gameField = Map.getMap(this.map).getField(this.seed);
        if (gameField.isPassable(this, this.x + 1, this.y)) {
            this.direction = Type.Direction.RIGHT;
            this.x += 1;
            gameField.sendToAll(Packet.moveCharacter(this.characterType, this.no, this.x, this.y, this.direction));
            return true;
        }
        return false;
    }

    // 점프
    protected void jump(int type, int value) {
        switch (type) {
            case Type.Direction.DOWN:
                this.y += value;
                break;

            case Type.Direction.LEFT:
                this.x -= value;
                break;

            case Type.Direction.RIGHT:
                this.x += value;
                break;

            case Type.Direction.UP:
                this.y -= value;
                break;

            default:
        }
        Map.getMap(this.map).getField(this.seed).sendToAll(Packet.jumpCharacter(this.characterType, this.no, this.x, this.y));
    }
}