<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.annotation.WebServlet"%>
<%@page import="javax.servlet.http.HttpServlet"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="org.json.simple.JSONObject"%>

<%
String consumerNumber = request.getParameter("consumerNumber");
String docketNumber = request.getParameter("docketNumber");

String url = "jdbc:oracle:thin:@//10.40.82.65:1522/ITBLDB_PDB2";
String username = "trainee";
String password = "trainee";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

JSONObject jsonData = new JSONObject();

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn = DriverManager.getConnection(url, username, password);

    // Prepare SQL statement to fetch data
    String sql = "SELECT namenew, street, city, statenew, meter_number, docket_number, datenew, examine_date, reading FROM consumer WHERE consumer_number = ? AND docket_number = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, consumerNumber);
    stmt.setString(2, docketNumber);

    // Execute query
    rs = stmt.executeQuery();

    if (rs.next()) {
        // Fetch data from ResultSet
        jsonData.put("consumerNumber", consumerNumber);
        jsonData.put("name", rs.getString("namenew"));
        jsonData.put("street", rs.getString("street"));
        jsonData.put("city", rs.getString("city"));
        jsonData.put("state", rs.getString("statenew"));
        jsonData.put("meterNumber", rs.getString("meter_number"));
        jsonData.put("docketNo", rs.getString("docket_number"));
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String date = dateFormat.format(rs.getDate("datenew"));
        jsonData.put("date", date);
        String examineDate = dateFormat.format(rs.getDate("examine_date"));
        jsonData.put("examineDate", examineDate);
        jsonData.put("reading", rs.getString("reading"));
    }

    // Set content type and send JSON response
    response.setContentType("application/json");
    out.print(jsonData.toJSONString());

} catch (ClassNotFoundException e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
} catch (SQLException e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
} catch (IOException e) {
    e.printStackTrace();
} finally {
    // Close resources
    if (rs != null) {
        try {
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (stmt != null) {
        try {
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>
