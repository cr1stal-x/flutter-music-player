import java.util.Date;

public class Comment {
    private int commentId;
    private int songId;
    private int userId;
    private String content;
    private Date createdAt;
    private int likes;
    private int dislikes;

    public Comment(int commentId, int songId, int userId, String content, Date createdAt) {
        this.commentId = commentId;
        this.songId = songId;
        this.userId = userId;
        this.content = content;
        this.createdAt = createdAt;
        this.likes = 0;
        this.dislikes = 0;
    }

    public int getCommentId() {
        return commentId;
    }

    public int getSongId() {
        return songId;
    }

    public int getUserId() {
        return userId;
    }

    public String getContent() {
        return content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public int getLikes() {
        return likes;
    }

    public int getDislikes() {
        return dislikes;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void like() {
        likes++;
    }

    public void dislike() {
        dislikes++;
    }

    @Override
    public String toString() {
        return "Comment ID: " + commentId +
                ", Song ID: " + songId +
                ", User ID: " + userId +
                ", Content: " + content +
                ", Created At: " + createdAt +
                ", Likes: " + likes +
                ", Dislikes: " + dislikes;
    }
}
