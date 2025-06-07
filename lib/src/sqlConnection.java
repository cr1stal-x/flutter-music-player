import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class sqlConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/univercity";
    private static final String USER="root";
    private static final String PASSWORD="RozSava466557";
    private static Connection connection;
    public static void main(String[] args) {
        try {
            connection=DriverManager.getConnection(URL, USER, PASSWORD);
            if(connection!=null){
                System.out.println("sucsess");
            }
            else{
                System.out.println("failed");
            }

        } catch (SQLException e) {
            System.out.println("sql failed with an exception");
            e.printStackTrace();
        }
    }
}
