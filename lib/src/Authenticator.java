import java.util.HashMap;
import java.util.Map;


public class Authenticator {

    public static int authenticate(Map<String, String> command, ClientHandler cl) throws Exception {
        int id = 0;
        String method = command.get("method");

        if ("login".equals(method)) {
            id = SQLManager.login(command.get("userName"), command.get("password"));
        } else if ("signUp".equals(method)) {
            id = SQLManager.signUp(command.get("userName"), command.get("password"), command.get("email"));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("method", method);
        if (id > 0) {
            response.put("status-code", 200);
            response.put("message", "authenticated");
        } else {
            response.put("status-code", 401);
            response.put("message", "not authenticated");
        }

        cl.sendJson(cl.gson.toJson(response));
        return id;
    }
}
