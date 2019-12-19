package game;

import database.Type;
import packet.Packet;

import java.util.Random;

public class Character {
    protected int mNo;
    protected String mName;
    protected String mImage;
    protected int mHp;
    protected int mMaxHp;
    protected int mMp;
    protected int mMaxMp;
    protected int mLevel;
    protected int mExp;
    protected int mGold;
    protected int mMap;
    protected int mSeed;
    protected int mX;
    protected int mY;
    protected int mDirection;
    protected int mMoveSpeed;
    protected int mTeam;
    protected int mCharacterType;
    protected int mDamage;
    protected int mMagicDamage;
    protected int mDefense;
    protected int mMagicDefense;
    protected Random mRandom;

    public int getNo() {
        return mNo;
    }

    public String getName() {
        return mName;
    }

    public String getImage() {
        return mImage;
    }

    public int getHp() {
        return mHp;
    }

    public int getMaxHp() {
        return mMaxHp;
    }

    public int getMp() {
        return mMp;
    }

    public int getMaxMp() {
        return mMaxMp;
    }

    public int getLevel() {
        return mLevel;
    }

    public int getExp() {
        return mExp;
    }

    public int getGold() {
        return mGold;
    }

    public int getMap() {
        return mMap;
    }

    public int getSeed() {
        return mSeed;
    }

    public int getX() {
        return mX;
    }

    public int getY() {
        return mY;
    }

    public int getDirection() {
        return mDirection;
    }

    public int getMoveSpeed() {
        return mMoveSpeed;
    }

    public int getTeam() {
        return mTeam;
    }

    public int getCharacterType() {
        return mCharacterType;
    }

    public int getDamage() {
        return mDamage;
    }

    public int getMagicDamage() {
        return mMagicDamage;
    }

    public int getDefense() {
        return mDefense;
    }

    public int getMagicDefense() {
        return mMagicDefense;
    }

    public Random getRandom() {
        return mRandom;
    }

    protected void displayDamage(int value, boolean cri) {
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.damageCharacter(mCharacterType, mNo, value, cri));
    }

    // 애니메이션 재생
    protected void animation(int ani) {
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.animationCharacter(mCharacterType, mNo, ani));
    }

    // 위를 바라봄
    protected void turnUp() {
        if (mDirection == Type.Direction.UP) {
            return;
        }
        Field gameField = Map.getMap(mMap).getField(mSeed);
        mDirection = Type.Direction.UP;
        gameField.sendToAll(Packet.turnCharacter(mCharacterType, mNo, mDirection));
    }

    // 아래를 바라봄
    protected void turnDown() {
        if (mDirection == Type.Direction.DOWN) {
            return;
        }
        Field gameField = Map.getMap(mMap).getField(mSeed);
        mDirection = Type.Direction.DOWN;
        gameField.sendToAll(Packet.turnCharacter(mCharacterType, mNo, mDirection));
    }

    // 왼쪽을 바라봄
    protected void turnLeft() {
        if (mDirection == Type.Direction.LEFT) {
            return;
        }
        Field gameField = Map.getMap(mMap).getField(mSeed);
        mDirection = Type.Direction.LEFT;
        gameField.sendToAll(Packet.turnCharacter(mCharacterType, mNo, mDirection));
    }

    // 오른쪽을 바라봄
    protected void turnRight() {
        if (mDirection == Type.Direction.RIGHT) {
            return;
        }
        Field gameField = Map.getMap(mMap).getField(mSeed);
        mDirection = Type.Direction.RIGHT;
        gameField.sendToAll(Packet.turnCharacter(mCharacterType, mNo, mDirection));
    }

    // 위로 이동
    protected boolean moveUp() {
        Field gameField = Map.getMap(mMap).getField(mSeed);
        if (gameField.isPassable(this, mX, mY - 1)) {
            mDirection = Type.Direction.UP;
            mY -= 1;
            gameField.sendToAll(Packet.moveCharacter(mCharacterType, mNo, mX, mY, mDirection));
            return true;
        }
        return false;
    }

    // 아래로 이동
    protected boolean moveDown() {
        Field gameField = Map.getMap(mMap).getField(mSeed);
        if (gameField.isPassable(this, mX, mY + 1)) {
            mDirection = Type.Direction.DOWN;
            mY += 1;
            gameField.sendToAll(Packet.moveCharacter(mCharacterType, mNo, mX, mY, mDirection));
            return true;
        }
        return false;
    }

    // 왼쪽으로 이동
    protected boolean moveLeft() {
        Field gameField = Map.getMap(mMap).getField(mSeed);
        if (gameField.isPassable(this, mX - 1, mY)) {
            mDirection = Type.Direction.LEFT;
            mX -= 1;
            gameField.sendToAll(Packet.moveCharacter(mCharacterType, mNo, mX, mY, mDirection));
            return true;
        }
        return false;
    }

    // 오른쪽으로 이동
    protected boolean moveRight() {
        Field gameField = Map.getMap(mMap).getField(mSeed);
        if (gameField.isPassable(this, mX + 1, mY)) {
            mDirection = Type.Direction.RIGHT;
            mX += 1;
            gameField.sendToAll(Packet.moveCharacter(mCharacterType, mNo, mX, mY, mDirection));
            return true;
        }
        return false;
    }

    // 점프
    protected void jump(int type, int value) {
        switch (type) {
            case Type.Direction.DOWN:
                mY += value;
                break;

            case Type.Direction.LEFT:
                mX -= value;
                break;

            case Type.Direction.RIGHT:
                mX += value;
                break;

            case Type.Direction.UP:
                mY -= value;
                break;

            default:
        }
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.jumpCharacter(mCharacterType, mNo, mX, mY));
    }
}