package Repositories;

import models.User;
import utils.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {

    public static boolean addUser(User newUser) {
        String sql = "INSERT INTO Users (username, password, firstName, lastName, email, profile, isVip, credit) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newUser.getUsername());
            ps.setString(2, newUser.getPassword());
            ps.setString(3, newUser.getFirstName());
            ps.setString(4, newUser.getLastName());
            ps.setString(5, newUser.getEmail());
            ps.setString(6, newUser.getProfile());
            ps.setBoolean(7, newUser.getVip());
            ps.setDouble(8, newUser.getCredit());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static User getUserByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getString("firstName"),
                            rs.getString("lastName"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("email")
                    );
                    user.setProfile(rs.getString("profile"));
                    user.setVip(rs.getBoolean("isVip"));
                    user.setCredit(rs.getDouble("credit"));

                    return user;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static boolean checkUserCredentials(String username, String password) {
        String sql = "SELECT 1 FROM Users WHERE username = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<User> getAllUsers() {

        String sql = "SELECT firstName, lastName, username, password, email, profile, isVip, credit FROM Users";
        List<User> users = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getString("firstName"),
                        rs.getString("lastName"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email")
                );

                user.setProfile(rs.getString("profile"));
                user.setVip(rs.getBoolean("isVip"));
                user.setCredit(rs.getDouble("credit"));

                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;

    }

    public static boolean removeUser(String username, String password) {
        String sql = "DELETE FROM Users WHERE username = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean editUserFirstName(User user, String firstName) {
        String sql = "UPDATE Users SET firstName = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setFirstName(firstName);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean editUserLastName(User user, String lastName) {
        String sql = "UPDATE Users SET lastName = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lastName);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setFirstName(lastName);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean editUserUsername(User user, String newUsername) {
        String sql = "UPDATE Users SET username = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newUsername);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setUsername(newUsername);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean editUserPassword(User user, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setPassword(newPassword);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean editUserEmail(User user, String newEmail) {
        String sql = "UPDATE Users SET email = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newEmail);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setEmail(newEmail);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean editUserProfile(User user, String newProfile) {
        String sql = "UPDATE Users SET profile = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newProfile);
            ps.setString(2, user.getUsername());

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                user.setProfile(newProfile);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean subscribeVIPVersion(User u) {
        final int VIP_PRICE = 10000;

        if (u.getCredit() < VIP_PRICE) {
            System.out.println("Not enough credit!");
            return false;
        }

        String sql = "UPDATE Users SET is_vip = ?, credit = credit - ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, true);
            ps.setInt(2, VIP_PRICE);
            ps.setString(3, u.getUsername());

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                u.setVip(true);
                u.setCredit(u.getCredit() - VIP_PRICE);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean removeVipCredit(User u) {
        String sql = "UPDATE Users SET is_vip = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, false);
            ps.setString(2, u.getUsername());

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                u.setVip(false);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean increaseCredit(User u, int amount) {
        String sql = "UPDATE Users SET credit = credit + ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, amount);
            ps.setString(2, u.getUsername());

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                u.setCredit(u.getCredit() + amount);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static boolean recoverUserPassword(User u) {
        String newPassword = "defaultPassword123";  //random?
        String sql = "UPDATE Users SET password = ? WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, u.getUsername());

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                u.setPassword(newPassword);
                System.out.println("Password recovery instructions sent to " + u.getEmail());
                // email
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean login(String name, String pass) {

        boolean user = UserRepository.checkUserCredentials(name, pass);
        if (user) {
            System.out.println("Login successful for user: " + name);
            return true;
        } else {
            System.out.println("Login failed for user: " + name);
            return false;
        }
    }

    public void signup(User u) {
        boolean added = UserRepository.addUser(u);
        if (added) {
            System.out.println("User signed up successfully: " + u.getUsername());
        } else {
            System.out.println("Failed to sign up user: " + u.getUsername());
        }
    }
}