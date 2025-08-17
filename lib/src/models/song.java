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

    public song(String title, String artist, String album, String genre, int duration,
                String releaseDate, String lyrics, String coverImageUrl, String songUrl, String songId) {
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
        this.price = 0.0;
        this.ratings = new ArrayList<>();
        this.comments = new ArrayList<>();
    }

    public song(String title, String artist, String album, String songId) {
        this(title, artist, album, "Unknown", 0, "Unknown", "No lyrics available", "No cover image", "No song URL", songId);
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getArtist() { return artist; }
    public void setArtist(String artist) { this.artist = artist; }

    public String getAlbum() { return album; }
    public void setAlbum(String album) { this.album = album; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getReleaseDate() { return releaseDate; }
    public void setReleaseDate(String releaseDate) { this.releaseDate = releaseDate; }

    public String getLyrics() { return lyrics; }
    public void setLyrics(String lyrics) { this.lyrics = lyrics; }

    public String getCoverImageUrl() { return coverImageUrl; }
    public void setCoverImageUrl(String coverImageUrl) { this.coverImageUrl = coverImageUrl; }

    public String getSongUrl() { return songUrl; }
    public void setSongUrl(String songUrl) { this.songUrl = songUrl; }

    public String getSongId() { return songId; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

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

    public void updateAvgRating() {
        double avg = SQLManager.getAverageRating(Integer.parseInt(songId));
        ratings.clear();
        ratings.add(avg);
    }

    public double getAvgRating() {
        if (ratings.isEmpty()) return 0.0;
        return ratings.get(0);
    }

    public void rateSong(int userId, double rating) {
        if (rating >= 0 && rating <= 5) {
            SQLManager.rateSong(Integer.parseInt(songId), userId, rating);
            updateAvgRating();
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
        SQLManager.addComment(Integer.parseInt(songId), comment.getUserId(), comment.getContent());
    }

    public void removeComment(int commentId) {
        Comment toRemove = null;
        for (Comment c : comments) {
            if (c.getCommentId() == commentId) {
                toRemove = c;
                break;
            }
        }
        if (toRemove != null) {
            comments.remove(toRemove);
            SQLManager.deleteComment(commentId);
        }
    }

    public void editComment(int commentId, String newContent) {
        for (Comment c : comments) {
            if (c.getCommentId() == commentId) {
                c.setContent(newContent);
                SQLManager.updateComment(commentId, newContent);
                break;
            }
        }
    }
}
