package Services;

import Repositories.CommentRepository;
import models.Comment;
import models.Song;
import models.User;

public class CommentService {

    private final CommentRepository commentRepository;

    public CommentService() {
        this.commentRepository = new CommentRepository();
    }

    public void addComment(Comment comment) {
        commentRepository.addComment(comment);
    }

    public void removeComment(Comment comment) {
        commentRepository.removeComment(comment);
    }

    public Comment[] getCommentsBySong(Song song) {
        return CommentRepository.getCommentsBySong(song);
    }

    public void likeComment(Comment comment) {
        commentRepository.likeComment(comment);
        comment.setLikes(comment.getLikes() + 1);
    }

    public void dislikeComment(Comment comment) {
        commentRepository.dislikeComment(comment);
        comment.setDislikes(comment.getDislikes() + 1);
    }

    public boolean editComment(Comment comment, String editedText, User user) {
        if(comment.getUser() != user) {
            System.out.println("You can't edit others comments!");
            return false;
        }
        commentRepository.editComment(comment, editedText);
        return true;
    }
}
