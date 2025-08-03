package models;

public class User {
    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private String email;
    private String profile;
    private boolean isVip;
    private double credit;
    //private PlayList[] playLists;

    public User(String username, String password, String firstName, String lastName, String email, String profile, boolean isVip, double credit) {
        this.username = username;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.profile = profile;
        this.isVip = isVip;
        this.credit = credit;
    }

    public User(String username, String password, String firstName, String lastName, String email) {
        this(username, password, firstName, lastName, email, "default", false, 0.0);
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmail() {
        return email;
    }

    public String getProfile() {
        return profile;
    }

    public boolean getVip() {
        return isVip;
    }

    public double getCredit() {
        return credit;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setProfile(String profile) {
        this.profile = profile;
    }

    public void setVip(boolean isVip){
        this.isVip = isVip;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    @Override
    public String toString() {
        return "user{" +
                "name='" + firstName + " " + lastName + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}