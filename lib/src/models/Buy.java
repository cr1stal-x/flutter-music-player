package models;

public class Buy {

    private int buyId;
    private Song song;
    private User user;

    public Buy(int buyId, Song song, User user) {
        this.buyId = buyId;
        this.song = song;
        this.user = user;
    }

    public int getBuyId() {
        return buyId;
    }

    public Song getSong() {
        return song;
    }

    public User getUser() {
        return user;
    }

    public void setBuyId(int buyId) {
        this.buyId = buyId;
    }

    public void setSong(Song song) {
        this.song = song;
    }

    public void setUser(User user) {
        this.user = user;
    }
}