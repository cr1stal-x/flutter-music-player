package Services;

import models.*;
import Repositories.SongRepository;

import java.util.List;

public class SongService {

    private SongRepository songRepository;

    public SongService(SongRepository songRepository) {
        this.songRepository = songRepository;
    }

    public boolean addSong(Song newSong) {
        boolean added = songRepository.addSong(newSong);
        if (added) {
            return true;
        }
        return false;
    }

    public Song getSongByTitle(String title) {
        return songRepository.getSongByTitle(title);
    }

    public List<Song> getAllSongs() {
        return songRepository.getAllSongs();
    }

    public boolean removeSong(int id) {
        return songRepository.removeSong(id);
    }

    public boolean editSongTitle(Song song, String newTitle) {
        boolean success = songRepository.editSongTitle(song.getSongId(), newTitle);
        if (success) {
            song.setTitle(newTitle);
        }
        return success;
    }

    public boolean editSongArtist(Song song, Artist newArtist) {
        boolean updatedInDb = songRepository.editSongArtist(song.getSongId(), newArtist.getArtistId());

        if (updatedInDb) {
            song.setArtist(newArtist);
            return true;
        } else {
            return false;
        }
    }

    public boolean editSongAlbum(Song song, Album album) {
        boolean success = songRepository.editSongAlbum(song.getSongId(), album);
        if (success) {
            song.setAlbum(album);
        }
        return success;
    }

    public boolean editSongGenre(Song song, Genre genre) {
        boolean success = songRepository.editSongGenre(song.getSongId(), genre);
        if (success) {
            song.setGenre(genre);
        }
        return success;
    }

    public boolean editSongImage(Song song, String coverImageUrl) {
        boolean success = songRepository.editSongImage(song.getSongId(), coverImageUrl);
        if (success) {
            song.setCoverImageUrl(coverImageUrl);
        }
        return success;
    }

    public boolean updateAverageRating(int songId, double avgRate) {
        return songRepository.updateSongAvgRate(songId, avgRate);
    }
}