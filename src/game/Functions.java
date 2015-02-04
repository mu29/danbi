package game;

import database.GameData;
import database.Type;
import network.Handler;
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
                u.getCtx().writeAndFlush(Packet.jumpCharacter(Type.Character.USER, u.getNo(), u.getX(), u.getY()));
            }
        }
    }

    public static class Item {
        public void potion(game.User user, database.GameData.Item _item) {
            GameData.ItemData item = GameData.item.get(_item.getItemNo());
            user.gainHp(item.getHp());
        }
    }

    public static class Skill {
        public void crossCut(game.User user, database.GameData.Skill _skill) {
            game.Map gameMap = Map.get(user.getMap());
            for (game.Enemy enemy : gameMap.getAliveEnemies()) {
                enemy.loseHp(100);
                gameMap.sendToAll(user.getSeed(), Packet.animationCharacter(Type.Character.ENEMY, enemy.getNo(), 57));
            }
        }
    }
}
