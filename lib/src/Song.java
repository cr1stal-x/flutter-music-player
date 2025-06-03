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
    }
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
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof song)) return false;

        song song = (song) o;

        if (duration != song.duration) return false;
        if (!title.equals(song.title)) return false;
        if (!artist.equals(song.artist)) return false;
        if (!album.equals(song.album)) return false;
        if (!genre.equals(song.genre)) return false;
        if (!releaseDate.equals(song.releaseDate)) return false;
        if (!lyrics.equals(song.lyrics)) return false;
        if (!coverImageUrl.equals(song.coverImageUrl)) return false;
        if (!songUrl.equals(song.songUrl)) return false;
        return songId.equals(song.songId);
    }

}
