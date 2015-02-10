package game;

import database.*;
import packet.Packet;

import java.lang.reflect.Method;

public class Functions {
    public static Functions.Enemy enemy = new Functions.Enemy();
    public static Functions.Item item = new Functions.Item();
    public static Functions.Skill skill = new Functions.Skill();

    public static Object execute(Object obj, String methodName, Object[] objList) {
        Method[] methods = obj.getClass().getMethods();

        for (Method m : methods) {
            if (m.getName().equals(methodName)) {
                try {
                    if (m.getReturnType().getName().equals("void"))
                        m.invoke(obj, objList);
                    else
                        return m.invoke(obj, objList);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    public static class Enemy {
        public void test(game.Enemy enemy) {
            if (enemy.getTarget().getClass().getName().equals("game.User")) {
                User u = (User) enemy.getTarget();
                u.jump(u.getDirection(), 0);
            }
        }
    }

    public static class Item {
        public void potion(game.User user, database.GameData.Item _item) {
            GameData.ItemData item = GameData.item.get(_item.getNo());
            user.gainHp(item.getHp());
        }
    }

    public static class Skill {
        public void crossCut(game.User user, database.GameData.Skill _skill) {
            game.Field gameField = Map.getMap(user.getMap()).getField(user.getSeed());
            GameData.SkillData skill = GameData.skill.get(_skill.getNo());

            for (game.Enemy enemy : gameField.getAliveEnemies()) {
                enemy.animation(57);
                enemy.loseHp(100);
            }
        }
    }
}
