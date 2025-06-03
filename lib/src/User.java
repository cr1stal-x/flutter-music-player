import java.util.List;

public class user {
    String name;
    String usaername;
    String password;
    String email;
    String profile;
    List<song> playList;
    List<song> favoriteSongs;

    public user(String name, String username, String password, String email) {
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
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof user)) return false;

        user user = (user) o;

        if (!name.equals(user.name)) return false;
        if (!usaername.equals(user.usaername)) return false;
        if (!password.equals(user.password)) return false;
        return email.equals(user.email);
    }
    public List<song> getPlayList() {
        return playList;
    }
    public List<song> getFavoriteSongs() {
        return favoriteSongs;
    }
}
