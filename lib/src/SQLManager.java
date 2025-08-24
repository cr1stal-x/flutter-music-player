import com.mpatric.mp3agic.ID3v2;
import com.mpatric.mp3agic.Mp3File;
import java.io.File;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class SQLManager {


    public static int login(String userInput, String password) {
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
        String query = "SELECT id, title, artist, price,download_time, category, rating, rating_count, cover_base64 FROM serverSongs";
        try (Connection conn = SQLConnection.connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> song = new HashMap<>();
                song.put("id", rs.getInt("id"));
                song.put("title", rs.getString("title"));
                song.put("artist", rs.getString("artist"));
                song.put("price", rs.getDouble("price"));
                song.put("download_time", rs.getInt("download_time"));
                song.put("category", rs.getString("category"));
                song.put("rating", rs.getDouble("rating"));
                song.put("rating_count", rs.getInt("rating_count"));
                song.put("cover_base64",rs.getString("cover_base64"));
                songs.add(song);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }

    public static Map<String, Object> downloadSong(ClientHandler cl, int songId) {
        Map<String, Object> songData = new HashMap<>();
        String query = "SELECT title, artist, price, download_time, song_base64, cover_base64 FROM serverSongs WHERE id = ?";

        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, songId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    songData.put("error", "Song not found");
                    return songData;
                }

                songData.put("songId", songId);
                songData.put("title", rs.getString("title"));
                songData.put("artist", rs.getString("artist"));
                songData.put("price", rs.getDouble("price"));
                songData.put("download_time", rs.getInt("download_time"));
                songData.put("song_base64", rs.getString("song_base64"));
                songData.put("cover_base64", rs.getString("cover_base64"));

                String checkQuery = "SELECT 1 FROM downloaded_serverSongs WHERE user_id = ? AND song_id = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                    checkStmt.setInt(1, cl.id);
                    checkStmt.setInt(2, songId);
                    try (ResultSet checkRs = checkStmt.executeQuery()) {
                        if (checkRs.next()) {
                            songData.put("message", "You downloaded this before");
                            return songData;
                        }
                    }
                }

                String insertQuery = """
                INSERT INTO downloaded_serverSongs (user_id, song_id)
                VALUES (?, ?)
            """;
                try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                    insertStmt.setInt(1, cl.id);
                    insertStmt.setInt(2, songId);
                    insertStmt.executeUpdate();
                }

                String updateQuery = "UPDATE serverSongs SET download_time = download_time + 1 WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                    updateStmt.setInt(1, songId);
                    updateStmt.executeUpdate();
                }

                songData.put("download_time", ((int) songData.get("download_time")) + 1);
                songData.put("message", "Song downloaded successfully");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            songData.put("error", "Database error");
        }
        System.out.println(songData);
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

    public static boolean addSongToPlaylist(int playlistId, double songId) {
        String query = "INSERT INTO playlist_localSongs (playlist_id, song_id) VALUES (?, ?)";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playlistId);
            stmt.setDouble(2, songId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
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

    public static List<Integer> getPlaylistSongs(int userId, String title) {
        List<Integer> songs = new ArrayList<>();
        int playlistId = getPlaylistId(userId, title);
        if (playlistId == -1) {
            System.out.println("Playlist not found for user " + userId);
            return null;
        }

        String query = "SELECT song_id FROM playlist_localsongs WHERE playlist_id = ? ";


        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playlistId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    songs.add(rs.getInt("song_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }
    public static int getPlaylistId(int userId, String title) {
        String query = "SELECT id FROM playlists WHERE user_id = ? AND title = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setString(2, title);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // not found
    }

    public static List<Map<String, Object>> getPlaylists(int userId) {
        List<Map<String, Object>> playlists = new ArrayList<>();
        String query = "SELECT id, title FROM playlists WHERE user_id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> playlist = new HashMap<>();
                    playlist.put("id", rs.getInt("id"));
                    playlist.put("title", rs.getString("title"));
                    playlists.add(playlist);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return playlists;
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

    public static boolean resetPassword(int id, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1,newPassword);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<String> loadSongs(String rootPath) {
        File rootDir = new File(rootPath);
        if (!rootDir.exists() || !rootDir.isDirectory()) {
            System.out.println("❌ Invalid root directory.");
            return Collections.emptyList();
        }

        File[] categoryDirs = rootDir.listFiles(File::isDirectory);
        if (categoryDirs == null || categoryDirs.length == 0) {
            System.out.println("⚠️ No category folders found.");
            return Collections.emptyList();
        }

        Set<String> uniqueCategories = new HashSet<>();

        for (File categoryDir : categoryDirs) {
            String category = categoryDir.getName(); // folder name as category
            uniqueCategories.add(category);

            File[] files = categoryDir.listFiles((d, name) -> name.toLowerCase().endsWith(".mp3"));
            if (files == null || files.length == 0) {
                System.out.println("⚠️ No mp3 files in: " + category);
                continue;
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
                        if (tag.getTitle() != null && !tag.getTitle().isBlank()) title = tag.getTitle();
                        if (tag.getArtist() != null && !tag.getArtist().isBlank()) artist = tag.getArtist();

                        byte[] imageData = tag.getAlbumImage();
                        if (imageData != null) {
                            coverBase64 = Uploader.encodeBytesToBase64(imageData);
                        }
                    }

                    double price = title.length() / 10.0;

                    try (Connection conn = SQLConnection.connect();
                         PreparedStatement stmt = conn.prepareStatement(
                                 "INSERT INTO serverSongs (title, artist, price, category, song_base64, cover_base64) VALUES (?, ?, ?, ?, ?, ?)")) {

                        stmt.setString(1, title);
                        stmt.setString(2, artist);
                        stmt.setDouble(3, price);
                        stmt.setString(4, category);
                        stmt.setString(5, songBase64);
                        stmt.setString(6, coverBase64);
                        stmt.executeUpdate();

                        System.out.println("✅ Inserted song: " + title + " [Category: " + category + "]");
                    }

                } catch (Exception e) {
                    System.out.println("❌ Failed to insert: " + file.getName() + " in " + category);
                    e.printStackTrace();
                }
            }
        }

        return new ArrayList<>(uniqueCategories);
    }

    public static int getAccByUsername(String username){
            String query = "SELECT id FROM users WHERE username = ?";
            int id=-1;
            try (Connection conn = SQLConnection.connect();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    id= rs.getInt("id");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return id;
        }

    public static boolean rate(double songId, double newRating) {
        String selectQuery = "SELECT rating, rating_count FROM serverSongs WHERE id = ?";
        String updateQuery = "UPDATE serverSongs SET rating = ?, rating_count = ? WHERE id = ?";

        try (Connection conn = SQLConnection.connect();
             PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {

            selectStmt.setDouble(1, songId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                double currentRating = rs.getDouble("rating");
                int ratingCount = rs.getInt("rating_count");

                double total = currentRating * ratingCount;
                double newAverage = (total + newRating) / (ratingCount + 1);

                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                    updateStmt.setDouble(1, newAverage);
                    updateStmt.setInt(2, ratingCount + 1);
                    updateStmt.setDouble(3, songId);
                    return updateStmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static Map<String, Object> getRating(double songId) {
        Map<String, Object> result = new HashMap<>();
        String selectQuery = "SELECT rating, rating_count FROM serverSongs WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {

            selectStmt.setDouble(1, songId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                double rating = rs.getDouble("rating");
                int ratingCount = rs.getInt("rating_count");
                result.put("rating",rating);
                result.put("ratingCount", ratingCount);
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return result;
    }

    public static boolean addComment(int songId, int userId, String content) {
        String query = "INSERT INTO comments (user_id, serverSong_id, content, created_at) VALUES (?, ?, ?, NOW())";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, songId);
            stmt.setString(3, content);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public static List<Map<String, Object>> getComments(int songId) {
        String query = "SELECT c.id, c.content, c.likes, c.dislikes, c.created_at, u.username " +
                "FROM comments c JOIN users u ON c.user_id = u.id " +
                "WHERE c.serverSong_id = ? ORDER BY c.id DESC";

        List<Map<String, Object>> comments = new ArrayList<>();

        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, songId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> comment = new HashMap<>();
                comment.put("id", rs.getInt("id"));
                comment.put("content", rs.getString("content"));
                comment.put("likes", rs.getInt("likes"));
                comment.put("dislikes", rs.getInt("dislikes"));
                comment.put("username", rs.getString("username"));
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                comment.put("created_at", rs.getObject("created_at", LocalDateTime.class).format(formatter));
                comments.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comments;
    }

    public static boolean likeComment(int commentId) {
        String query = "UPDATE comments SET likes = likes + 1 WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean dislikeComment(int commentId) {
        String query = "UPDATE comments SET dislikes = dislikes + 1 WHERE id = ?";
        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, commentId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<String> getCategories(){
        List<String> categories = new ArrayList<>();
        String query = "SELECT category FROM serverSongs";
        try (Connection conn = SQLConnection.connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public static boolean updateCommentContent(int commentId, int userId, String newContent) {
        String sql = "UPDATE comments SET content = ? WHERE id = ? AND user_id = ?";

        try (Connection conn = SQLConnection.connect();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newContent);
            stmt.setInt(2, commentId);
            stmt.setInt(3, userId);
            System.out.println(commentId+userId+newContent);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteComment(int commentId, int userId) {
        String sql = "DELETE FROM comments WHERE id = ? AND user_id = ?";

        try (Connection conn = SQLConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, commentId);
            ps.setInt(2, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}