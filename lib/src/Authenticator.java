import java.util.Map;

public class Authenticator{
    public static int authenticate(Map<String,String> command, ClientHandler cl)throws Exception{
        int id=0;
        String method=command.get("method");
        if(method.equals("login")){
            id=SQLManager.login(command.get("userName"), command.get("password"));
        }
        else if(method.equals("signUp")){
            id=SQLManager.signUp(command.get("userName"),command.get("password"));
        }
        if(id!=0){
            cl.dos.writeBytes("authenticated");
            cl.dos.flush();
        }
        else{
            cl.dos.writeBytes("not authenticated");
            cl.dos.flush();
        }
        return id;
    }
}