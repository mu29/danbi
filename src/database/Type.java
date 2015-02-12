package database;

public class Type {
    public static class Character {
        public static final int USER = 0;
        public static final int NPC = 1;
        public static final int ENEMY = 2;
    }

    public static class Enemy {
        public static final int PRACTICE = 0;
        public static final int PACIFISM = 1;
        public static final int CAUTIOUS = 2;
        public static final int PROTECTIVE = 3;
        public static final int AGGRESSIVE = 4;
        public static final int UNBEATABLE = 5;
        public static final int TRAP = 6;
    }

    public static class Direction {
        public static final int DOWN = 2;
        public static final int LEFT = 4;
        public static final int RIGHT = 6;
        public static final int UP = 8;
    }

    public static class Item {
        public static final int WEAPON = 0;
        public static final int SHIELD = 1;
        public static final int HELMET = 2;
        public static final int ARMOR = 3;
        public static final int CAPE = 4;
        public static final int SHOES = 5;
        public static final int ACCESSORY = 6;
        public static final int ITEM = 7;
    }

    public static class Status {
        public static final int TITLE = 0;
        public static final int IMAGE = 1;
        public static final int JOB = 2;
        public static final int STR = 3;
        public static final int DEX = 4;
        public static final int AGI = 5;
        public static final int CRITICAL = 6;
        public static final int AVOID = 7;
        public static final int HIT = 8;
        public static final int STAT_POINT = 9;
        public static final int SKILL_POINT = 10;
        public static final int HP = 11;
        public static final int MAX_HP = 12;
        public static final int MP = 13;
        public static final int MAX_MP = 14;
        public static final int LEVEL = 15;
        public static final int EXP = 16;
        public static final int MAX_EXP = 17;
        public static final int GOLD = 18;
        public static final int WEAPON = 19;
        public static final int SHIELD = 20;
        public static final int HELMET = 21;
        public static final int ARMOR = 22;
        public static final int CAPE = 23;
        public static final int SHOES = 24;
        public static final int ACCESSORY = 25;
    }
}
