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
    private String die;

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
            direction = rs.getInt("direction");
            regen = rs.getInt("regen");
            level = rs.getInt("level");
            exp = rs.getInt("exp");
            gold = rs.getInt("gold");
            reward = rs.getInt("reward");
            function = rs.getString("function");
            frequency = rs.getInt("frequency");
            die = rs.getString("die");

            team = 0;
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
        if (hp + value > getMaxHp())
            value = getMaxHp() - hp;

        hp += value;
    }

    public void loseHp(int value) {
        if (hp - value < 0) {
            // 쥬금
            return;
        }

        gainHp(-value);
    }

    public int getMaxHp() {
        return maxHp;
    }

    public void gainMp(int value) {
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

    public void update() {
        long nowTime = System.currentTimeMillis() / 100;

        if (nowTime < lastMoveTime)
            return;

        lastMoveTime = nowTime + moveSpeed + random.nextInt(moveSpeed) / 2;

        if (target != null) {
            int distance = Math.abs(target.getX() - x) + Math.abs(target.getY() - y);
            if (distance < range)
                moveToTarget();
            else
                target = null;
        } else {
            findTarget();
        }
    }

    // 공속 1당 0.1초
    private void attackTarget() {
        long nowTime = System.currentTimeMillis() / 100;

        if (nowTime < lastAttackTime)
            return;

        lastAttackTime = nowTime + attackSpeed + random.nextInt(attackSpeed) / 2;;
        int new_x = x + (direction == 6 ? 1 : direction == 4 ? -1 : 0);
        int new_y = y + (direction == 2 ? 1 : direction == 8 ? -1 : 0);
        for (User user : Handler.map.get(map).user) {
            if (user.x == new_x && user.y == new_y) {
                Handler.map.get(map).sendToAll(seed, Packet.jumpCharacter(Type.Character.ENEMY, no, x, y));
                int attackDamage = (damage - target.getDefense()) *  (damage - target.getDefense());
                if (target.getClass().getName().equals("game.User")) {
                    User u = (User) target;
                    u.loseHp(attackDamage);
                }
                break;
            }
        }
    }

    private void findTarget() {
        target = null;
        int nearest = range;
        for (Character c : findEnemies()) {
            int distance = Math.abs(c.getX() - x) + Math.abs(c.getY() - y);
            if (distance < nearest) {
                target = c;
                nearest = distance;
            }
        }
    }

    private Vector<Character> findEnemies() {
        Vector<Character> enemies = new Vector<Character>();

        for (User user : Handler.map.get(map).user) {
            if (user.getSeed() == seed && user.getTeam() != team) {
                enemies.addElement(user);
            }
        }
        for (Enemy enemy : Handler.map.get(map).enemy) {
            if (enemy.getSeed() == seed && enemy.getTeam() != team) {
                enemies.addElement(enemy);
            }
        }

        return enemies;
    }

    private void turnToTarget() {
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

        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.UP;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnDown() {
        if (direction == Type.Direction.DOWN)
            return;

        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.DOWN;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnLeft() {
        if (direction == Type.Direction.LEFT)
            return;

        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.LEFT;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void turnRight() {
        if (direction == Type.Direction.RIGHT)
            return;

        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.RIGHT;

        gameMap.sendToAll(seed, Packet.turnCharacter(Type.Character.ENEMY, no, direction));
    }

    private void moveToTarget() {
        if (target == null)
            return;

        int x_gap = Math.abs(x - target.x);
        int y_gap = Math.abs(y - target.y);

        if (x_gap + y_gap == 1) {
            turnToTarget();
            attackTarget();
            return;
        }

        if (Handler.map.get(map).isIsolated(this))
            return;

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
        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.UP;

        if (gameMap.isPassable(this, x, y - 1)) {
            y -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveDown() {
        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.DOWN;

        if (gameMap.isPassable(this, x, y + 1)) {
            y += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveLeft() {
        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.LEFT;

        if (gameMap.isPassable(this, x - 1, y)) {
            x -= 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }

    private void moveRight() {
        Map gameMap = Handler.map.get(map);
        direction = Type.Direction.RIGHT;

        if (gameMap.isPassable(this, x + 1, y)) {
            x += 1;
            gameMap.sendToAll(seed, Packet.moveCharacter(Type.Character.ENEMY, no, x, y, direction));
        } else {
            moveRandom();
        }
    }
}
