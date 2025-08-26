import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.*;
import java.lang.reflect.Type;
import java.util.*;

public class TextDatabase {
    private static final String FILE_PATH = "users.json";
    private static final Gson gson = new Gson();

    private static List<Map<String, Object>> readUsers() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            Type listType = new TypeToken<List<Map<String, Object>>>(){}.getType();
            List<Map<String, Object>> users = gson.fromJson(reader, listType);
            return users != null ? users : new ArrayList<>();
        } catch (IOException e) {
            return new ArrayList<>();
        }
    }

    private static void writeUsers(List<Map<String, Object>> users) {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            gson.toJson(users, writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static int login(String userInput, String password) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if ((user.get("username").equals(userInput) || user.get("email").equals(userInput))
                    && user.get("password").equals(password)) {
                return ((Double)user.get("id")).intValue();
            }
        }
        return 0;
    }

    public static int signUp(String username, String password, String email) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if (user.get("username").equals(username)) {
                return -1;
            }
        }

        int newId = users.isEmpty() ? 1 : ((Double)users.get(users.size() - 1).get("id")).intValue() + 1;

        Map<String, Object> newUser = new HashMap<>();
        newUser.put("id", newId);
        newUser.put("username", username);
        newUser.put("password", password);
        newUser.put("email", email);
        newUser.put("credit", 0.0);
        newUser.put("isVip", false);
        newUser.put("profile_cover", "");

        users.add(newUser);
        writeUsers(users);
        return newId;
    }

    public static double getCredit(int id) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if (((Double)user.get("id")).intValue() == id) {
                return (Double) user.get("credit");
            }
        }
        return 0;
    }

    public static boolean getIsVip(int id) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if (((Double)user.get("id")).intValue() == id) {
                return (Boolean) user.get("isVip");
            }
        }
        return false;
    }

    public static int updateUser(int id, Map<String, Object> updates) {
        List<Map<String, Object>> users = readUsers();
        boolean updated = false;

        for (Map<String, Object> user : users) {
            if (((Double)user.get("id")).intValue() == id) {
                for (String key : updates.keySet()) {
                    if (Arrays.asList("username","email","password","profile_cover","credit","isVip").contains(key)) {
                        user.put(key, updates.get(key));
                        updated = true;
                    }
                }
            }
        }

        if (!updated) return 404;
        writeUsers(users);
        return 200;
    }

    public static String get(int id) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if (((Double)user.get("id")).intValue() == id) {
                return user.get("id")+"-"+user.get("username")+"-"+user.get("credit");
            }
        }
        return null;
    }

    public static int delete(int id) {
        List<Map<String, Object>> users = readUsers();
        boolean removed = users.removeIf(user -> ((Double)user.get("id")).intValue() == id);
        if (removed) {
            writeUsers(users);
            return 200;
        }
        return 404;
    }

    public static Map<String, Object> getAccountInfo(int id) {
        List<Map<String, Object>> users = readUsers();
        for (Map<String, Object> user : users) {
            if (((Double)user.get("id")).intValue() == id) {
                return new HashMap<>(user);
            }
        }
        return new HashMap<>();
    }
}
