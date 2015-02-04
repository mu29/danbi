package game;

import database.Type;
import network.Handler;
import packet.Packet;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;
import java.util.Vector;
import java.util.logging.Logger;

public class Enemy extends Character {
    private int type;
    private int range;
    private int maxHp;
    private int maxMp;
    private int animation;
    private int damage;
    private int magicDamage;
    private int defense;
    private int magicDefense;
    private int critical;
    private int avoid;
    private int hit;
    private int attackSpeed;
    private int regen;
    private int reward;
    private String function;
    private int frequency;
    private String dieFunction;

    private int originalX;
    private int originalY;

    private boolean isDead;
    private long deadTime;
    private long lastMoveTime;
    private long lastAttackTime;
    private Character target;
    private Random random;

    private static Logger logger = Logger.getLogger(Enemy.class.getName());

    public Enemy(int _no, int _x, int _y, ResultSet rs) {
        try {
            rs.first();
            no = _no;
            name = rs.getString("name");
            image = rs.getString("image");
            type = rs.getInt("type");
            team = rs.getInt("team");
            range = rs.getInt("range");
            hp = rs.getInt("hp");
            maxHp = rs.getInt("hp");
            mp = rs.getInt("mp");
            maxMp = rs.getInt("mp");
            animation = rs.getInt("animation");
            damage = rs.getInt("damage");
            magicDamage = rs.getInt("magic_damage");
            defense = rs.getInt("defense");
            magicDefense = rs.getInt("magic_defense");
            critical = rs.getInt("critical");
            avoid = rs.getInt("avoid");
            hit = rs.getInt("hit");
            moveSpeed = rs.getInt("move_speed");
            attackSpeed = rs.getInt("attack_speed");
            map = rs.getInt("map");
            seed = 0;
            x = _x;
            y = _y;
            originalX = _x;
            originalY = _y;
            direction = rs.getInt("direction");
            regen = rs.getInt("regen");
            level = rs.getInt("level");
            exp = rs.getInt("exp");
            gold = rs.getInt("gold");
            reward = rs.getInt("reward");
            function = rs.getString("function");
            frequency = rs.getInt("frequency");
            dieFunction = rs.getString("die");

            lastMoveTime = 0;
            lastAttackTime = 0;
            target = null;
            random = new Random();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getType() {
        return type;
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

    public void gainHp(int value) {
        // 최대 HP 이상인 경우 보정
        if (hp + value > getMaxHp())
            value = getMaxHp() - hp;

        hp += value;
        Map.get(map).sendToAll(seed, Packet.updateCharacter(Type.Character.ENEMY, no, Type.Status.HP, hp));
    }

    public void loseHp(int value) {
        gainHp(-value);

        if (hp - value < 0) {
            // 죽음
            die();
        }
    }

    public int getMaxHp() {
        return maxHp;
    }

    public void gainMp(int value) {
        // 최대 MP 이상인 경우 보정
        if (mp + value > getMaxMp())
            value = getMaxMp() - mp;

        mp += value;
    }

    public boolean loseMp(int value) {
        if (mp - value < 0)
            return false;

        gainMp(-value);
        return true;
    }

    public int getMaxMp() {
        return maxMp;
    }

    public Character getTarget() {
        return target;
    }

    public boolean isAlive() {
        return !isDead;
    }

    public void update() {
        // 0.1초 단위로 업데이트
        long nowTime = System.currentTimeMillis() / 100;

        // 죽어있다면 아무 행동도 하지 않음
        if (isDead) {
            if (deadTime + regen < nowTime)
                regen();
            return;
        }

        // 이동 가능한 시간인지 판정
        if (nowTime < lastMoveTime)
            return;

        // 이동 속도에 비례하여 다음 이동 시간 설정
        lastMoveTime = nowTime + moveSpeed + random.nextInt(moveSpeed) / 2;

        // 타겟이 있는 경우
        if (target != null) {
            int distance = Math.abs(target.getX() - x) + Math.abs(target.getY() - y);
            // 타겟이 범위 내의 경우
            if (distance < range) {
                // 스킬 사용
                if (frequency > random.nextInt(100))
                    Functions.execute(Functions.enemy, function, new Object[] { this });

                // 에너미 종류에 따라 분기
                switch (type) {
                    case Type.Enemy.PACIFISM:
                        moveRandom(); break;
                    case Type.Enemy.CAUTIOUS:
                        moveAway(); break;
                    case Type.Enemy.PROTECTIVE:
                        if (hp < maxHp)
                            moveToward();
                        else
                            moveRandom();
                        break;
                    case Type.Enemy.AGGRESSIVE:
                        moveToward(); break;
                }
            } else {
                // 타겟이 범위 외의 경우
                target = null;
            }
        } else {
            // 타겟이 없는 경우
            moveRandom();
            findTarget();
        }
    }

    // 에너미 죽음
    private void die() {
        // 데드 플래그 온
        isDead = true;
        // 죽은 시간을 저장
        deadTime = System.currentTimeMillis() / 100;
        Map.get(map).sendToAll(seed, Packet.removeCharacter(Type.Character.ENEMY, name, no));

        // 타겟이 유저인 경우
        if (target.getClass().getName().equals("game.User")) {
            User u = (User) target;
            u.gainExp(exp);
            u.gainGold(gold);
            Functions.execute(Functions.enemy, dieFunction, new Object[]{this});
        }
    }

    // 에너미 리젠
    private void regen() {
        isDead = false;
        hp = maxHp;
        mp = maxMp;
        x = originalX;
        y = originalY;

        Map.get(map).sendToAll(seed, Packet.createCharacter(Type.Character.ENEMY, this));
    }

    // 타겟을 공격
    private void attackTarget() {
        // 공속 1당 0.1초
        long nowTime = System.currentTimeMillis() / 100;

        // 공격 가능한 시간인지 판정
        if (nowTime < lastAttackTime)
            return;

        // 공격 속도에 비례하여 다음 공격 시간 설정
        lastAttackTime = nowTime + attackSpeed + random.nextInt(attackSpeed) / 2;

        // 에너미 종류에 따라 분기
        switch (type) {
            case Type.Enemy.CAUTIOUS:
                distanceAttack(); break;
            case Type.Enemy.PROTECTIVE:
                if (hp < maxHp)
                    meleeAttack();
                break;
            case Type.Enemy.AGGRESSIVE:
                meleeAttack(); break;
        }
    }

    // 근접 공격
    private void meleeAttack() {
        int new_x = x + (direction == 6 ? 1 : direction == 4 ? -1 : 0);
        int new_y = y + (direction == 2 ? 1 : direction == 8 ? -1 : 0);

        if (target.x == new_x && target.y == new_y)
            assault(target);
    }

    // 원거리 공격
    private void distanceAttack() {
        int new_x = x;
        int new_y = y;
        for (int i = 0; i < range; i++) {
            new_x += (direction == 6 ? 1 : direction == 4 ? -1 : 0);
            new_y += (direction == 2 ? 1 : direction == 8 ? -1 : 0);

            if (target.x == new_x && target.y == new_y) {
                assault(target);
                break;
            }
        }
    }

    // 적 공격
    private void assault(Character target) {
        Map.get(map).sendToAll(seed, Packet.jumpCharacter(Type.Character.ENEMY, no, x, y));
        Map.get(map).sendToAll(seed, Packet.animationCharacter(Type.Character.USER, target.getNo(), animation));

        // 실 데미지를 계산
        int attackDamage = (damage - target.getDefense()) *  (damage - target.getDefense());
        if (target.getClass().getName().equals("game.User")) {
            // 타겟이 유저인 경우
            User u = (User) target;
            u.loseHp(attackDamage);
        } else if (target.getClass().getName().equals("game.Enemy")) {
            // 타겟이 에너미인 경우
            Enemy e = (Enemy) target;
            e.loseHp(attackDamage);
        }
    }

    // 가장 가까운 타겟을 찾자
    private void findTarget() {
        target = null;
        // 범위 외의 경우, 타겟은 null
        int nearest = range;
        for (Character c : findEnemies()) {
            // 가장 가까운 타겟을 찾음
            int distance = Math.abs(c.getX() - x) + Math.abs(c.getY() - y);
            if (distance < nearest) {
                target = c;
                nearest = distance;
            }
        }
    }

    // 모든 적을 검색
    private Vector<Character> findEnemies() {
        Vector<Character> enemies = new Vector<Character>();

        // 팀이 다른 경우 적 목록에 넣음
        for (User user : Map.get(map).users) {
            if (user.getSeed() == seed && user.getTeam() != team) {
                enemies.addElement(user);
            }
        }
        for (Enemy enemy : Map.get(map).getAliveEnemies()) {
            if (enemy.getSeed() == seed && enemy.getTeam() != team) {
                enemies.addElement(enemy);
            }
        }

        return enemies;
    }

    // 타겟에게 접근함
    private void moveToward() {
        if (target == null)
            return;

        int x_gap = Math.abs(x - target.x);
        int y_gap = Math.abs(y - target.y);

        // 타겟과 근접한 경우 공격
        if (x_gap + y_gap == 1) {
            turnToward();
            attackTarget();
            return;
        }

        // 사방이 막힌 경우 이동하지 않음
        if (Map.get(map).isIsolated(this))
            return;

        // 타겟을 향해 이동
        if (x_gap > y_gap) {
            if (x > target.x) {
                moveLeft();
            } else {
                moveRight();
            }
        } else {
            if (y > target.y) {
                moveUp();
            } else {
                moveDown();
            }
        }
    }

    // 타겟으로부터 멀어짐
    private void moveAway() {
        if (target == null)
            return;

        int x_gap = Math.abs(x - target.x);
        int y_gap = Math.abs(y - target.y);

        // 사방이 막힌 경우 이동하지 않음
        if (Map.get(map).isIsolated(this))
            return;

        // 타겟을 피해 이동
        if (x_gap > y_gap) {
            if (y > target.y) {
                moveDown();
            } else {
                moveUp();
            }
        } else {
            if (x > target.x) {
                moveRight();
            } else {
                moveLeft();
            }
        }
    }

    // 랜덤하게 이동
    private void moveRandom() {
        int d = random.nextInt(4);
        d = (d + 1) * 2;
        switch (d) {
            case Type.Direction.UP:
                moveUp();
                break;
            case Type.Direction.DOWN:
                moveDown();
                break;
            case Type.Direction.LEFT:
                moveLeft();
                break;
            case Type.Direction.RIGHT:
                moveRight();
                break;
        }
    }

    private void moveUp() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x, y - 1)) {
            direction = Type.Direction.UP;
            y -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveDown() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x, y + 1)) {
            direction = Type.Direction.DOWN;
            y += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveLeft() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x - 1, y)) {
            direction = Type.Direction.LEFT;
            x -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveRight() {
        Map gameMap = Map.get(map);

        if (gameMap.isPassable(this, x + 1, y)) {
            direction = Type.Direction.RIGHT;
            x += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    // 타겟을 바라봄
    private void turnToward() {
        int x_gap = Math.abs(x - target.x);
        int y_gap = Math.abs(y - target.y);

        if (x_gap > y_gap) {
            if (x > target.x) {
                turnLeft();
            } else {
                turnRight();
            }
        } else {
            if (y > target.y) {
                turnUp();
            } else {
                turnDown();
            }
        }
    }

    private void turnUp() {
        if (direction == Type.Direction.UP)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.UP;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnDown() {
        if (direction == Type.Direction.DOWN)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.DOWN;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnLeft() {
        if (direction == Type.Direction.LEFT)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.LEFT;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnRight() {
        if (direction == Type.Direction.RIGHT)
            return;

        Map gameMap = Map.get(map);
        direction = Type.Direction.RIGHT;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }
}
