package game;

import database.GameData;
import database.Type;
import packet.Packet;

import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

public class Enemy extends Character {
    private int mType;
    private int mRange;
    private int mMaxHp;
    private int mMaxMp;
    private int mAttackAnimation;
    private int mDamage;
    private int mMagicDamage;
    private int mDefense;
    private int mMagicDefense;
    private int mCritical;
    private int mAvoid;
    private int mHit;
    private int mAttackSpeed;
    private int mRegen;
    private int mReward;
    private String mFunction;
    private int mFrequency;
    private String mDieFunction;

    private int mOriginalX;
    private int mOriginalY;

    private boolean mbDead;
    private long mDeadTime;
    private long mLastMoveTime;
    private long mLastAttackTime;
    private Character mTarget;

    private static Logger logger = Logger.getLogger(Enemy.class.getName());

    public Enemy(int seed, int no, int x, int y, GameData.Troop troop) {
        mNo = no;
        mName = troop.getName();
        mImage = troop.getImage();
        mType = troop.getType();
        mTeam = troop.getTeam();
        mRange = troop.getRange();
        mHp = troop.getHp();
        mMaxHp = troop.getHp();
        mMp = troop.getMp();
        mMaxMp = troop.getMp();
        mAttackAnimation = troop.getAttackAnimation();
        mDamage = troop.getDamage();
        mMagicDamage = troop.getMagicDamage();
        mDefense = troop.getDefense();
        mMagicDefense = troop.getMagicDefense();
        mCritical = troop.getCritical();
        mAvoid = troop.getAvoid();
        mHit = troop.getHit();
        mMoveSpeed = troop.getMoveSpeed();
        mAttackSpeed = troop.getAttackSpeed();
        mMap = troop.getMap();
        mSeed = seed;
        mX = x;
        mY = y;
        mOriginalX = x;
        mOriginalY = y;
        mDirection = troop.getDirection();
        mRegen = troop.getRegen();
        mLevel = troop.getLevel();
        mExp = troop.getExp();
        mGold = troop.getGold();
        mReward = troop.getReward();
        mFunction = troop.getSkill();
        mFrequency = troop.getFrequency();
        mDieFunction = troop.getDieFunction();

        mLastMoveTime = 0;
        mLastAttackTime = 0;
        mTarget = null;
        mRandom = new Random();

        mCharacterType = Type.Character.ENEMY;
    }

    public int getType() {
        return mType;
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

    public void gainHp(int value) {
        // 최대 HP 이상인 경우 보정
        if (mHp + value > getMaxHp()) {
            value = getMaxHp() - mHp;
        }
        mHp += value;
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.updateCharacter(mCharacterType, mNo,
                new int[]{ Type.Status.HP }, new Integer[]{ mHp }));
    }

    public void loseHp(int value) {
        gainHp(-value);
        if (mHp - value < 0) {
            // 죽음
            die();
        }
    }

    public int getMaxHp() {
        return mMaxHp;
    }

    public void gainMp(int value) {
        // 최대 MP 이상인 경우 보정
        if (mMp + value > getMaxMp()) {
            value = getMaxMp() - mMp;
        }
        mMp += value;
    }

    public boolean loseMp(int value) {
        if (mMp - value < 0) {
            return false;
        }
        gainMp(-value);
        return true;
    }

    public int getMaxMp() {
        return mMaxMp;
    }

    public Character getTarget() {
        return mTarget;
    }

    public boolean isAlive() {
        return !mbDead;
    }

    public void update() {
        // 0.1초 단위로 업데이트
        long nowTime = System.currentTimeMillis() / 100;
        // 죽어있다면 아무 행동도 하지 않음
        if (mbDead) {
            if (mDeadTime + mRegen < nowTime) {
                regen();
            }
            return;
        }
        // 이동 가능한 시간인지 판정
        if (nowTime < mLastMoveTime) {
            return;
        }
        // 이동 속도에 비례하여 다음 이동 시간 설정
        mLastMoveTime = nowTime + mMoveSpeed + mRandom.nextInt(mMoveSpeed) / 2;
        // 타겟이 있는 경우
        if (mTarget != null) {
            int distance = Math.abs(mTarget.getX() - mX) + Math.abs(mTarget.getY() - mY);
            // 타겟이 범위 내의 경우
            if (distance < mRange) {
                // 스킬 사용
                if (mFrequency > mRandom.nextInt(100)) {
                    Functions.execute(Functions.enemy, mFunction, new Object[]{this});
                }
                // 에너미 종류에 따라 분기
                switch (mType) {
                    case Type.Enemy.PACIFISM:
                        moveRandom();
                        break;

                    case Type.Enemy.CAUTIOUS:
                        moveAway();
                        break;

                    case Type.Enemy.PROTECTIVE:
                        if (mHp < mMaxHp) {
                            moveToward();
                        } else {
                            moveRandom();
                        }
                        break;

                    case Type.Enemy.AGGRESSIVE:
                        moveToward();
                        break;

                    default:
                }
            } else {
                // 타겟이 범위 외의 경우
                mTarget = null;
            }
        } else {
            // 타겟이 없는 경우
            moveRandom();
            findTarget();
        }
    }

    // 에너미 죽음
    private void die() {
        // 타겟이 유저인 경우
        if (mTarget != null && mTarget.getClass().getName().equals("game.User")) {
            User u = (User) mTarget;
            // 파티가 있다면 경험치 분배
            if (u.getPartyNo() > 0) {
                int partyExp = mExp / Party.get(u.getPartyNo()).getMembers().size();
                for (int memberNo : Party.get(u.getPartyNo()).getMembers()) {
                    User member = User.get(memberNo);
                    if (member.getMap() == u.getMap()) {
                        member.gainExp(partyExp);
                    }
                }
            } else {
                u.gainExp(mExp);
            }
            // 골드 드랍
            if (mGold > 0) {
                Map.getMap(mMap).getField(mSeed).loadDropGold(mGold, mX, mY);
            }
            // 보상 목록에 있는 아이템을 드랍
            for (GameData.Reward r : GameData.rewardsVector) {
                if (r.getNo() == mReward && r.getPer() > mRandom.nextInt(10000)) {
                    Map.getMap(mMap).getField(mSeed).loadDropItem(r.getItemNo(), r.getNum(), mX, mY);
                }
            }
            Functions.execute(Functions.enemy, mDieFunction, new Object[]{this});
        }
        // 죽은 시간을 저장
        mDeadTime = System.currentTimeMillis() / 100;
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.removeCharacter(Type.Character.ENEMY, mNo));
        mTarget = null;
        mbDead = true;
    }

    // 에너미 리젠
    private void regen() {
        mbDead = false;
        mHp = mMaxHp;
        mMp = mMaxMp;
        mX = mOriginalX;
        mY = mOriginalY;
        Map.getMap(mMap).getField(mSeed).sendToAll(Packet.createCharacter(Type.Character.ENEMY, this));
    }

    // 타겟을 공격
    private void attackTarget() {
        // 공속 1당 0.1초
        long nowTime = System.currentTimeMillis() / 100;
        // 공격 가능한 시간인지 판정
        if (nowTime < mLastAttackTime) {
            return;
        }
        // 공격 속도에 비례하여 다음 공격 시간 설정
        mLastAttackTime = nowTime + mAttackSpeed + mRandom.nextInt(mAttackSpeed) / 2;
        // 에너미 종류에 따라 분기
        switch (mType) {
            case Type.Enemy.CAUTIOUS:
                distanceAttack();
                break;

            case Type.Enemy.PROTECTIVE:
                if (mHp < mMaxHp) {
                    meleeAttack();
                }
                break;

            case Type.Enemy.AGGRESSIVE:
                meleeAttack();
                break;

            default:
        }
    }

    // 근접 공격
    private void meleeAttack() {
        int new_x = mX + (mDirection == 6 ? 1 : mDirection == 4 ? -1 : 0);
        int new_y = mY + (mDirection == 2 ? 1 : mDirection == 8 ? -1 : 0);
        if (mTarget.mX == new_x && mTarget.mY == new_y) {
            assault(mTarget);
        }
    }

    // 원거리 공격
    private void distanceAttack() {
        int new_x = mX;
        int new_y = mY;
        for (int i = 0; i < mRange; i++) {
            new_x += (mDirection == 6 ? 1 : mDirection == 4 ? -1 : 0);
            new_y += (mDirection == 2 ? 1 : mDirection == 8 ? -1 : 0);
            if (mTarget.mX == new_x && mTarget.mY == new_y) {
                assault(mTarget);
                break;
            }
        }
    }

    // 적 공격
    private void assault(Character target) {
        jump(0, 0);
        target.animation(mAttackAnimation);
        // 실 데미지를 계산
        int attackDamage = mDamage - target.getDefense();
        boolean isFatal = mCritical > mRandom.nextInt(100);
        if (isFatal) {
            attackDamage *= 2;
        }
        if (attackDamage < 0) {
            attackDamage = 0;
        }
        if (target.getClass().getName().equals("game.User")) {
            // 타겟이 유저인 경우
            User u = (User) target;
            u.loseHp(attackDamage);
            u.displayDamage(attackDamage, isFatal);
        } else if (target.getClass().getName().equals("game.Enemy")) {
            // 타겟이 에너미인 경우
            Enemy e = (Enemy) target;
            e.loseHp(attackDamage);
            e.displayDamage(attackDamage, isFatal);
        }
    }

    // 가장 가까운 타겟을 찾자
    public void findTarget() {
        mTarget = null;
        // 범위 외의 경우, 타겟은 null
        int nearest = mRange;
        for (Character c : findEnemies()) {
            // 가장 가까운 타겟을 찾음
            int distance = Math.abs(c.getX() - mX) + Math.abs(c.getY() - mY);
            if (distance < nearest) {
                mTarget = c;
                nearest = distance;
            }
        }
    }

    public void findTarget(Character _target) {
        mTarget = null;
        // 범위 외의 경우, 타겟은 null
        int nearest = mRange;
        for (Character c : findEnemies()) {
            if (c.equals(_target)) {
                continue;
            }
            // 가장 가까운 타겟을 찾음
            int distance = Math.abs(c.getX() - mX) + Math.abs(c.getY() - mY);
            if (distance < nearest) {
                mTarget = c;
                nearest = distance;
            }
        }
    }

    // 모든 적을 검색
    private Vector<Character> findEnemies() {
        Vector<Character> enemiesVector = new Vector<Character>();
        // 팀이 다른 경우 적 목록에 넣음
        for (User user : Map.getMap(mMap).getField(mSeed).getUsers()) {
            if (user.getTeam() != mTeam) {
                enemiesVector.addElement(user);
            }
        }
        for (Enemy enemy : Map.getMap(mMap).getField(mSeed).getAliveEnemies()) {
            if (enemy.getTeam() != mTeam) {
                enemiesVector.addElement(enemy);
            }
        }
        return enemiesVector;
    }

    // 타겟에게 접근함
    private void moveToward() {
        if (mTarget == null) {
            return;
        }
        int x_gap = Math.abs(mX - mTarget.mX);
        int y_gap = Math.abs(mY - mTarget.mY);
        // 타겟과 근접한 경우 공격
        if (x_gap + y_gap == 1) {
            turnToward();
            attackTarget();
            return;
        }
        // 사방이 막힌 경우 이동하지 않음
        if (Map.getMap(mMap).getField(mSeed).isIsolated(this)) {
            return;
        }
        // 타겟을 향해 이동
        if (x_gap > y_gap) {
            if (mX > mTarget.mX) {
                moveLeft();
            } else {
                moveRight();
            }
        } else {
            if (mY > mTarget.mY) {
                moveUp();
            } else {
                moveDown();
            }
        }
    }

    // 타겟으로부터 멀어짐
    private void moveAway() {
        if (mTarget == null) {
            return;
        }
        int x_gap = Math.abs(mX - mTarget.mX);
        int y_gap = Math.abs(mY - mTarget.mY);
        // 사방이 막힌 경우 이동하지 않음
        if (Map.getMap(mMap).getField(mSeed).isIsolated(this)) {
            return;
        }
        // 타겟을 피해 이동
        if (x_gap > y_gap) {
            if (mY > mTarget.mY) {
                moveDown();
            } else {
                moveUp();
            }
        } else {
            if (mX > mTarget.mX) {
                moveRight();
            } else {
                moveLeft();
            }
        }
    }

    // 랜덤하게 이동
    private void moveRandom() {
        int d = mRandom.nextInt(4);
        d = (d + 1) * 2;
        switch (d) {
            case Type.Direction.UP:
                if (!super.moveUp()) {
                    moveUp();
                }
                break;

            case Type.Direction.DOWN:
                if (!super.moveDown()) {
                    moveDown();
                }
                break;

            case Type.Direction.LEFT:
                if (!super.moveLeft()) {
                    moveLeft();
                }
                break;

            case Type.Direction.RIGHT:
                if (!super.moveRight()) {
                    moveRight();
                }
                break;

            default:
        }
    }

    protected boolean moveUp() {
        if (!super.moveUp()) {
            moveRandom();
        }
        return true;
    }

    protected boolean moveDown() {
        if (!super.moveDown()) {
            moveRandom();
        }
        return true;
    }

    protected boolean moveLeft() {
        if (!super.moveLeft()) {
            moveRandom();
        }
        return true;
    }

    protected boolean moveRight() {
        if (!super.moveRight()) {
            moveRandom();
        }
        return true;
    }

    // 타겟을 바라봄
    private void turnToward() {
        int x_gap = Math.abs(mX - mTarget.mX);
        int y_gap = Math.abs(mY - mTarget.mY);
        if (x_gap > y_gap) {
            if (mX > mTarget.mX) {
                turnLeft();
            } else {
                turnRight();
            }
        } else {
            if (mY > mTarget.mY) {
                turnUp();
            } else {
                turnDown();
            }
        }
    }
}