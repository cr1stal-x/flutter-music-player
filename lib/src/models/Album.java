package models;

public class Album {

    private int albumId;
    private String name;
    private Artist artist;

    public Album(int albumId, String name, Artist artist) {
        this.albumId = albumId;
        this.name = name;
        this.artist = artist;
    }

    public int getAlbumId() {
        return albumId;
    }

    public String getName() {
        return name;
    }

    public Artist getArtist() {
        return artist;
    }

    public void setAlbumId(int albumId) {
        this.albumId = albumId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }
}