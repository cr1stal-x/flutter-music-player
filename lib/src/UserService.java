import java.util.ArrayList;
import java.util.List;

public class UserSevice {
    private List<user> users;

    public UserSevice() {
        this.users = new ArrayList<>();
    }

    public void addUser(user newUser) {
        users.add(newUser);
    }

    public user getUserByUsername(String username) {
        for (user u : users) {
            if (u.getUsername().equals(username)) {
                return u;
            }
        }
        return null;
    }

    public List<user> getAllUsers() {
        return new ArrayList<>(users);
    }

    public void removeUser(String username) {
        users.removeIf(u -> u.getUsername().equals(username));
    }
    public void editUserName(user u, String name) {
        u.setName(name);
    }
    public void editUserUsername(user u, String username) {
        u.setUsername(username);
    }
    public void editUserPassword(user u, String password) {
        u.setPassword(password);
    }
    public void editUserEmail(user u, String email) {
        u.setEmail(email);
    }
    public void editUserProfile(user u, String profile) {
        u.setProfile(profile);
    }
    public void createPlayList(){
        //TODO
    }
    public void addSongToPlaylist(user u, song s) {
        //TODO
    }
    public void removeSongFromPlaylist(user u, song s) {
        //TODO
    }
    public void addSongToFavorites(user u, song s) {
        //TODO
        if (!u.getFavoriteSongs().contains(s)) {
            u.getFavoriteSongs().add(s);
        }
    }
    public void removeSongFromFavorites(user u, song s) {
        //TODO
        u.getFavoriteSongs().remove(s);
    }
    public List<song> getUserPlaylist(user u) {
        return u.getPlayList();
    }
    public List<song> getUserFavorites(user u) {
        return u.getFavoriteSongs();
    }
    public void clearUserPlaylist(user u) {
        u.getPlayList().clear();
    }
    public void clearUserFavorites(user u) {
        u.getFavoriteSongs().clear();
    }
    public boolean isFavorite(user u, song s) {
        return u.getFavoriteSongs().contains(s);
    }
}
