package game;

import database.*;

import java.lang.reflect.Method;

public class Functions {
    public static EnemyFunction enemy = new EnemyFunction();
    public static NpcFunction npc = new NpcFunction();
    public static ItemFunction item = new ItemFunction();
    public static SkillFunction skill = new SkillFunction();

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

    public static class EnemyFunction {
        public void chipmunkSkill(Enemy enemy) {
            if (enemy.getTarget() instanceof User) {
                User u = (User) enemy.getTarget();
                u.jump(u.getDirection(), 0);
            }
        }
    }

    public static class NpcFunction {
        public void testNpc(User user, Npc npc) {
            User.Message msg = user.getMessage();
            
            if (!msg.isStart()) {
                msg.open(npc.getNo(), 0);
                return;
            }

            if (msg.getMessage() == 0)
                msg.update(5, 0);
            else if (msg.getMessage() == 5)
                msg.update(10, -1);
            else if (msg.getMessage() == 10)
                msg.close();
        }
    }

    public static class ItemFunction {
        public void potion(User user, GameData.Item _item) {
            GameData.ItemData item = GameData.item.get(_item.getNo());
            user.gainHp(item.getHp());
        }
    }

    public static class SkillFunction {
        public void crossCut(User user, GameData.Skill _skill) {
            Field field = Map.getMap(user.getMap()).getField(user.getSeed());
            GameData.SkillData skill = GameData.skill.get(_skill.getNo());

            for (game.Enemy enemy : field.getAliveEnemies()) {
                enemy.animation(57);
                enemy.loseHp(100);
            }
        }
    }
}
