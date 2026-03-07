import java.sql.*;
import java.util.Scanner;

public class VulnerableVault {
    // VULNERABILITY 1: Hardcoded Secret
    private static final String DB_PASSWORD = "superSecretPassword123";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter User ID to fetch balance: ");
        String userId = scanner.nextLine();

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank", "root", DB_PASSWORD);
            Statement stmt = conn.createStatement();

            // VULNERABILITY 2: SQL Injection
            String query = "SELECT balance FROM accounts WHERE user_id = '" + userId + "'";
            System.out.println("Executing Query: " + query);

            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                // VULNERABILITY 3: Unvalidated Output (potential log forging)
                System.out.println("Balance: " + rs.getString("balance"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}