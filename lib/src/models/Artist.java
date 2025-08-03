package models;

public class Artist {

    private int artistId;
    private String name;
    private double totalRate;

    public Artist(int artistId, String name, double totalRate) {
        this.artistId = artistId;
        this.name = name;
        this.totalRate = totalRate;
    }

    public int getArtistId() {
        return artistId;
    }

    public String getName() {
        return name;
    }

    public double getTotalRate() {
        return totalRate;
    }

    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTotalRate(double totalRate) {
        this.totalRate = totalRate;
    }

    @Override
    public String toString() {
        return this.name;
    }
}