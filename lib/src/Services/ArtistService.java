package Services;

import Repositories.ArtistRepository;
import models.Artist;

import java.sql.SQLException;
import java.util.List;

public class ArtistService {

    public boolean addArtist(Artist artist) {
        try {
            if(!checkArtistExists(artist)) {
                return ArtistRepository.addArtist(artist);
            } else {
                System.out.println("Artist already exists.");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkArtistExists(Artist artist) {
        return ArtistRepository.checkArtistExists(artist);
    }

    public List<Artist> getAllArtists() {
        return ArtistRepository.getArtistsList();
    }

    public Artist getArtistByName(String name) {
        return ArtistRepository.getArtistByName(name);
    }

    public Artist getArtistById(int artistId) {
        return ArtistRepository.getArtistById(artistId);
    }
}
