import java.util.ArrayList;
import java.util.List;

public class user {
    String name;
    String usaername;
    String password;
    String email;
    String profile;
    List<PlayList> playLists;
    PlayList favoriteSongs;
    boolean isVip;
    double credit;
    List<song> downloadedSongs;

    public user(String name, String username, String password, String email) {
        playLists=new ArrayList<>();
        favoriteSongs= new PlayList("Favorites");
        credit = 0.0;
        downloadedSongs = new ArrayList<>();
        this.profile = "default";
        this.isVip = false;
        this.name = name;
        this.usaername = username;
        this.password = password;
        this.email = email;
    }
    public String getName() {
        return name;
    }
    public String getUsername() {
        return usaername;
    }
    public String getPassword() {
        return password;
    }
    public String getEmail() {
        return email;
    }
    public String getProfile() {
        return profile;
    }
    public void setProfile(String profile) {
        this.profile = profile;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void setUsername(String username) {
        this.usaername = username;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    @Override
    public String toString() {
        return "user{" +
                "name='" + name + '\'' +
                ", username='" + usaername + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
    public List<PlayList> getPlayLists() {
        return playLists;
    }
    public PlayList getFavoriteSongs() {
        return favoriteSongs;
    }
    public boolean getVip(){
        return isVip;
    }
    public void setVip(boolean b){
        isVip=b;
    }
    public double getCredit() {
        return credit;
    }
    public void setCredit(double credit) {
        this.credit = credit;
    }
    public List<song> getDownloadedSongs() {
        return downloadedSongs;
    }
    public void addPlayList(PlayList playList) {
        playLists.add(playList);
    }
    public void removePlayList(PlayList playList) {
        playLists.remove(playList);
    }
    public void addDownloadedSong(song s) {
        if (!downloadedSongs.contains(s)) {
            downloadedSongs.add(s);
        }
    }
}
