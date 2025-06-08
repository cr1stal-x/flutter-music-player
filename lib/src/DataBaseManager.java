import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class DataBaseManager {
    static String filePath = "C:\\Users\\User\\Desktop\\user.txt";
    static int lastId=1 ;
    static {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("-");
                int id = Integer.parseInt(parts[0]);
                if (id >= lastId) {
                    lastId = id + 1;
                }
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    static public int login(String userId, String password) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        String line;
        while ((line = reader.readLine()) != null) {
            String[] elements = line.split("-");
            if (elements[1].equals(userId) && elements[2].equals(password)) {
                return Integer.parseInt(elements[0]);
            }
        }
        reader.close();
        return 0;
    }


    static public int signUp(String userName, String password) throws IOException {

            if (login(userName, password) != 0) return 400;

            int id = lastId++;
            String data = id + "-" + userName + "-" + password;

            BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true));
            writer.write(data);
            writer.newLine();
            writer.close();

            return id;

    }

    public static String get(int id) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        String line = reader.readLine();
        String result="";
        while (line != null) {
            String[] elements = line.split("-");
            if (Integer.parseInt(elements[0]) == id) {
                result = line;
                break;
            }
            line = reader.readLine();
        }
        reader.close();
        if (result.length() == 0) {
            return "User not found";
        }
        return result.toString();
    }

    public static int update(int id, String data) throws IOException {
        List<String> lines = new ArrayList<>();
        boolean found = false;
        int result = 404; // Not found
        try(BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] elements = line.split("-");
                if (Integer.parseInt(elements[0]) == id) {
                    found = true;
                    String newdata=id+"-"+elements[1]+"-"+elements[2]+"-"+data;
                    lines.add(newdata);
                    result = 200;
                } else {
                    lines.add(line);
                }
            }
        }
        if (!found) {
            return result; // User not found
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.write(line);
                writer.flush();
                writer.newLine();
            }
        }
        return result;

    }
    public static int delete(int id) throws IOException {
        List<String> lines = new ArrayList<>();
        boolean found = false;
        int result = 404; // Not found
        try(BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] elements = line.split("-");
                if (Integer.parseInt(elements[0]) == id) {
                    found = true;
                    result = 200; // User deleted successfully
                } else {
                    lines.add(line);
                }
            }
        }
        if (!found) {
            return result; // User not found
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.write(line);
                writer.flush();
                writer.newLine();
            }
        }
        return result;
    }
}
