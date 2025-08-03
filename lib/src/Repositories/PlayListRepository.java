package Repositories;

import models.PlayList;
import models.Song;
import models.User;
import utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlayListRepository {

    public static boolean addPlaylist(PlayList playList) throws SQLException {
        String sql = "INSERT INTO Playlists (playlistId, userUsername, name, isFavorite) VALUES (?, ?, ?, ?)";

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playList.getPlaylistId());
            ps.setString(2, playList.getUser().getUsername());
            ps.setString(3, playList.getName());
            ps.setBoolean(4, playList.getIsFavorite());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Song> getSongsList(int playlistId) {
        String sql = "SELECT * FROM Songs WHERE playlistId = ?";
        List<Song> songs = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playlistId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Song song = SongRepository.extractSongFromResultSet(rs);
                songs.add(song);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return songs;

    }

    public void addSongToPlaylist(Song s, int playlistId) {
        String sql = "UPDATE Songs SET playlistId = ? WHERE songId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getSongId());
            ps.setInt(4, playlistId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public static boolean checkSongExistsInPlaylist(Song song, int playlistId) {
        String sql = "SELECT 1 FROM Songs WHERE songId = ? AND playlistId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, song.getSongId());
            ps.setInt(2, playlistId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void removeSongFromPlaylist(Song s, int playlistId) {
        String sql = "UPDATE Songs SET playlistId = 0 WHERE songId = ? AND playlistId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getSongId());
            ps.setInt(2, playlistId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                getPlaylistById(playlistId).setPlaylistId(0);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void clearAllSongsOfPlaylist(int playlistId) {
        String sql = "UPDATE Songs SET playlistId = 0 WHERE playlistId = ?";
        List<Song> songsToUpdate = getSongsList(playlistId);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playlistId);
            int rows = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getSongCount(int playlistId) {
        String sql = "SELECT * FROM Songs WHERE playlistId = ?";
        int count = 0;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playlistId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                count++;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public void removePlayList(PlayList playList) {
        clearAllSongsOfPlaylist(playList.getPlaylistId());
        String sql = "DELETE FROM Playlists WHERE playlistId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playList.getPlaylistId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public List<PlayList> getUserPlaylists(User u) {
        String sql = "SELECT id, name FROM Playlists WHERE userUsername = ?";
        List<PlayList> playlists = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(2, u.getUsername());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int playlistId = rs.getInt("playlistId");
                    String name = rs.getString("name");
                    boolean isFavorite = rs.getBoolean("isFavorite");

                    PlayList playlist = new PlayList(playlistId, u, name, isFavorite);
                    playlists.add(playlist);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return playlists;
    }

    public static PlayList getPlaylistById(int playlistId) {
        String sql = "SELECT playlistId, userUsername, name, isFavorite FROM Playlists WHERE playlistId = ?";
        PlayList playlist = null;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, playlistId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("name");
                    String userUsername = rs.getString("userUsername");
                    boolean isFavorite = rs.getBoolean("isFavorite");
                    User user = UserRepository.getUserByUsername(userUsername);
                    playlist = new PlayList(playlistId, user, name, isFavorite);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return playlist;
    }

    public void clearUserPlaylist(User u) {
        String selectSql = "SELECT playlistId FROM Playlists WHERE userUsername = ?";
        String updateSongsSql = "UPDATE Songs SET playlistId = 0 WHERE playlistId = ?";
        String deletePlaylistsSql = "DELETE FROM Playlists WHERE playlistId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setString(2, u.getUsername());
            ResultSet rs = selectStmt.executeQuery();

            List<Integer> playlistIds = new ArrayList<>();

            while (rs.next()) {
                playlistIds.add(rs.getInt("playlistId"));
            }

            for (int playlistId : playlistIds) {
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSongsSql)) {
                    updateStmt.setInt(1, playlistId);
                    updateStmt.executeUpdate();
                }

                try (PreparedStatement deleteStmt = conn.prepareStatement(deletePlaylistsSql)) {
                    deleteStmt.setInt(1, playlistId);
                    deleteStmt.executeUpdate();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
