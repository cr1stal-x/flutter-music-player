package models;

public class PlayList {
    private int playlistId;
    private User user;
    private String name;
    private boolean isFavorite;

    public PlayList(User user) {
        this.playlistId = 0;
        this.name = "Default Playlist";
        this.user = user;
        this.isFavorite = false;
    }

    public PlayList(int playlistId, User user, String name, boolean isFavorite) {
        this.playlistId = playlistId;
        this.user = user;
        this.name = name;
        this.isFavorite = isFavorite;
    }

    public int getPlaylistId() {
        return playlistId;
    }

    public User getUser() {
        return user;
    }

    public String getName() {
        return name;
    }

    public boolean getIsFavorite() {
        return isFavorite;
    }

    public void setPlaylistId(int playlistId) {
        this.playlistId = playlistId;
    }

    public void setUser(User userUsername) {
        this.user = userUsername;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setIsFavorite(boolean isFavorite) {
        this.isFavorite = isFavorite;
    }

    @Override
    public String toString() {
        return "models.PlayList{" +
                "name='" + name +
                '}';
    }
}