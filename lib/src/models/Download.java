package models;

public class Download {

    private int downloadId;
    private Song song;
    private User user;

    public Download(int downloadId, Song song, User user) {
        this.downloadId = downloadId;
        this.song = song;
        this.user = user;
    }

    public int getDownloadId() {
        return downloadId;
    }

    public Song getSong() {
        return song;
    }

    public User getUser() {
        return user;
    }

    public void setDownloadId(int downloadId) {
        this.downloadId = downloadId;
    }

    public void setSong(Song song) {
        this.song = song;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
