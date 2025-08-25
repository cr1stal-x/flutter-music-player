import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;

public class SQLConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/musix?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "RozSava466557";


    public static Connection connect() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

class ScriptRunner {
    public static void runScript(Connection conn, String filePath) throws Exception {
        Statement stmt = conn.createStatement();
        BufferedReader br = new BufferedReader(
                new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8)
        );
        String line;
        StringBuilder sql = new StringBuilder();

        while ((line = br.readLine()) != null) {
            sql.append(line).append(" ");
            if (line.trim().endsWith(";")) {
                stmt.execute(sql.toString());
                sql.setLength(0);
            }
        }

        /* automatically close
        br.close();
        stmt.close();
         */
    }
}
