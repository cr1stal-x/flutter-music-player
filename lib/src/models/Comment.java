package models;

public class Comment {
    private int commentId;
    private User user;
    private Song song;
    private String text;
    private int likes;
    private int dislikes;

    public Comment(int commentId, User user, Song song, String text, int likes, int dislikes) {
        this.commentId = commentId;
        this.user = user;
        this.song = song;
        this.text = text;
        this.likes = likes;
        this.dislikes = dislikes;
    }

    public int getCommentId() {
        return commentId;
    }

    public String getText() {
        return text;
    }

    public int getLikes() {
        return likes;
    }

    public int getDislikes() {
        return dislikes;
    }

    public User getUser() {
        return user;
    }

    public Song getSong() {
        return song;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public void setText(String text) {
        this.text = text;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public void setDislikes(int dislikes) {
        this.dislikes = dislikes;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setSong(Song song) {
        this.song = song;
    }

    @Override
    public String toString() {
        return "comment{" +
                "idea='" + text + '\'' +
                ", likes='" + likes + '\'' +
                ", dislikes='" + dislikes + '\'' +
                ", who said='" + user.getUsername() + '\'' +
                '}';
    }
}