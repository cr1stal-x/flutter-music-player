package Repositories;

import models.Buy;
import models.Song;
import models.User;
import utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuyRepository {

    public boolean buySong(Buy buy) {
        User u = buy.getUser();
        Song s = buy.getSong();

        if(s.getPrice() > u.getCredit()) {
            return false;
        }

        String sqlInsert = "INSERT INTO Buys (buyId, songId, userUsername) VALUES (?, ?, ?)";
        String sqlUpdateCredit = "UPDATE Users SET credit = credit - ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                 PreparedStatement psUpdateCredit = conn.prepareStatement(sqlUpdateCredit)) {

                psInsert.setString(1, u.getUsername());
                psInsert.setInt(2, s.getSongId());
                psInsert.executeUpdate();

                psUpdateCredit.setDouble(1, s.getPrice());
                psUpdateCredit.setString(2, u.getUsername());
                int rowsUpdated = psUpdateCredit.executeUpdate();

                if (rowsUpdated > 0) {
                    conn.commit();
                    u.setCredit(u.getCredit() - s.getPrice());
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkBuyExists(Buy buy) {
        String sql = "SELECT 1 FROM Buys WHERE buyId = ?";

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, buy.getBuyId());

            try(ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }

    public Buy[] buysList() {
        String sql = "SELECT buyId, songId, userUsername FROM Buys";
        List<Buy> buys = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int buyId = rs.getInt("buyId");
                int songId = rs.getInt("songId");
                String username = rs.getString("userUsername");

                User user = UserRepository.getUserByUsername(username);
                Song song = SongRepository.getSongById(songId);

                if (user != null && song != null) {
                    Buy buy = new Buy(buyId, song, user);
                    buys.add(buy);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return buys.toArray(new Buy[0]);
    }

    public Buy[] getBuysListByUser(User user) {
        String sql = "SELECT buyId, songId, userUserName FROM Buys WHERE userUsername = ?";
        List<Buy> buys = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(3, user.getUsername());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int buyId = rs.getInt("butId");
                    int songId = rs.getInt("songId");
                    Song song = SongRepository.getSongById(songId);

                    if (song != null) {
                        Buy buy = new Buy(buyId, song, user);
                        buys.add(buy);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return buys.toArray(new Buy[0]);
    }
}
