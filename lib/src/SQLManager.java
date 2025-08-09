import com.mpatric.mp3agic.ID3v2;
import com.mpatric.mp3agic.Mp3File;
import java.io.File;
import java.sql.*;
import java.util.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class SQLManager {
    public static int login(String userInput, String password) {
        // userInput can be either username or email
        String query = "SELECT id FROM users WHERE (username = ? OR email = ?) AND password = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userInput); // check username
            stmt.setString(2, userInput); // check email
            stmt.setString(3, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    public static int signUp(String username, String password, String email) {
        String checkQuery = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {

            checkStmt.setString(1, username);
            ResultSet checkRs = checkStmt.executeQuery();
            if (checkRs.next()) {
                return -1; // Username already exists
            }

            String insertQuery = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
                insertStmt.setString(1, username);
                insertStmt.setString(2, password);
                insertStmt.setString(3, email);
                insertStmt.executeUpdate();

                ResultSet rs = insertStmt.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0; // Other error
    }



    public static double getCredit(int id) {
        String query = "SELECT credit FROM users WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getDouble("credit");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static boolean getIsVip(int id) {
        String query = "SELECT isVip FROM users WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getBoolean("isVip");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static int updateUser(int id, Map<String, Object> updates) {
        if (updates == null || updates.isEmpty()) return 400;

        List<String> validFields = Arrays.asList("username", "email", "password", "profile_cover", "credit", "isVip");
        StringBuilder query = new StringBuilder("UPDATE users SET ");
        List<Object> values = new ArrayList<>();

        for (String key : updates.keySet()) {
            if (!validFields.contains(key)) continue;
            query.append(key).append(" = ?, ");
            values.add(updates.get(key));
        }

        if (values.isEmpty()) return 400;

        query.setLength(query.length() - 2);
        query.append(" WHERE id = ?");
        values.add(id);

        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < values.size(); i++) {
                stmt.setObject(i + 1, values.get(i));
            }

            int rows = stmt.executeUpdate();
            return rows > 0 ? 200 : 404;

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
                return rs.getInt("id") + "-" + rs.getString("username") + "-" + rs.getDouble("credit");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
        }
        return 500;
    }

    public static Map<String, Object> getAccountInfo(int id) {
        String query = "SELECT username, password, email, credit, isVip, profile_cover FROM users WHERE id = ?";
        Map<String, Object> result = new HashMap<>();
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("username", rs.getString("username"));
                result.put("password", rs.getString("password"));
                result.put("email", rs.getString("email"));
                result.put("credit", rs.getDouble("credit"));
                result.put("isVip", rs.getBoolean("isVip"));
                result.put("profile_cover",rs.getString("profile_cover"));
                System.out.println(result.get("profile_cover"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public static List<Map<String, Object>> getServerSongs() {
        List<Map<String, Object>> songs = new ArrayList<>();
        String query = "SELECT id, title, artist, price FROM serverSongs";
        try (Connection conn = SQLConnection.connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> song = new HashMap<>();
                song.put("id", rs.getInt("id"));
                song.put("title", rs.getString("title"));
                song.put("artist", rs.getString("artist"));
                song.put("price", rs.getDouble("price"));
                songs.add(song);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }

    public static Map<String, Object> downloadSong(ClientHandler cl, int songId) {
        Map<String, Object> songData = new HashMap<>();
        String query = "SELECT title, artist, price, song_base64, cover_base64 FROM serverSongs WHERE id = ?";

        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, songId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    songData.put("songId", songId);
                    songData.put("title", rs.getString("title"));
                    songData.put("artist", rs.getString("artist"));
                    songData.put("price", rs.getDouble("price"));
                    songData.put("song_base64", rs.getString("song_base64"));
                    songData.put("cover_base64", rs.getString("cover_base64"));

                    String insertQuery = """
                    INSERT INTO downloaded_serverSongs (user_id, song_id)
                    VALUES (?, ?)
                    ON DUPLICATE KEY UPDATE song_id = song_id
                """;

                    try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setInt(1, cl.id);
                        insertStmt.setInt(2, songId);
                        insertStmt.executeUpdate();
                    }

                } else {
                    songData.put("error", "Song not found");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            songData.put("error", "Database error");
        }

        return songData;
    }


    public static boolean createPlaylist(int userId, String title) {
        String query = "INSERT INTO playlists (title, user_id) VALUES (?, ?)";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, title);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean addSongToPlaylist(int playlistId, int songId) {
        String query = "INSERT INTO playlist_localSongs (playlist_id, song_id) VALUES (?, ?)";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playlistId);
            stmt.setInt(2, songId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean deletePlaylist(int userId, int playlistId) {
        String query = "DELETE FROM playlists WHERE id = ? AND user_id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playlistId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<Map<String, Object>> getDownloadedSongs(int userId) {
        List<Map<String, Object>> songs = new ArrayList<>();
        String query = "SELECT s.id, s.title, s.artist FROM downloaded_serverSongs d JOIN serverSongs s ON d.song_id = s.id WHERE d.user_id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> song = new HashMap<>();
                song.put("id", rs.getInt("id"));
                song.put("title", rs.getString("title"));
                song.put("artist", rs.getString("artist"));
                songs.add(song);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }

    public static boolean resetPassword(int id) {

        String query = "UPDATE users SET password = 'default123' WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void sendMessageToAdmin(int id, String message) {
        System.out.println("Message from user " + id + ": " + message);
    }


        public static void loadSongs(String directoryPath) {
            File dir = new File(directoryPath);
            if (!dir.exists() || !dir.isDirectory()) {
                System.out.println("❌ Invalid song directory.");
                return;
            }

            File[] files = dir.listFiles((d, name) -> name.endsWith(".mp3"));
            if (files == null || files.length == 0) {
                System.out.println("⚠️ No mp3 files found.");
                return;
            }

            for (File file : files) {
                try {
                    Mp3File mp3 = new Mp3File(file);
                    String title = file.getName().replace(".mp3", "");
                    String artist = "Unknown";
                    String songBase64 = Uploader.encodeFileToBase64(file.getAbsolutePath());
                    String coverBase64 = null;

                    if (mp3.hasId3v2Tag()) {
                        ID3v2 tag = mp3.getId3v2Tag();
                        if (tag.getTitle() != null) title = tag.getTitle();
                        if (tag.getArtist() != null) artist = tag.getArtist();

                        byte[] imageData = tag.getAlbumImage();
                        if (imageData != null) {
                            coverBase64 = Uploader.encodeBytesToBase64(imageData);
                        }
                    }

                    double price = Math.max(10, title.length()); // قیمت تستی

                    try (Connection conn = SQLConnection.connect();
                         PreparedStatement stmt = conn.prepareStatement(
                                 "INSERT INTO serverSongs (title, artist, price, song_base64, cover_base64) VALUES (?, ?, ?, ?, ?)")) {

                        stmt.setString(1, title);
                        stmt.setString(2, artist);
                        stmt.setDouble(3, price);
                        stmt.setString(4, songBase64);
                        stmt.setString(5, coverBase64);
                        stmt.executeUpdate();

                        System.out.println("✅ Inserted song: " + title);
                    }

                } catch (Exception e) {
                    System.out.println("❌ Failed to insert: " + file.getName());
                    e.printStackTrace();
                }
            }
        }

}
