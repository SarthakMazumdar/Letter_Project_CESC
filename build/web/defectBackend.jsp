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

if (consumerNumber == null || consumerNumber.isEmpty() || docketNumber == null || docketNumber.isEmpty()) {
    response.setContentType("text/plain");
    response.getWriter().write("Enter the details properly");
} else {
    String url = "jdbc:oracle:thin:@//10.40.82.65:1522/ITBLDB_PDB2";
    String username = "trainee";
    String password = "trainee";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT examine_date, namenew, street, city, statenew, meter_number, docket_number, datenew FROM consumerdef WHERE consumer_number = ? AND docket_number = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, consumerNumber);
        stmt.setString(2, docketNumber);

        rs = stmt.executeQuery();

        JSONObject jsonData = new JSONObject();

        if (rs.next()) {
            jsonData.put("consumerNumber", consumerNumber);
            jsonData.put("name", rs.getString("namenew"));
            jsonData.put("street", rs.getString("street"));
            jsonData.put("city", rs.getString("city"));
            jsonData.put("state", rs.getString("statenew"));
            jsonData.put("meterNumber", rs.getString("meter_number"));
            jsonData.put("docketNo", rs.getString("docket_number"));

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date dateNew = rs.getDate("datenew");
            if (dateNew != null) {
                String date = dateFormat.format(dateNew);
                jsonData.put("date", date);
            }

            Date examineDate = rs.getDate("examine_date");
            if (examineDate != null) {
                String formattedExamineDate = dateFormat.format(examineDate);
                jsonData.put("examineDate", formattedExamineDate);
            }
        }

        // Set content type and send JSON response
        response.setContentType("application/json");
        out.print(jsonData.toJSONString());

    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("Error loading JDBC driver: " + e.getMessage());
    } catch (SQLException e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("Error processing request: " + e.getMessage());
    } catch (IOException e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("IO Exception: " + e.getMessage());
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
}
%>
