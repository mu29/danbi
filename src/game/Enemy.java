package game;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Enemy {
    private int no;
    private String name;
    private String image;
    private int type;
    private int hp;
    private int maxHp;
    private int mp;
    private int maxMp;
    private int damage;
    private int magicDamage;
    private int defense;
    private int magicDefense;
    private int critical;
    private int avoid;
    private int hit;
    private int moveSpeed;
    private int attackSpeed;
    private int map;
    private int x;
    private int y;
    private int direction;
    private int regen;
    private int level;
    private int exp;
    private int gold;
    private int reward;
    private String function;
    private int frequency;
    private String die;

    public Enemy(ResultSet rs) throws SQLException {
         no = rs.getInt("no");
         name = rs.getString("name");
         image = rs.getString("image");
         type = rs.getInt("type");
         hp = rs.getInt("hp");
         maxHp = rs.getInt("hp");
         mp = rs.getInt("mp");
         maxMp = rs.getInt("mp");
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
         x = rs.getInt("x");
         y = rs.getInt("y");
         direction = rs.getInt("direction");
         regen = rs.getInt("regen");
         level = rs.getInt("level");
         exp = rs.getInt("exp");
         gold = rs.getInt("gold");
         reward = rs.getInt("reward");
         function = rs.getString("function");
         frequency = rs.getInt("frequency");
         die = rs.getString("die");
    }

    public int getNo() {
        return no;
    }

    public String getName() {
        return name;
    }

    public String getImage() {
        return image;
    }

    public int getType() {
        return type;
    }

    public int getHp() {
        return hp;
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

    public int getMp() {
        return mp;
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

    public int getLevel() {
        return level;
    }

    public int getExp() {
        return exp;
    }
}
