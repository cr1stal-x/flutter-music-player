import java.io.IOException;
import java.util.Map;

public class CommandManager {
    public void getCommand(Map<String,String> command, ClientHandler cl) throws IOException{
        switch (command.get("method")) {
            case "logout":
                logOut(cl);
                break;
            case "signUp":
                signUp(command.get("userName"),command.get("password") ,cl);
                break;
            case "update":
                update(cl, command.get("data"));
                break;
            case "get":
                get(cl);
                break;
            case "delete":
                delete(cl);
                break;

            default:
                break;
        }
    }
    public void logOut(ClientHandler cl) throws IOException{
        cl.id=0;
        String result="{"
                +"\"status-code\":\""+"200\""
                +"\"method\":"+"\"logOut\""
                +"}";
        cl.sendJson(result);
        cl.closeConnection();
    }
    public void signUp(String userName,String password, ClientHandler cl) throws IOException{
        int status=SQLManager.signUp(userName,password);
        String result="{"
                +"\"status-code\":\""+status+"\","
                +"\"method\":"+"\"signUp\""
                +"}";
        cl.sendJson(result);
        if(status==400){
            cl.dos.flush();
            cl.dos.close();
            cl.dis.close();
            cl.clientSocket.close();
        }

    }
    public void update(ClientHandler cl,String data) throws IOException{
        int status=SQLManager.update(cl.id, data);
        String result="{"
                +"\"status-code\":\""+status+"\","
                +"\"method\":"+"\"update\""
                +"}";
        cl.sendJson(result);

    }
    public void get(ClientHandler cl) throws IOException{
        String data=SQLManager.get(cl.id);
        int status=404;
        if(data!=null){
            status=200;
        }
        String result="{"
                +"\"data\":\""+data+"\","
                +"\"status-code\":\""+status+ "\","
                +"\"method\":"+"\"get\""
                +"}";
        cl.sendJson(result);
    }
    public void delete(ClientHandler cl) throws IOException{
        int status=SQLManager.delete(cl.id);
        String result="{"
                +"\"status-code\":\""+status+"\","
                +"\"method\":"+"\"delete\""
                +"}";
        cl.sendJson(result);
        if(status==200){
            cl.closeConnection();
        }
    }

}
