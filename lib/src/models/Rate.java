package models;

public class Rate {

    private int rateId;
    private int songID;
    private String userUsername;
    private int rate;

    public Rate(int rateId, int songID, String userUsername, int rate) {
        this.rateId = rateId;
        this.songID = songID;
        this.userUsername = userUsername;
        this.rate = rate;
    }

    public int getRateId() {
        return rateId;
    }

    public int getSongID() {
        return songID;
    }

    public String getUserUsername() {
        return userUsername;
    }

    public int getRate() {
        return rate;
    }

    public void setRateId(int rateId) {
        this.rateId = rateId;
    }

    public void setSongID(int songID) {
        this.songID = songID;
    }

    public void setUserUsername(String userUsername) {
        this.userUsername = userUsername;
    }

    public void setRate(int rate) {
        this.rate = rate;
    }
}