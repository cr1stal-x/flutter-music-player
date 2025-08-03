package models;

public class Genre {

    private int genreId;
    private String name;
    private double totalRate;

    public Genre(int genreId, String name, double totalRate) {
        this.genreId = genreId;
        this.name = name;
        this.totalRate = totalRate;
    }

    public int getGenreId() {
        return genreId;
    }

    public String getName() {
        return name;
    }

    public double getTotalRate() {
        return totalRate;
    }

    public void setGenreId(int genreId) {
        this.genreId = genreId;
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