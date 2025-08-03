package Repositories;

import models.*;
import utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SongRepository {

    public boolean addSong(Song newSong) {
        if (checkSongExists(newSong.getSongId())) {
            System.out.println("Song with ID " + newSong.getSongId() + " already exists.");
            return false;
        }

        String sql = "INSERT INTO Songs (songId, title, artistId, albumId, genreID, playlistId, duration, releaseDate, lyrics, coverImageUrl, songUrl, isFree, price, totalDownloadsCount, avgRate) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newSong.getSongId());
            ps.setString(2, newSong.getTitle());
            ps.setInt(3, newSong.getArtist().getArtistId());
            ps.setInt(4, newSong.getAlbum().getAlbumId());
            ps.setInt(5, newSong.getGenre().getGenreId());
            ps.setInt(6, newSong.getDuration());
            ps.setString(7, newSong.getReleaseDate());
            ps.setString(8, newSong.getLyrics());
            ps.setString(9, newSong.getCoverImageUrl());
            ps.setString(10, newSong.getSongUrl());
            ps.setBoolean(11, newSong.getFree());
            ps.setDouble(12, newSong.getPrice());
            ps.setInt(13, newSong.getTotalDownloadsCount());
            ps.setDouble(14, newSong.getAvgRate());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkSongExists(int songId) {
        String sql = "SELECT 1 FROM Songs WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, songId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Song getSongByTitle(String title) {
        String sql = "SELECT * FROM Songs WHERE title = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractSongFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Song getSongById(int id) {
        String sql = "SELECT * FROM Songs WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractSongFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Song> getAllSongs() {
        String sql = "SELECT * FROM Songs";
        List<Song> songs = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Song song = extractSongFromResultSet(rs);
                songs.add(song);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return songs;
    }

    public boolean removeSong(int songId) {
        String sql = "DELETE FROM Songs WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, songId);

            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editSongTitle(int songID, String title){
        String sql = "UPDATE Songs SET title = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setInt(2, songID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editSongArtist(int songID, int artistID){
        String sql = "UPDATE Songs SET artist_id = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, artistID);
            ps.setInt(2, songID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editSongAlbum(int songID, Album album) {
        String sql = "UPDATE Songs SET albumId = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, album.getAlbumId());
            ps.setInt(2, songID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editSongGenre(int songID, Genre genre) {
        String sql = "UPDATE Songs SET genre_id = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, genre.getGenreId());
            ps.setInt(2, songID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editSongImage(int songID, String coverImageUrl) {
        String sql = "UPDATE Songs SET coverImageUrl = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, coverImageUrl);
            ps.setInt(2, songID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSongAvgRate(int songId, double avgRate) {
        String sql = "UPDATE Songs SET avgRate = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, avgRate);
            ps.setInt(2, songId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Song extractSongFromResultSet(ResultSet rs) throws SQLException {
        int songId = rs.getInt("songId");
        String title = rs.getString("title");
        String lyrics = rs.getString("lyrics");
        String coverImageUrl = rs.getString("coverImageUrl");
        String songUrl = rs.getString("songUrl");
        double price = rs.getDouble("price");
        int totalDownloads = rs.getInt("totalDownloadsCount");
        int duration = rs.getInt("duration");
        String releaseDate = rs.getString("releaseDate");
        double avgRate = rs.getDouble("avgRate");

        int artistId = rs.getInt("artistId");
        int genreId = rs.getInt("genreId");
        int albumId = rs.getInt("albumId");

        Artist artist = ArtistRepository.getArtistById(artistId);
        Genre genre = GenreRepository.getGenreById(genreId);
        Album album = AlbumRepository.getAlbumById(albumId);

        Song song = new Song(songId, title, artist, album, genre);
        song.setLyrics(lyrics);
        song.setCoverImageUrl(coverImageUrl);
        song.setSongUrl(songUrl);
        song.setPrice(price);
        song.setTotalDownloadsCount(totalDownloads);
        song.setDuration(duration);
        song.setReleaseDate(releaseDate);
        song.setAvgRate(avgRate);

        return song;
    }
}