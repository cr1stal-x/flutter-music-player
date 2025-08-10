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
            case "login":login(command.get("username"), command.get("password"), cl);
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
            case "ChatWithAdmin": Object extraData = command.get("extraData");
                if(extraData instanceof Map){
                    String message = (String)((Map)extraData).get("message");
                    chatWithAdmin(cl, message);
                } else {
                    sendError(cl, "Invalid chat message");
                }
                 break;
            case "ForgetPassword": forgetPassword(cl); break;
            case "NewPlaylist": newPlaylist(cl, command.get("playlistName")); break;
            case "AddSong": addSong(cl, command.get("playlistId"), command.get("songId")); break;
            case "DeletePlaylist": deletePlaylist(cl, command.get("playlistId")); break;
            case "GetDownloadedSongs": getDownloadSongs(cl); break;

            case "GetAccountInfo": getAccountInfo(cl); break;
            default: sendError(cl, "Unknown method: " + method); break;
        }
    }

    private void sendError(ClientHandler cl, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 400);
        result.put("method", "error");
        result.put("message", message);
        cl.sendJson(gson.toJson(result));
    }

    public void logOut(ClientHandler cl) throws IOException {
        cl.id = 0;
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "logOut");
        cl.sendJson(gson.toJson(result));
    }

    public void signUp(String userName, String password, String email, ClientHandler cl) throws IOException {
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

    public void login(String userInput, String password, ClientHandler cl) throws IOException {
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

    public void update(ClientHandler cl, Object extraData) throws IOException {
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

    public void get(ClientHandler cl) throws IOException {
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

    public void delete(ClientHandler cl) throws IOException {
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

    public void getAccountInfo(ClientHandler cl) throws IOException {
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

    public void getServerSongs(ClientHandler cl) throws IOException {
        List<Map<String, Object>> songs = SQLManager.getServerSongs();
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getServerSongs");
        result.put("songs", songs);
        cl.sendJson(gson.toJson(result));
    }

    public void downloadSong(ClientHandler cl, int songId) throws IOException {
        if (cl.id <= 0) {
            sendError(cl, "not authenticated");
            return;
        }

        Map<String, Object> songdata = SQLManager.downloadSong(cl,songId);

        if (songdata.containsKey("error")) {
            sendError(cl, (String) songdata.get("error"));
            return;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "downloadBook");
        result.putAll(songdata);
        cl.sendJson(gson.toJson(result));
    }

    public void chatWithAdmin(ClientHandler cl, String message) throws IOException {
        Map<String, Object> msg = new HashMap<>();
        System.out.println(message);
        msg.put("method", "ChatWithAdmin");
        Scanner in=new Scanner(System.in);
        String response= in.nextLine();
        msg.put("response", response);
        cl.sendJson(gson.toJson(msg));
    }
    public void forgetPassword(ClientHandler cl) throws IOException {
        String newPassword=PasswordGenerator.generatePassword(8);
        System.out.println("\uD83D\uDCE4 new password: "+newPassword);
        boolean success = SQLManager.resetPassword(cl.id, newPassword);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", success ? 200 : 500);
        result.put("method", "ForgetPassword");
        result.put("message", success ? "Password reset successful" : "Reset failed");
        cl.sendJson(gson.toJson(result));
    }

    public void getDownloadSongs(ClientHandler cl) throws IOException {
        List<Map<String, Object>> songs = SQLManager.getDownloadedSongs(cl.id);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", 200);
        result.put("method", "getDownloadedSongs");
        result.put("songs", songs);
        cl.sendJson(gson.toJson(result));
    }

    public void newPlaylist(ClientHandler cl, String playlistName) throws IOException {
        boolean created = SQLManager.createPlaylist(cl.id, playlistName);
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", created ? 200 : 500);
        result.put("method", "newPlaylist");
        result.put("message", created ? "Playlist created" : "Error creating playlist");
        cl.sendJson(gson.toJson(result));
    }

    public void addSong(ClientHandler cl, String playlistId, String songId) throws IOException {
        boolean added = SQLManager.addSongToPlaylist(Integer.parseInt(playlistId), Integer.parseInt(songId));
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", added ? 200 : 500);
        result.put("method", "addSong");
        result.put("message", added ? "Song added" : "Failed to add");
        cl.sendJson(gson.toJson(result));
    }

    public void deletePlaylist(ClientHandler cl, String playlistId) throws IOException {
        boolean deleted = SQLManager.deletePlaylist(cl.id, Integer.parseInt(playlistId));
        Map<String, Object> result = new HashMap<>();
        result.put("status-code", deleted ? 200 : 500);
        result.put("method", "deletePlaylist");
        result.put("message", deleted ? "Deleted" : "Failed");
        cl.sendJson(gson.toJson(result));
    }
}
