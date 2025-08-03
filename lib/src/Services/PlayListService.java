package Services;

import Repositories.PlayListRepository;
import models.PlayList;
import models.Song;
import models.User;
import java.sql.SQLException;
import java.util.List;

public class PlayListService {

    private final PlayListRepository repository = new PlayListRepository();

    public boolean createPlayList(PlayList playList) {
        try {
            return PlayListRepository.addPlaylist(playList);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Song> getSongsInPlaylist(int playlistId) {
        return repository.getSongsList(playlistId);
    }

    public boolean removeSongFromPlaylist(Song song, int playlistId) {
        if (PlayListRepository.checkSongExistsInPlaylist(song, playlistId)) {
            repository.removeSongFromPlaylist(song, playlistId);
            return true;
        }
        return false;
    }

    public void clearPlaylist(int playlistId) {
        repository.clearAllSongsOfPlaylist(playlistId);
    }

    public int countSongsInPlaylist(int playlistId) {
        return repository.getSongCount(playlistId);
    }

    public void deletePlaylist(PlayList playlist) {
        repository.removePlayList(playlist);
    }

    public List<PlayList> getUserPlaylists(User user) {
        return repository.getUserPlaylists(user);
    }

    public PlayList getPlaylistById(int id) {
        return repository.getPlaylistById(id);
    }

    public void deleteAllPlaylistsOfUser(User user) {
        repository.clearUserPlaylist(user);
    }
}