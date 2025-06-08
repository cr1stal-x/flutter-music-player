import java.sql.*;

public class SQLManager {

    public static int login(String username, String password) {
        String query = "SELECT id FROM users WHERE username = ? AND password = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static int signUp(String username, String password) {
        if (login(username, password) != 0) return 400;

        String query = "INSERT INTO users (username, password) VALUES (?, ?)";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 500;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return 500;
        }
    }


    public static String get(int id) {
        String query = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id") + "-" + rs.getString("username") + "-" + rs.getString("password") + "-" + rs.getString("data");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int update(int id, String data) {
        String query = "UPDATE users SET data = ? WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, data);
            stmt.setInt(2, id);
            int rows = stmt.executeUpdate();
            return rows > 0 ? 200 : 404;

        } catch (SQLException e) {
            e.printStackTrace();
            return 500;
        }
    }

    public static int delete(int id) {
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            int rows = stmt.executeUpdate();
            return rows > 0 ? 200 : 404;

        } catch (SQLException e) {
            e.printStackTrace();
            return 500;
        }
    }
}
