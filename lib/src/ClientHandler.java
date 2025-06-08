import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

class ClientHandler implements Runnable {
    int id = 0;
    private volatile boolean isRunning = true;
    public final Socket clientSocket;
    DataOutputStream dos;
    DataInputStream dis;

    public ClientHandler(Socket clientSocket) throws IOException {
        this.clientSocket = clientSocket;
        dos = new DataOutputStream(clientSocket.getOutputStream());
        dis = new DataInputStream(clientSocket.getInputStream());
        System.out.println("Connected to the server.");
    }

    public void sendJson(String json) throws IOException {
        dos.write(json.getBytes());
        dos.flush();
    }

    public Map<String, String> readJson() throws IOException {
        StringBuilder sb = new StringBuilder();
        int index=dis.read();
        while(index!=48){
            sb.append((char)index);
            index=dis.read();
        }
        return parseJson(sb.toString());
    }

    @Override
    public void run() {
        Map<String, String> command;
        try {
            while (isRunning) {
                command = readJson();
                CommandManager commandManager = new CommandManager();
                System.out.println("method ->" + command.get("method"));
                if (this.id == 0) {
                    this.id = Authenticator.authenticate(command, this);
                } else {
                    commandManager.getCommand(command, this);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

    }

    private Map<String, String> parseJson(String json) {
        Map<String, String> map = new HashMap<>();
        json = json.replace("{", "").replace("}", "");
        String[] pairs = json.split(",");
        for (String pair : pairs) {
            String[] keyValue = pair.split(":");
            if (keyValue.length == 2) {
                String key = keyValue[0].trim().replace("\"", "");
                String value = keyValue[1].trim().replace("\"", "");
                map.put(key, value);
            }
        }
        return map;

    }

    public void closeConnection() {
        try {
            if (dis != null) {
                dis.close();
            }
            if (dos != null) {
                dos.close();
            }
            if (clientSocket != null && !clientSocket.isClosed())
                clientSocket.close();
            isRunning = false;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}