package Repositories;

import models.Download;
import models.Song;
import models.User;
import utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DownloadRepository {

    public boolean downloadSong(Download download) {
        String sqlInsertDownload = "INSERT INTO Downloads (downloadId, songId, userUsername) VALUES (?, ?, ?)";
        String sqlUpdateSongPlaylist = "UPDATE Songs SET playlistId = 0 WHERE songId = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsertDownload);
                 PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateSongPlaylist)) {

                psInsert.setInt(1, download.getDownloadId());
                psInsert.setInt(2, download.getSong().getSongId());
                psInsert.setString(3, download.getUser().getUsername());
                psInsert.executeUpdate();

                psUpdate.setInt(1, download.getSong().getSongId());
                psUpdate.executeUpdate();

                conn.commit();

                //download.getSong().setPlayList(null);

                return true;

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

    public static boolean checkDownloadExists(Download download) {
        String sql = "SELECT 1 FROM Downloads WHERE downloadId = ?";

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, download.getDownloadId());

            try(ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }

    public Download[] getDownloadList() {
        String sql = "SELECT downloadId, songId, userUsername FROM Downloads";
        List<Download> downloads = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int downloadId = rs.getInt("downloadId");
                int songId = rs.getInt("songId");
                String username = rs.getString("userUsername");

                User user = UserRepository.getUserByUsername(username);
                Song song = SongRepository.getSongById(songId);

                if (user != null && song != null) {
                    Download download = new Download(downloadId, song, user);
                    downloads.add(download);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return downloads.toArray(new Download[0]);
    }

    public Download[] getDownloadsListByUser(User user) {
        String sql = "SELECT downloadId, songId, userUserName FROM Downloads WHERE userUsername = ?";
        List<Download> downloads = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(3, user.getUsername());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int downloadId = rs.getInt("downloadId");
                    int songId = rs.getInt("songId");
                    Song song = SongRepository.getSongById(songId);

                    if (song != null) {
                        Download download = new Download(downloadId, song, user);
                        downloads.add(download);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return downloads.toArray(new Download[0]);
    }
}