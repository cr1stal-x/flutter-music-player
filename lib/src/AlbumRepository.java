package Repositories;

import models.Album;
import models.Artist;
import utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlbumRepository {

    public static Album getAlbumById(int albumId) {
        String sql = "SELECT albumId, name, artistId FROM Albums WHERE albumId = ?";
        Album album = null;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, albumId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("name");
                    int artistId = rs.getInt("artistId");

                    Artist artist = ArtistRepository.getArtistById(artistId);
                    if (artist != null) {
                        album = new Album(albumId, name, artist);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return album;
    }

    public Album[] getAlbumListByArtist(int artistId) {
        String sql = "SELECT albumId, name FROM Albums WHERE artistId = ?";
        List<Album> albums = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, artistId);

            try (ResultSet rs = ps.executeQuery()) {
                Artist artist = ArtistRepository.getArtistById(artistId);

                while (rs.next()) {
                    int albumId = rs.getInt("albumId");
                    String name = rs.getString("name");

                    Album album = new Album(albumId, name, artist);
                    albums.add(album);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return albums.toArray(new Album[0]);
    }
}
