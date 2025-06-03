import java.util.ArrayList;
import java.util.List;

public class SongService {
    private List<song> songs;

    public SongService() {
        this.songs = new ArrayList<>();
    }

    public void addSong(song newSong) {
        songs.add(newSong);
    }

    public song getSongByTitle(String title) {
        for (song s : songs) {
            if (s.getTitle().equals(title)) {
                return s;
            }
        }
        return null;
    }

    public List<song> getAllSongs() {
        return new ArrayList<>(songs);
    }

    public void removeSong(String title) {
        songs.removeIf(s -> s.getTitle().equals(title));
    }
    public void editSongTitle(song s, String title){
        s.setTitle(title);
    }
    public void editSongArtist(song s, String artist){
        s.setArtist(artist);
    }
    public void editSongAlbum(song s, String album){
        s.setAlbum(album);
    }
    public void editSongGenre(song s, String genre){
        s.setGenre(genre);
    }
    public void editSongImage(song s, String coverImageUrl){
        s.setCoverImageUrl(coverImageUrl);
    }
    public void rateSong(song s, double rating) {
        s.setRating(rating);
    }

}
