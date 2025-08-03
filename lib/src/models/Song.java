package models;

public class Song {

    private int songId;
    private String title;
    private Artist artist;
    private Album album;
    private Genre genre;
    private int duration;
    private String releaseDate;
    private String lyrics;
    private String coverImageUrl;
    private String songUrl;
    private boolean isFree;
    private double price;
    private int totalDownloadsCount;
    private double avgRate;

    public Song(int songId, String title, Artist artist, Album album, Genre genre, int duration, String releaseDate, String lyrics, String coverImageUrl, String songUrl, boolean free, double price) {
        this.songId = songId;
        this.title = title;
        this.artist = artist;
        this.album = album;
        this.genre = genre;
        this.duration = duration;
        this.releaseDate = releaseDate;
        this.lyrics = lyrics;
        this.coverImageUrl = coverImageUrl;
        this.songUrl = songUrl;
        this.isFree = free;
        this.price = price;
    }

    public Song(int songId, String title, Artist artist, Album album, Genre genre) {
        this(songId, title, artist, album, genre,  0, "Not available", "Lyrics is not available", "No image", "No song URL", true, 0);
    }

    public int getSongId() {
        return songId;
    }

    public String getTitle() {
        return title;
    }

    public Artist getArtist() {
        return artist;
    }

    public Album getAlbum() {
        return album;
    }

    public Genre getGenre() {
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

    public boolean getFree() {
        return isFree;
    }

    public double getPrice() {
        return price;
    }

    public int getTotalDownloadsCount() {
        return totalDownloadsCount;
    }

    public double getAvgRate() {
        return avgRate;
    }

    public void setSongId(int songId) {
        this.songId = songId;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }

    public void setGenre(Genre genre) {
        this.genre = genre;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    public void setLyrics(String lyrics) {
        this.lyrics = lyrics;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public void setSongUrl(String songUrl) {
        this.songUrl = songUrl;
    }

    public void setFree(boolean free) {
        this.isFree = free;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setTotalDownloadsCount(int totalDownloadsCount) {
        this.totalDownloadsCount = totalDownloadsCount;
    }

    public void setAvgRate(double avgRate) {
        this.avgRate = avgRate;
    }

    @Override
    public String toString() {
        return "song{" +
                "title='" + title + '\'' +
                ", artist='" + artist.getName() + '\'' +
                ", album='" + album + '\'' +
                ", genre='" + genre.getName() + '\'' +
                ", duration=" + duration +
                ", releaseDate='" + releaseDate + '\'' +
                ", lyrics='" + lyrics + '\'' +
                ", coverImageUrl='" + coverImageUrl + '\'' +
                ", songUrl='" + songUrl + '\'' +
                ", songId='" + songId + '\'' +
                '}';
    }
}