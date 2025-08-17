import java.util.HashMap;
import java.util.Map;

public class Authenticator {

    public static int authenticate(Map<String, String> command, ClientHandler cl) throws Exception {
        int id = 0;
        String method = command.get("method");

        Map<String, Object> response = new HashMap<>();
        response.put("method", method);

        if("login".equals(method)) {
            id = SQLManager.login(command.get("userName"), command.get("password"));

            if(id > 0) {
                Map<String, Object> userData = SQLManager.getUserById(id);

                response.put("status-code", 200);
                response.put("message", "authenticated");
                response.put("user", userData);
            } else {
                response.put("status-code", 401);
                response.put("message", "invalid username or password");
            }

        } else if("signUp".equals(method)) {
            //profile picture??
            String profileCover = command.getOrDefault("profileCover", "default_base64");

            id = SQLManager.signUp(
                    command.get("userName"),
                    command.get("password"),
                    command.get("email"),
                    profileCover
            );

            if(id > 0) {
                response.put("status-code", 200);
                response.put("message", "user created successfully");
                response.put("userId", id);
            } else {
                response.put("status-code", 400);
                response.put("message", "signup failed (username may already exist)");
            }

        } else {
            response.put("status-code", 400);
            response.put("message", "unsupported method: " + method);
        }

        cl.sendJson(cl.gson.toJson(response));
        return id;
    }
}
