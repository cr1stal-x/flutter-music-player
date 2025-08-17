import java.util.ArrayList;
import java.util.List;

public class SongService {
    private List<Song> songs;

    public SongService() {
        this.songs = new ArrayList<>();
    }

    public void addSong(Song newSong) {
        songs.add(newSong);
    }

    public Song getSongByTitle(String title) {
        for (Song s : songs) {
            if (s.getTitle().equals(title)) {
                return s;
            }
        }
        return null;
    }

    public List<Song> getAllSongs() {
        return new ArrayList<>(songs);
    }

    public void removeSong(String title) {
        songs.removeIf(s -> s.getTitle().equals(title));
    }

    public void editSongTitle(Song s, String title) {
        if(s != null && title != null) s.setTitle(title);
    }

    public void editSongArtist(Song s, String artist) {
        if(s != null && artist != null) s.setArtist(artist);
    }

    public void editSongAlbum(Song s, String album) {
        if(s != null && album != null) s.setAlbum(album);
    }

    public void editSongGenre(Song s, String genre) {
        if(s != null && genre != null) s.setGenre(genre);
    }

    public void editSongImage(Song s, String coverImageUrl) {
        if(s != null && coverImageUrl != null) s.setCoverImageUrl(coverImageUrl);
    }

    public void rateSong(Song s, double rating) {
        if(s != null){
            s.getRatings().add(rating);
            double avg = s.getRatings().stream().mapToDouble(Double::doubleValue).average().orElse(0);
            s.setRating(avg);
        }
    }

    public void addComment(Song s, Comment comment) {
        if(s != null && comment != null){
            s.getComments().add(comment);
        }
    }

    public List<Comment> getComments(Song s) {
        if(s != null) return s.getComments();
        return new ArrayList<>();
    }
}
