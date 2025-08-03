package Repositories;

import models.Rate;
import utils.DatabaseConnection;

import java.sql.*;

public class RateRepository {

    public boolean rateSong(Rate rate) {
        String sql = "INSERT INTO Ratings (rateId, songId, userUsername, rate) VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE rate = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, rate.getRateId());
            ps.setInt(2, rate.getSongID());
            ps.setString(3, rate.getUserUsername());
            ps.setInt(4, rate.getRate());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double calculateAverageRating(int songId) {
        String sql = "SELECT AVG(rate) AS avgRate FROM Ratings WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, songId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRate");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
