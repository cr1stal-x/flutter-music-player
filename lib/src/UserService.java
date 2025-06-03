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
    public void createPlayList(user u, String name) {
        u.addPlayList(new PlayList(name));
    }
    public void addSongToPlaylist(user u, song s, PlayList playlist) {
        //TODO
        if (u.getPlayLists().contains(playlist)) {
            playlist.addSong(s);
        } else {
            System.out.println("Playlist not found for user " + u.getUsername());
        }
    }
    public void removeSongFromPlaylist(user u, song s, PlayList playlist) {
        //TODO
        if (u.getPlayLists().contains(playlist)) {
            playlist.removeSong(s);
        } else {
            System.out.println("Playlist not found for user " + u.getUsername());
        }

    }
    public void addSongToFavorites(user u, song s, PlayList favoriteSongs) {
        //TODO
        if (!u.getFavoriteSongs().getSongs().contains(s)) {
            favoriteSongs.addSong(s);
            u.getFavoriteSongs().getSongs().add(s);
        } else {
            System.out.println("Song already in favorites for user " + u.getUsername());
        }
    }
    public void removeSongFromFavorites(user u, song s) {
        //TODO
        u.getFavoriteSongs().getSongs().remove(s);
    }
    public List<PlayList> getUserPlaylists(user u) {
        return u.getPlayLists();
    }
    public List<song> getUserFavorites(user u) {
        return u.getFavoriteSongs().getSongs();
    }
    public void clearUserPlaylist(user u) {
        u.getPlayLists().clear();
    }
    public void clearUserFavorites(user u) {
        u.getFavoriteSongs().getSongs().clear();
    }
    public boolean isFavorite(user u, song s) {
        return u.getFavoriteSongs().getSongs().contains(s);
    }
    public void vipCredit(user u){
        u.setVip(true);
    }
    public void removeVipCredit(user u){
        u.setVip(false);
    }
    public boolean isVip(user u) {
        return u.getVip();
    }
    public void increaseCredit(user u, int amount) {
        //TODO
        u.setCredit(u.getCredit() + amount);
    }
    public void decreaseCredit(user u, int amount) {
        //TODO
        u.setCredit(u.getCredit() - amount);
    }
    public double getUserCredit(user u) {
        return u.getCredit();
    }
    public void setUserCredit(user u, double credit) {
        u.setCredit(credit);
    }
    public void resetUserPassword(user u, String newPassword) {
        u.setPassword(newPassword);
    }
    public void recoverUserPassword(user u) {
        u.setPassword("defaultPassword123");
        System.out.println("Password recovery instructions sent to " + u.getEmail());
    }

}
