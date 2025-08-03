package Repositories;

import models.Artist;
import utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArtistRepository {

    public static boolean addArtist(Artist artist) throws SQLException {
        String sql = "INSERT INTO Artists (artistId, name, totalRate) VALUES (?, ?, ?)";

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, artist.getArtistId());
            ps.setString(2, artist.getName());
            ps.setDouble(3, artist.getTotalRate());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkArtistExists(Artist artist) {
        String sql = "SELECT 1 FROM Artists WHERE artistId = ?";

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, artist.getArtistId());

            try(ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }

    public static List<Artist> getArtistsList() {
        String sql = "SELECT artistId, name, totalRate FROM Artists";
        List<Artist> artists = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int artistId = rs.getInt("artistId");
                String name = rs.getString("name");
                double totalRate = rs.getDouble("totalRate");
                Artist artist = new Artist(artistId, name, totalRate);
                artists.add(artist);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return artists;
    }

    public static Artist getArtistByName(String name) {
        String sql = "SELECT artistId, name, totalRate FROM Artists WHERE name = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int artistId = rs.getInt("artistId");
                    double totalRate = rs.getDouble("totalRate");
                    return new Artist(artistId, name, totalRate);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Artist getArtistById(int artistId) {
        String sql = "SELECT artistId, name, totalRate FROM Artists WHERE artistId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, artistId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("name");
                    double totalRate = rs.getDouble("totalRate");
                    return new Artist(artistId, name, totalRate);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
