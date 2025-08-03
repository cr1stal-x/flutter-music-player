package Repositories;

import models.Genre;
import utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GenreRepository {

    public static boolean addGenre(Genre genre) {
        String sql = "INSERT INTO Genres (genreId, name, totalRate) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, genre.getGenreId());
            ps.setString(2, genre.getName());
            ps.setDouble(3, genre.getTotalRate());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean checkGenreExists(Genre genre) {
        String sql = "SELECT 1 FROM Genres WHERE genreId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, genre.getGenreId());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Genre[] getGenresList() {
        String sql = "SELECT genreId, name, totalRate FROM Genres";
        List<Genre> genres = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int genreId = rs.getInt("genreId");
                String name = rs.getString("name");
                double totalRate = rs.getDouble("totalRate");

                Genre genre = new Genre(genreId, name, totalRate);
                genre.setGenreId(genreId);
                genres.add(genre);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return genres.toArray(new Genre[0]);
    }

    public static Genre getGenreByName(String name) {
        String sql = "SELECT genreId, name, totalRate FROM Genres WHERE name = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int genreId = rs.getInt("genreId");
                    double totalRate = rs.getDouble("totalRate");

                    Genre genre = new Genre(genreId, name, totalRate);
                    genre.setGenreId(genreId);
                    return genre;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static Genre getGenreById(int genreId) {
        String sql = "SELECT genreId, name, totalRate FROM Genres WHERE genreId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, genreId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("name");
                    double totalRate = rs.getDouble("totalRate");
                    return new Genre(genreId, name, totalRate);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}