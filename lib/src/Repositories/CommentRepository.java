package Repositories;

import models.Comment;
import models.Song;
import models.User;
import utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentRepository {

    public void addComment(Comment comment) {
        String sql = "INSERT INTO Comments (commentId, userUsername, songId, text, likes, dislikes) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getCommentId());
            ps.setString(2, comment.getUser().getUsername());
            ps.setInt(3, comment.getSong().getSongId());
            ps.setString(4, comment.getText());
            ps.setInt(5, comment.getLikes());
            ps.setInt(6, comment.getDislikes());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeComment(Comment comment) {
        String sql = "DELETE FROM Comments WHERE commentId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getCommentId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static Comment[] getCommentsBySong(Song song) {
        String sql = "SELECT * FROM Comments WHERE songId = ?";
        List<Comment> comments = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(3, song.getSongId());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String userUsername = rs.getString("userUsername");

                    User user = UserRepository.getUserByUsername(userUsername);

                    if (user != null) {
                        Comment c = new Comment(
                                rs.getInt("commentId"),
                                user,
                                song,
                                rs.getString("text"),
                                rs.getInt("likes"),
                                rs.getInt("dislikes")
                        );
                        c.setCommentId(rs.getInt("commentId"));
                        comments.add(c);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return comments.toArray(new Comment[0]);
    }

    public void likeComment(Comment comment) {
        String sql = "UPDATE Comments SET likes = likes + 1 WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getCommentId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void dislikeComment(Comment comment) {
        String sql = "UPDATE Comments SET dislikes = dislikes + 1 WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getCommentId());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean editComment(Comment c, String newText) {
        String sql = "UPDATE Comments SET text = ? WHERE commentId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(4, newText);
            ps.setInt(1, c.getCommentId());

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                c.setText(newText);
                System.out.println(c.getUser().getUsername() + " edited a comment to: " + newText);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
