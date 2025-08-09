import java.util.ArrayList;
import java.util.List;

public class PlayList {
    private String name;
    private List<song> songs;

    public PlayList() {
        this.name = "Default Playlist";
        this.songs = new ArrayList<>();
    }
    public PlayList(String name) {
        this.name = name;
        this.songs = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<song> getSongs() {
        return songs;
    }

    public void addSong(song s) {
        if (!songs.contains(s)) {
            songs.add(s);
        }
    }

    public void removeSong(song s) {
        songs.remove(s);
    }
    public void clearSongs() {
        songs.clear();
    }
    public boolean containsSong(song s) {
        return songs.contains(s);
    }
    public int getSongCount() {
        return songs.size();
    }

    @Override
    public String toString() {
        return "PlayList{" +
                "name='" + name + '\'' +
                ", songs=" + songs +
                '}';
    }
}
