import java.util.ArrayList;
import java.util.List;

public class song {
    private String title;
    private String artist;
    private String album;
    private String genre;
    private int duration;
    private String releaseDate;
    private String lyrics;
    private String coverImageUrl;
    private String songUrl;
    private String songId;
    private double price;
    private List<Double> ratings;
    private List<Comment> comments;
    public song(String title, String artist, String album, String genre, int duration, String releaseDate, String lyrics, String coverImageUrl, String songUrl, String songId) {
        this.title = title;
        this.artist = artist;
        this.album = album;
        this.genre = genre;
        this.duration = duration;
        this.releaseDate = releaseDate;
        this.lyrics = lyrics;
        this.coverImageUrl = coverImageUrl;
        this.songUrl = songUrl;
        this.songId = songId;
        price = 0.0;
        ratings = new ArrayList<>();
        comments = new ArrayList<>();}
    public song(String title, String artist, String album, String songId) {
        this(title, artist, album, "Unknown", 0, "Unknown", "No lyrics available", "No cover image", "No song URL", songId);
    }


    public String getTitle() {
        return title;
    }
    public String getArtist() {
        return artist;
    }
    public String getAlbum() {
        return album;
    }
    public String getGenre() {
        return genre;
    }
    public int getDuration() {
        return duration;
    }
    public String getReleaseDate() {
        return releaseDate;
    }
    public String getLyrics() {
        return lyrics;
    }
    public String getCoverImageUrl() {
        return coverImageUrl;
    }
    public String getSongUrl() {
        return songUrl;
    }
    public String getSongId() {
        return songId;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public void setArtist(String artist) {
        this.artist = artist;
    }
    public void setAlbum(String album) {
        this.album = album;
    }
    public void setGenre(String genre) {
        this.genre = genre;
    }
    public void setLyrics(String lyrics) {
        this.lyrics = lyrics;
    }
    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }
    @Override
    public String toString() {
        return "song{" +
                "title='" + title + '\'' +
                ", artist='" + artist + '\'' +
                ", album='" + album + '\'' +
                ", genre='" + genre + '\'' +
                ", duration=" + duration +
                ", releaseDate='" + releaseDate + '\'' +
                ", lyrics='" + lyrics + '\'' +
                ", coverImageUrl='" + coverImageUrl + '\'' +
                ", songUrl='" + songUrl + '\'' +
                ", songId='" + songId + '\'' +
                '}';
    }
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;}
    public double getAvgRating() {
        if (ratings.isEmpty()) {
            return 0.0;
        }
        double sum = 0.0;
        for (double rating : ratings) {
            sum += rating;
        }
        return sum / ratings.size();
    }
    public void setRating(double rating) {
        if (rating >= 0 && rating <= 5) {
            ratings.add(rating);
        } else {
            System.out.println("Rating must be between 0 and 5.");
        }
    }
    public List<Double> getRatings() {
        return ratings;
    }
    public List<Comment> getComments() {
        return comments;
    }
    public void addComment(Comment comment) {
        comments.add(comment);
    }
    public void removeComment(Comment comment) {
        comments.remove(comment);
    }


}
