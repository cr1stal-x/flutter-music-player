import com.google.gson.Gson;
import java.io.*;
import java.net.Socket;
import java.util.Map;

class ClientHandler implements Runnable {
    int id = 0; // 0 = not authenticated
    private volatile boolean isRunning = true;
    public final Socket clientSocket;
    final Gson gson = new Gson();
    PrintWriter out;
    BufferedReader in;

    public ClientHandler(Socket clientSocket) throws IOException {
        this.clientSocket = clientSocket;
        this.out = new PrintWriter(new OutputStreamWriter(clientSocket.getOutputStream()), true);
        this.in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        System.out.println("Connected to the server.");
    }

    public void sendJson(String json) {
        out.println(json); // newline-separated JSON
        out.flush();
    }

    public Map<String, String> readJson() throws IOException {
        String line = in.readLine();
        if (line == null) {
            return null;
        }
        return gson.fromJson(line, Map.class);
    }

    @Override
    public void run() {
        try {
            CommandManager commandManager = new CommandManager();
            while (isRunning) {
                Map<String, String> command = readJson();
                if (command == null) continue; // skip if nothing yet

                System.out.println("method -> " + command.get("method"));

                    commandManager.getCommand(command, this);

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
    }

    public void closeConnection() {
        try {
            isRunning = false;
            if (in != null) in.close();
            if (out != null) out.close();
            if (clientSocket != null && !clientSocket.isClosed())
                clientSocket.close();
            System.out.println("Connection closed.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}