import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import com.google.gson.Gson;

public class CommandManager {
    private final Gson gson = new Gson();

    public void getCommand(Map<String, String> command, ClientHandler cl) throws IOException {
        String method = command.get("method");
        switch (method) {
            case "LogOut": logOut(cl); break;
            case "SignUp": signUp(command.get("username"), command.get("password"),command.get("email"), cl); break;
            case "Update": update(cl, command.get("extraData")); break;
            case "login": login(command.get("username"), command.get("password"), cl);break;
            case "Get": get(cl); break;
            case "Delete": delete(cl); break;
            case "DownloadSong":
                try {

                    Object dataObj = command.get("extraData");
                    Map<String, Object> data = (Map<String, Object>) dataObj;
                    Object songIdObj=data.get("songId");
                    int songId;
                    if (songIdObj instanceof Number) {
                        songId = ((Number) songIdObj).intValue();
                    } else if (songIdObj instanceof String) {
                        songId = Integer.parseInt((String) songIdObj);
                    } else {
                        sendError(cl, "Invalid songId type");
                        return;
                    }
                    downloadSong(cl, songId);
                } catch (NumberFormatException e) {
                    sendError(cl, "Invalid songId format");
                }
            break;
            case "GetServerSongs": getServerSongs(cl); break;
            case "getCategories": getCategories(cl); break;
            case "ChatWithAdmin": Object extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String message = (String)((Map)extraData).get("message");
                    chatWithAdmin(cl, message);
                } else {
                    sendError(cl, "Invalid chat message");
                }
                 break;
            case "ForgetPassword": extraData=command.get("extraData");
                if(extraData instanceof Map){
                    String username = (String)((Map)extraData).get("username");
                    forgetPassword(cl, username);
                } else {
                    sendError(cl, "Invalid username");
                } break;

            case "NewPlaylist":extraData=command.get("extraData");
                if(extraData instanceof Map){
                    String playlistName = (String)((Map)extraData).get("playlistName");
                    newPlaylist(cl,playlistName);
                } else {
                    sendError(cl, "Invalid username");
                } break;
            case "AddSong":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    Map<?, ?> dataMap = (Map<?, ?>) extraData;
                    Object playlistNameObj = dataMap.get("playlistName");
                    Object songIdObj = dataMap.get("songId");

                    if(playlistNameObj != null && songIdObj != null){
                        String username = command.get("username");
                        int userId = SQLManager.getAccByUsername(username);
                        String playlistName = playlistNameObj.toString();
                        int playlistId = SQLManager.getPlaylistId(userId, playlistName);
                        double songId = ((Number) songIdObj).doubleValue();
                        addSong(cl, playlistId, songId);
                    } else {
                        sendError(cl, "Missing playlistName or songId");
                    }
                } else {
                    sendError(cl, "Invalid extraData format");
                }
                break;

            case "DeletePlaylist": deletePlaylist(cl, command.get("playlistName")); break;
            case "GetPlaylists":getPlaylists(cl);break;
            case "GetPlaylistSongs":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    Map<?, ?> dataMap = (Map<?, ?>) extraData;
                    Object playlistNameObj = dataMap.get("playlistName");

                    if(playlistNameObj != null){
                        String username = command.get("username");
                        int userId = SQLManager.getAccByUsername(username);
                        String playlistName = playlistNameObj.toString();
                        getPlaylistSongs(cl, playlistName, userId);
                    } else {
                        sendError(cl, "Missing playlistName");
                    }
                } else {
                    sendError(cl, "Invalid extraData format");
                }
                break;

            case "DeleteSong":
                extraData=command.get("extraData");
                if(extraData instanceof Map){
                    String username=command.get("username");
                    int userId=SQLManager.getAccByUsername(username);
                    String playlistName = (String)((Map)extraData).get("playlistName");
                    double songId=(double)((Map)extraData).get("songId");
                    int playlistId=SQLManager.getPlaylistId(userId,playlistName);
                    deleteSong(cl,playlistId,songId);
                } else {
                    sendError(cl, "Invalid username");
                }
                break;
            case "GetDownloadedSongs": getDownloadSongs(cl); break;
            case "GetAccountInfo": getAccountInfo(cl); break;
            case "rate": extraData=command.get("extraData");
                if(extraData instanceof Map){
                    double songId = (double)((Map)extraData).get("songId");
                    double rating=(double) ((Map)extraData).get("rating");
                    rate(cl, rating, songId);
                } else {
                    sendError(cl, "Invalid username");
                }
                break;
            case "getRating":
                extraData=command.get("extraData");
                if(extraData instanceof Map){
                    double songId = (double)((Map)extraData).get("songId");
                    getRating(cl,songId);
                } else {
                    sendError(cl, "Invalid");
                }
                break;
            case "getComments":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    Map<?, ?> dataMap = (Map<?, ?>) extraData;
                    Object songIdObj = dataMap.get("songId");
                    if(songIdObj != null){
                        double songId = ((Number) songIdObj).doubleValue();
                        getComments(cl, songId);
                    } else {
                        sendError(cl, "Missing songId");
                    }
                } else {
                    sendError(cl, "Invalid extraData format");
                }
                break;

            case "addComment":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    Map<?, ?> dataMap = (Map<?, ?>) extraData;
                    Object songIdObj = dataMap.get("songId");
                    Object commentObj = dataMap.get("comment");

                    if(songIdObj != null && commentObj != null){
                        double songId = ((Number) songIdObj).doubleValue();
                        String username = command.get("username");
                        String text = commentObj.toString();
                        addComment(cl, songId, username, text);
                    } else {
                        sendError(cl, "Missing songId or comment");
                    }
                } else {
                    sendError(cl, "Invalid extraData format");
                }
                break;


            case "likeComment":
                extraData = command.get("extraData");
                if (extraData instanceof Map) {
                    double commentId = (double) ((Map) extraData).get("commentId");
                    likeComment(cl, commentId);
                } else {
                    sendError(cl, "Invalid");
                }
                break;

            case "dislikeComment":
                extraData = command.get("extraData");
                if (extraData instanceof Map) {
                    double commentId = (double) ((Map) extraData).get("commentId");
                    dislikeComment(cl, commentId);
                } else {
                    sendError(cl, "Invalid");
                }
                break;
            case "updateComment":
                extraData = command.get("extraData");
                if (extraData instanceof Map) {
                    double commentId = (double) ((Map) extraData).get("commentId");
                    String newContent=(String)((Map) extraData).get("newContent");
                    updateComment(commentId,newContent,cl);
                } else {
                    sendError(cl, "Invalid");
                }
                break;
            case "deleteComment":
                extraData = command.get("extraData");
                if (extraData instanceof Map) {
                    double commentId = (double) ((Map) extraData).get("commentId");
                    String username=command.get("username");
                    int id=SQLManager.getAccByUsername(username);
                    deleteComment(cl,commentId,id);
                } else {
                    sendError(cl, "Invalid");
                }
                break;
            default: sendError(cl, "Unknown method: " + method); break;
        }
    }

    private void deleteSong(ClientHandler cl, int playlistId, double songId) {
        boolean deleted = SQLManager.deleteSong(playlistId, songId);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", deleted ? 200 : 500);
        result.put("method", "DeleteSong");
        result.put("message", deleted ? "Song deleted" : "Failed to delete");
        System.out.println(result);
        cl.sendJson(gson.toJson(result));
    }

    private void updateComment(double commentId, String newContent,ClientHandler cl) {
        boolean success = SQLManager.updateCommentContent((int) commentId,cl.id,newContent);
        Map<String, Object> result = new HashMap<>();
        result.put("method", "updateComment");
        if (success) {
            result.put("status-code", 200);
            result.put("message", "updated");
        } else {
            result.put("status-code", 500);
            result.put("message", "Failed");
        }
        cl.sendJson(gson.toJson(result));
    }

    private void getCategories(ClientHandler cl) {
        List<String> categ=SQLManager.getCategories();
        Map<String, Object> result = new HashMap<>();
        result.put("method", "getCategories");
        if (!categ.isEmpty()) {
            result.put("categories",categ);
            result.put("status-code", 200);
            result.put("message", "successfully");
        } else {
            result.put("status-code", 500);
            result.put("message", "Failed");
        }
        cl.sendJson(gson.toJson(result));
    }

    private void addComment(ClientHandler cl, double songId, String username, String text) {
        int userId = SQLManager.getAccByUsername(username);
        boolean success = SQLManager.addComment((int)songId, userId, text);

        Map<String, Object> result = new HashMap<>();
        result.put("method", "addComment");
        if (success) {
            result.put("status-code", 200);
            result.put("message", "Comment added successfully");
        } else {
            result.put("status-code", 500);
            result.put("message", "Failed to add comment");
        }
        cl.sendJson(gson.toJson(result));
    }

    private void likeComment(ClientHandler cl, double commentId) {
        boolean success = SQLManager.likeComment((int) commentId);

        Map<String, Object> result = new HashMap<>();
        result.put("method", "likeComment");
        if (success) {
            result.put("status-code", 200);
            result.put("message", "Comment liked");
        } else {
            result.put("status-code", 500);
            result.put("message", "Failed to like comment");
        }
        cl.sendJson(gson.toJson(result));
    }

    private void dislikeComment(ClientHandler cl, double commentId) {
        boolean success = SQLManager.dislikeComment((int) commentId);

        Map<String, Object> result = new HashMap<>();
        result.put("method", "dislikeComment");
        if (success) {
            result.put("status-code", 200);
            result.put("message", "Comment disliked");
        } else {
            result.put("status-code", 500);
            result.put("message", "Failed to dislike comment");
        }
        cl.sendJson(gson.toJson(result));
    }

    private void getComments(ClientHandler cl, double songId) {
        List<Map<String, Object>>comments = SQLManager.getComments((int)songId); // implement this helper
        Map<String, Object> result = new HashMap<>();
        result.put("method", "getComments");
        result.put("status-code", 200);
        result.put("comments", comments);
        cl.sendJson(gson.toJson(result));
    }

    private void getPlaylistSongs(ClientHandler cl,String playlistName, int userId) {
        List<Integer> songs = SQLManager.getPlaylistSongs(userId,playlistName);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getPlaylistSongs");
        result.put("songs", songs);
        cl.sendJson(gson.toJson(result));
    }

    private void getPlaylists(ClientHandler cl) {
        List<Map<String, Object>> playlists = SQLManager.getPlaylists(cl.id);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getPlaylists");
        result.put("playlists", playlists);
        cl.sendJson(gson.toJson(result));
    }

    private void sendError(ClientHandler cl, String message)  {
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 400);
        result.put("method", "error");
        result.put("message", message);
        cl.sendJson(gson.toJson(result));
    }

    public void logOut(ClientHandler cl)  {
        cl.id = 0;
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "logOut");
        cl.sendJson(gson.toJson(result));
    }

    public void signUp(String userName, String password, String email, ClientHandler cl)  {
        int status = SQLManager.signUp(userName, password, email);
        Map<String, Object> result = new HashMap<>();
        if (status > 0) {
            cl.id = status;
            result.put("status-code", 200);
            result.put("method", "signUp");
            result.put("message", "authenticated");
        } else if (status == -1) {
            result.put("status-code", 400);
            result.put("method", "signUp");
            result.put("message", "user exists");
        } else {
            result.put("status-code", 500);
            result.put("method", "signUp");
            result.put("message", "internal server error");
        }
        cl.sendJson(gson.toJson(result));
    }

    public void login(String userInput, String password, ClientHandler cl){
        int userId = SQLManager.login(userInput, password);

        Map<String, Object> result = new HashMap<>();
        result.put("method", "login");

        if (userId > 0) {
            cl.id = userId;
            double credit = SQLManager.getCredit(userId);
            boolean isVip = SQLManager.getIsVip(userId);
            Map<String,Object>accountInfo=SQLManager.getAccountInfo(userId);
            System.out.println(accountInfo);
            String email= (String) accountInfo.get("email");
            String profileCover=(String) accountInfo.get("profile_cover");

            result.put("status-code", 200);
            result.put("user_id", userId);
            result.put("email",email);
            result.put("credit", credit);
            result.put("isVip", isVip);
            result.put("profile_cover", profileCover);
            System.out.println(result);
        } else {
            result.put("status-code", 401);
            result.put("message", "Invalid username/email or password");
        }

        cl.sendJson(gson.toJson(result));
    }

    public void update(ClientHandler cl, Object extraData)  {
        Map<String, Object> result = new HashMap<>();
        result.put("method", "update");

        if (cl.id <= 0) {
            result.put("status-code", 401);
            result.put("message", "not authenticated");
            cl.sendJson(gson.toJson(result));
            return;
        }

        if (!(extraData instanceof Map)) {
            result.put("status-code", 400);
            result.put("message", "invalid format");
            cl.sendJson(gson.toJson(result));
            return;
        }

        Map<String, Object> updates = (Map<String, Object>) extraData;

        int status = SQLManager.updateUser(cl.id, updates);
        result.put("status-code", status);

        if (status != 200) {
            result.put("message", "update failed");
        }
        cl.sendJson(gson.toJson(result));
    }

    public void get(ClientHandler cl)  {
        Map<String, Object> result = new HashMap<>();
        if (cl.id <= 0) {
            result.put("status-code", 401);
            result.put("method", "get");
            result.put("message", "not authenticated");
        } else {
            String data = SQLManager.get(cl.id);
            if (data != null && !data.equals("User not found")) {
                result.put("data", data);
                result.put("status-code", 200);
            } else {
                result.put("status-code", 404);
                result.put("message", "User not found");
            }
            result.put("method", "get");
        }
        cl.sendJson(gson.toJson(result));
    }

    public void delete(ClientHandler cl)  {
        Map<String, Object> result = new HashMap<>();
        if (cl.id <= 0) {
            result.put("status-code", 401);
            result.put("method", "delete");
            result.put("message", "not authenticated");
        } else {
            int status = SQLManager.delete(cl.id);
            result.put("status-code", status);
            result.put("method", "delete");
            if (status != 200) {
                result.put("message", "delete failed");
            } else {
                cl.id = 0;
            }
        }
        cl.sendJson(gson.toJson(result));
    }

    public void getAccountInfo(ClientHandler cl) {
        if (cl.id <= 0) {
            sendError(cl, "not authenticated");
            return;
        }
        Map<String, Object> accountData = SQLManager.getAccountInfo(cl.id);
        if (accountData.isEmpty()) {
            sendError(cl, "User not found");
            return;
        }
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getAccountInfo");
        result.putAll(accountData);
        cl.sendJson(gson.toJson(result));
    }

    public void getServerSongs(ClientHandler cl)  {
        List<Map<String, Object>> songs = SQLManager.getServerSongs();
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getServerSongs");
        result.put("songs", songs);
        cl.sendJson(gson.toJson(result));
    }

    public void downloadSong(ClientHandler cl, int songId){
        if (cl.id <= 0) {
            sendError(cl, "not authenticated");
            return;
        }

        Map<String, Object> songdata = SQLManager.downloadSong(cl,songId);

        if (songdata.containsKey("error")) {
            sendError(cl, (String) songdata.get("error"));
            return;
        }
        if(songdata.containsKey("message")){
            sendError(cl,(String) songdata.get("message"));
        }

        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "downloadBook");
        result.putAll(songdata);
        cl.sendJson(gson.toJson(result));
    }

    public void chatWithAdmin(ClientHandler cl, String message)  {
        Map<String, Object> msg = new HashMap<>();
        System.out.println(message);
        msg.put("method", "ChatWithAdmin");
        Scanner in=new Scanner(System.in);
        String response= in.nextLine();
        msg.put("response", response);
        cl.sendJson(gson.toJson(msg));
    }

    public void forgetPassword(ClientHandler cl, String username) {
        Map<String, Object> result = new HashMap<>();
        int id=SQLManager.getAccByUsername(username);
        if(id!=-1){
            String newPassword=PasswordGenerator.generatePassword(8);
            System.out.println("\uD83D\uDCE4 new password: "+newPassword);
            boolean success = SQLManager.resetPassword(id, newPassword);
            result.put("status-code", success ? 200 : 500);
            result.put("method", "ForgetPassword");
            result.put("message", success ? "Password reset successful" : "Reset failed");
    }
        else{
            result.put("status-code", 401);
            result.put("method", "ForgetPassword");
            result.put("message", "user not found.");
        }
        cl.sendJson(gson.toJson(result));
    }

    public void getDownloadSongs(ClientHandler cl)  {
        List<Map<String, Object>> songs = SQLManager.getDownloadedSongs(cl.id);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getDownloadedSongs");
        result.put("songs", songs);
        cl.sendJson(gson.toJson(result));
    }

    public void newPlaylist(ClientHandler cl, String playlistName)  {
        boolean created = SQLManager.createPlaylist(cl.id, playlistName);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", created ? 200 : 500);
        result.put("method", "newPlaylist");
        result.put("message", created ? "Playlist created" : "Error creating playlist");
        cl.sendJson(gson.toJson(result));
    }

    public void addSong(ClientHandler cl, int playlistId, double songId)  {
        boolean added = SQLManager.addSongToPlaylist(playlistId, songId);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", added ? 200 : 500);
        result.put("method", "addSong");
        result.put("message", added ? "Song added" : "Failed to add");
        cl.sendJson(gson.toJson(result));
    }

    public void deletePlaylist(ClientHandler cl, String playlistId)  {
        boolean deleted = SQLManager.deletePlaylist(cl.id, Integer.parseInt(playlistId));
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", deleted ? 200 : 500);
        result.put("method", "deletePlaylist");
        result.put("message", deleted ? "Deleted" : "Failed");
        cl.sendJson(gson.toJson(result));
    }

    public void rate(ClientHandler cl, double rating, double songId){
        boolean rated=SQLManager.rate(songId,rating);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", rated ? 200 : 500);
        result.put("method", "rate");
        result.put("message", rated ? "rated" : "Failed");
        cl.sendJson(gson.toJson(result));

    }

    public void getRating(ClientHandler cl,double songId){
        Map<String, Object> ratings=SQLManager.getRating(songId);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", !ratings.isEmpty() ? 200 : 500);
        result.put("rate",ratings);
        result.put("method", "getRating");
        cl.sendJson(gson.toJson(result));
    }

    public void deleteComment(ClientHandler cl, double commentId, double id){
        boolean success=SQLManager.deleteComment((int) commentId, (int)id);
            Map<String, Object> result = new HashMap<>();
            result.put("status-code", success ? 200 : 500);
            result.put("method", "deletePlaylist");
            result.put("message", success ? "Deleted" : "Failed");
            cl.sendJson(gson.toJson(result));
    }
}
