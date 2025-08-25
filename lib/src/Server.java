import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Connection;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Server {
    public static void main(String[] args) {
        int port = 5000;
        ExecutorService pool = Executors.newFixedThreadPool(10);
            try (Connection conn = SQLConnection.connect()) {
                ScriptRunner.runScript(conn, "/Users/sara/musix/lib/resources/init.sql");
                System.out.println("Database and table initialized.");
                SQLManager.loadSongs("E:\\ServerSongs\\");
            } catch (Exception e) {
                e.printStackTrace();
            }
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Server started on port " + port);
            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("New client: " + clientSocket.getInetAddress());
                ClientHandler handler = new ClientHandler(clientSocket);
                pool.execute(handler);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
