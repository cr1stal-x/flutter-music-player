import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import com.google.gson.Gson;

public class CommandManager {
    private final Gson gson = new Gson();

    public void getCommand(Map<String, Object> command, ClientHandler cl) throws IOException {
        String method = (String) command.get("method");
        Object extraData;
        switch (method) {
            case "LogOut": logOut(cl); break;
            case "SignUp":
                signUp((String) command.get("username"),
                        (String) command.get("password"),
                        (String) command.get("email"), cl);
                break;
            case "Update": update(cl, command.get("extraData")); break;
            case "login":
                login((String) command.get("username"), (String) command.get("password"), cl); break;
            case "Get": get(cl); break;
            case "Delete": delete(cl); break;
            case "DownloadSong":
                try {
                    extraData = command.get("extraData");
                    if(extraData instanceof Map){
                        Object songIdObj = ((Map) extraData).get("songId");
                        int songId;
                        if(songIdObj instanceof Number) songId = ((Number) songIdObj).intValue();
                        else songId = Integer.parseInt(songIdObj.toString());
                        downloadSong(cl, songId);
                    } else sendError(cl, "Invalid songId format");
                } catch (Exception e) {
                    sendError(cl, "Invalid songId format");
                }
                break;
            case "GetServerSongs": getServerSongs(cl); break;
            case "ChatWithAdmin":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String message = (String)((Map)extraData).get("message");
                    chatWithAdmin(cl, message);
                } else sendError(cl, "Invalid chat message");
                break;
            case "ForgetPassword":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String username = (String)((Map)extraData).get("username");
                    forgetPassword(cl, username);
                } else sendError(cl, "Invalid username");
                break;
            case "NewPlaylist":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String playlistName = (String)((Map)extraData).get("playlistName");
                    newPlaylist(cl, playlistName);
                } else sendError(cl, "Invalid playlist data");
                break;
            case "AddSong":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String username = (String) command.get("username");
                    int userId = SQLManager.getAccByUsername(username);
                    String playlistName = (String)((Map) extraData).get("playlistName");
                    double songId = ((Number)((Map) extraData).get("songId")).doubleValue();
                    int playlistId = SQLManager.getPlaylistId(userId, playlistName);
                    addSong(cl, playlistId, songId);
                } else sendError(cl, "Invalid song data");
                break;
            case "DeletePlaylist": deletePlaylist(cl, (String) command.get("playlistName")); break;
            case "GetPlaylists": getPlaylists(cl); break;
            case "GetPlaylistSongs":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String username = (String) command.get("username");
                    int userId = SQLManager.getAccByUsername(username);
                    String playlistName = (String)((Map) extraData).get("playlistName");
                    getPlaylistSongs(cl, playlistName, userId);
                } else sendError(cl, "Invalid playlist request");
                break;
            case "GetDownloadedSongs": getDownloadSongs(cl); break;
            case "GetAccountInfo": getAccountInfo(cl); break;

            // comment & rating
            case "AddComment":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    int songId = ((Number)((Map) extraData).get("songId")).intValue();
                    String comment = (String)((Map) extraData).get("comment");
                    addComment(cl, songId, comment);
                } else sendError(cl, "Invalid comment data");
                break;
            case "GetComments":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    int songId = ((Number)((Map) extraData).get("songId")).intValue();
                    getComments(cl, songId);
                } else sendError(cl, "Invalid comment request data");
                break;
            case "RateSong":
                extraData = command.get("extraData");
                if(extraData instanceof Map){
                    int songId = ((Number)((Map) extraData).get("songId")).intValue();
                    int rating = ((Number)((Map) extraData).get("rating")).intValue();
                    rateSong(cl, songId, rating);
                } else sendError(cl, "Invalid rating data");
                break;

            default: sendError(cl, "Unknown method: " + method); break;
        }
    }

    private void sendError(ClientHandler cl, String message) {
        Map<String,Object> res = new HashMap<>();
        res.put("status-code", 400);
        res.put("method", "error");
        res.put("message", message);
        cl.sendJson(gson.toJson(res));
    }

    private void logOut(ClientHandler cl) {
        cl.id = 0;
        Map<String,Object> res = new HashMap<>();
        res.put("status-code", 200);
        res.put("method", "logOut");
        cl.sendJson(gson.toJson(res));
    }

    public void signUp(String username, String password, String email, ClientHandler cl) {
        int status = SQLManager.signUp(username, password, email);
        Map<String,Object> res = new HashMap<>();
        if(status>0){
            cl.id = status;
            res.put("status-code", 200);
            res.put("method","signUp");
            res.put("message","authenticated");
        } else if(status==-1){
            res.put("status-code",400);
            res.put("method","signUp");
            res.put("message","user exists");
        } else{
            res.put("status-code",500);
            res.put("method","signUp");
            res.put("message","internal server error");
        }
        cl.sendJson(gson.toJson(res));
    }

    public void login(String username, String password, ClientHandler cl){
        int userId = SQLManager.login(username, password);
        Map<String,Object> res = new HashMap<>();
        res.put("method","login");

        if(userId>0){
            cl.id = userId;
            double credit = SQLManager.getCredit(userId);
            boolean isVip = SQLManager.getIsVip(userId);
            Map<String,Object> accountInfo = SQLManager.getAccountInfo(userId);
            res.put("status-code",200);
            res.put("user_id",userId);
            res.put("email",accountInfo.get("email"));
            res.put("credit",credit);
            res.put("isVip",isVip);
            res.put("profile_cover",accountInfo.get("profile_cover"));
        } else {
            res.put("status-code",401);
            res.put("message","Invalid username/email or password");
        }
        cl.sendJson(gson.toJson(res));
    }

    public void update(ClientHandler cl, Object extraData){
        Map<String,Object> res = new HashMap<>();
        res.put("method","update");
        if(cl.id<=0){ res.put("status-code",401); res.put("message","not authenticated"); cl.sendJson(gson.toJson(res)); return;}
        if(!(extraData instanceof Map)){ res.put("status-code",400); res.put("message","invalid format"); cl.sendJson(gson.toJson(res)); return;}
        int status = SQLManager.updateUser(cl.id,(Map<String,Object>)extraData);
        res.put("status-code",status);
        if(status!=200) res.put("message","update failed");
        cl.sendJson(gson.toJson(res));
    }

    public void get(ClientHandler cl){
        Map<String,Object> res = new HashMap<>();
        res.put("method","get");
        if(cl.id<=0){ res.put("status-code",401); res.put("message","not authenticated"); }
        else {
            String data = SQLManager.get(cl.id);
            if(data!=null && !data.equals("User not found")){ res.put("status-code",200); res.put("data",data);}
            else{ res.put("status-code",404); res.put("message","User not found");}
        }
        cl.sendJson(gson.toJson(res));
    }

    public void delete(ClientHandler cl){
        Map<String,Object> res = new HashMap<>();
        res.put("method","delete");
        if(cl.id<=0){ res.put("status-code",401); res.put("message","not authenticated"); }
        else{
            int status = SQLManager.delete(cl.id);
            res.put("status-code",status);
            if(status!=200) res.put("message","delete failed");
            else cl.id=0;
        }
        cl.sendJson(gson.toJson(res));
    }

    public void getAccountInfo(ClientHandler cl){
        if(cl.id<=0){ sendError(cl,"not authenticated"); return;}
        Map<String,Object> accountData = SQLManager.getAccountInfo(cl.id);
        if(accountData.isEmpty()){ sendError(cl,"User not found"); return;}
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","getAccountInfo");
        res.putAll(accountData);
        cl.sendJson(gson.toJson(res));
    }

    public void getServerSongs(ClientHandler cl){
        List<Map<String,Object>> songs = SQLManager.getServerSongs();
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","getServerSongs");
        res.put("songs",songs);
        cl.sendJson(gson.toJson(res));
    }

    public void downloadSong(ClientHandler cl, int songId){
        if(cl.id<=0){ sendError(cl,"not authenticated"); return;}
        Map<String,Object> songData = SQLManager.downloadSong(cl,songId);
        if(songData.containsKey("error")){ sendError(cl,(String)songData.get("error")); return;}
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","downloadSong");
        res.putAll(songData);
        cl.sendJson(gson.toJson(res));
    }

    public void chatWithAdmin(ClientHandler cl, String message){
        Map<String,Object> msg = new HashMap<>();
        msg.put("method","ChatWithAdmin");
        System.out.println(message);
        Scanner in = new Scanner(System.in);
        String response = in.nextLine();
        msg.put("response",response);
        cl.sendJson(gson.toJson(msg));
    }

    public void forgetPassword(ClientHandler cl, String username){
        Map<String,Object> res = new HashMap<>();
        int id = SQLManager.getAccByUsername(username);
        if(id!=-1){
            String newPass = PasswordGenerator.generatePassword(8);
            System.out.println("\uD83D\uDCE4 new password: "+newPass);
            boolean success = SQLManager.resetPassword(id,newPass);
            res.put("status-code", success?200:500);
            res.put("method","ForgetPassword");
            res.put("message", success?"Password reset successful":"Reset failed");
        } else{
            res.put("status-code",401);
            res.put("method","ForgetPassword");
            res.put("message","user not found.");
        }
        cl.sendJson(gson.toJson(res));
    }

    public void getDownloadSongs(ClientHandler cl){
        List<Map<String,Object>> songs = SQLManager.getDownloadedSongs(cl.id);
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","getDownloadedSongs");
        res.put("songs",songs);
        cl.sendJson(gson.toJson(res));
    }

    public void newPlaylist(ClientHandler cl, String playlistName){
        boolean created = SQLManager.createPlaylist(cl.id,playlistName);
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",created?200:500);
        res.put("method","newPlaylist");
        res.put("message",created?"Playlist created":"Error creating playlist");
        cl.sendJson(gson.toJson(res));
    }

    public void addSong(ClientHandler cl, int playlistId, double songId){
        boolean added = SQLManager.addSongToPlaylist(playlistId,songId);
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",added?200:500);
        res.put("method","addSong");
        res.put("message",added?"Song added":"Failed to add");
        cl.sendJson(gson.toJson(res));
    }

    public void deletePlaylist(ClientHandler cl, String playlistId){
        boolean deleted = SQLManager.deletePlaylist(cl.id,Integer.parseInt(playlistId));
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",deleted?200:500);
        res.put("method","deletePlaylist");
        res.put("message",deleted?"Deleted":"Failed");
        cl.sendJson(gson.toJson(res));
    }

    public void addComment(ClientHandler cl, int songId, String comment){
        if(cl.id<=0){ sendError(cl,"not authenticated"); return;}
        boolean success = SQLManager.addComment(songId,cl.id,comment);
        Map<String,Object> res = new HashMap<>();
        res.put("method","addComment");
        res.put("status-code",success?200:500);
        res.put("message",success?"Comment successfully added":"Failed to add comment");
        cl.sendJson(gson.toJson(res));
    }

    public void getComments(ClientHandler cl, int songId){
        List<Map<String,Object>> comments = SQLManager.getComments(songId);
        Map<String,Object> res = new HashMap<>();
        res.put("method","getComments");
        res.put("status-code",200);
        res.put("comments",comments);
        cl.sendJson(gson.toJson(res));
    }

    public void rateSong(ClientHandler cl, int songId, int rating){
        if(cl.id<=0){ sendError(cl,"not authenticated"); return;}
        boolean success = SQLManager.rateSong(songId, cl.id, rating);
        double avgRating = SQLManager.getAverageRating(songId);
        Map<String,Object> res = new HashMap<>();
        res.put("method","rateSong");
        res.put("status-code",success?200:500);
        res.put("message",success?"Rating updated":"Failed to rate");
        res.put("averageRating",avgRating);
        cl.sendJson(gson.toJson(res));
    }

    private void getPlaylistSongs(ClientHandler cl,String playlistName,int userId){
        List<Integer> songs = SQLManager.getPlaylistSongs(userId,playlistName);
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","getPlaylistSongs");
        res.put("songs",songs);
        cl.sendJson(gson.toJson(res));
    }

    private void getPlaylists(ClientHandler cl){
        List<Map<String,Object>> playlists = SQLManager.getPlaylists(cl.id);
        Map<String,Object> res = new HashMap<>();
        res.put("status-code",200);
        res.put("method","getPlaylists");
        res.put("playlists",playlists);
        cl.sendJson(gson.toJson(res));
    }
}
