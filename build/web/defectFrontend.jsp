<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Defective Meter</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                line-height: 1.6;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .header {
                text-align: center;
                margin-bottom: 20px;
            }
            .address {
                margin-bottom: 20px;
            }
            .footer {
                margin-top: 30px;
            }

            .containernew {
                width: 96%;
                background-color: #f0f0f0;
                border: 2px solid black;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                justify-content: space-between;
                align-items: center;
            }

            .center {
                display: flex;
                justify-content: center;
                align-items: center;
            }

            img {
                max-width: 100px;
                max-height: 100px;
                margin: 0 10px;
            }

            .text1 {
                flex: 1;
                text-align: center;
            }

            .img1 {
                margin-left: auto;
                width: 200px;
                max-width: 100%;
                height: auto;
            }

            .img2 {
                margin-right: auto;
                max-width: 100%;
                width: 150px;
                height: auto;
            }


            #dataForm {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            #dataForm input[type="text"] {
                width: calc(50% - 12px); 
                padding: 10px;
                margin: 10px 6px; 
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 16px;
                outline: none;
            }

            #dataForm input[type="text"]:focus {
                border-color: #0066ff;
            }

            #dataForm input[type="submit"], #dataForm input[type="reset"] {
                width: 48%; 
                padding: 12px;
                margin: 10px 1% 0; 
                border: none;
                border-radius: 5px;
                background-color: #0066ff;
                color: #fff;
                font-size: 16px;
                cursor: pointer;
                outline: none;
            }

            #dataForm input[type="submit"]:hover, #dataForm input[type="reset"]:hover {
                background-color: #0059b3;
            }

            #dataForm input[type="submit"]:active, #dataForm input[type="reset"]:active {
                background-color: #004080;
            }
        </style>
    </head>
    <body>

        <%
            // Get the current date
            Date currentDate = new Date();

            // Format the current date in dd/mm/yyyy format
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            String formattedDate = dateFormat.format(currentDate);
        %>

        <div class="containernew">
            <div class="center">
                <img class="img1" src="rpg.png" alt="Left Image">
                <h1 class="text1">Online Feedback Letter For Inspection/Exchange <br> Done By Testing Department</h1>
                <img class="img2" src="cesc.png" alt="Right Image">
            </div>
        </div>
        <br>
        
        <p style="text-align: center; font-weight: bold; font-size: 40px; margin-top: 20px;">Defective Meter</p>
        
        
        <form id="dataForm">
            <div style="display: flex; justify-content: space-between;">
                <input type="text" id="consumerNumber" name="consumerNumber" placeholder="Enter Consumer Number">
                <input type="text" id="docketNumber" name="docketNumber" placeholder="Enter Docket Number">
            </div>
            <div style="display: flex; justify-content: space-between;">
                <input type="submit" value="Submit">
                <input type="reset" value="Reset">
            </div>
        </form>

        <br>
        <br>

        <div class="container">
            <div class="address">
                <div style="display: flex; justify-content: space-between;">
                    <p>HR/C/<span id="consumerNumberSpan"></span>/<%= new SimpleDateFormat("yy").format(new Date())%></p>
                    <p style="text-align: right;">Dated:  <%= formattedDate%></p>
                </div>
                <p><span id="nameSpan"></span> <br>
                    <span id="streetSpan"></span><br>
                    <span id="citySpan"></span><br>
                    <span id="stateNoSpan"></span><br></p>

                <p style="text-align: center;">Consumer No: <span id="consumerNumberSpan1"></span></p>
                <p style="text-align: center;">Meter No: <span id="meterNumberSpan"></span></p>
            </div>

            <br>

            <p> Dear Valued Consumer,</p>

            <p>Further to your Docket No: <span id="docketNoSpan"></span> dated <span id="dateSpan"></span>, we would inform you that the captioned meter was examined by us at site on <span id="examineDateSpan"></span> when it was found to be defective. </p>

            <p>Accordingly, arrangements are being made to replace the meter at the earliest. </p>

            <p> However, if any further action is required to be taken in this regard, same will be communicated to you within 7 working days. </p>

            <p> If you have further query in this regard, may kindly contact us at our helpline numbers 1912, 033 35011912, 033 44031912, 18605001912  </p>

            <p class="footer">Thanking You,<br>
                Yours faithfully,<br>
                Team CESC Ltd.</p>
        </div>

        <script>
            $(document).ready(function () {
                $("#dataForm").submit(function (event) {
                    event.preventDefault(); // Prevent default form submission

                    // Get data from form fields
                    var consumerNumber = $("#consumerNumber").val();
                    var docketNumber = $("#docketNumber").val();

                    // AJAX call to servlet
                    $.ajax({
                        url: "defectBackend.jsp",
                        type: "POST",
                        data: {
                            consumerNumber: consumerNumber,
                            docketNumber: docketNumber
                        },
                        dataType: "json",
                        success: function (response) {
                            // Update the HTML content with data received from servlet
                            $("#consumerNumberSpan").text(response.consumerNumber);
                            $("#consumerNumberSpan1").text(response.consumerNumber);
                            $("#nameSpan").text(response.name);
                            $("#streetSpan").text(response.street);
                            $("#citySpan").text(response.city);
                            $("#stateNoSpan").text(response.state);
                            $("#meterNumberSpan").text(response.meterNumber);
                            $("#docketNoSpan").text(response.docketNo);
                            $("#dateSpan").text(response.date);
                            $("#examineDateSpan").text(response.examineDate);
                            // Clear any previous error message
                            $("#error").text("");
                        },
                        error: function (xhr, status, error) {
                            // Display error message as a pop-up
                            alert(xhr.responseText);
                        }
                    });
                });
                $("#dataForm input[type='reset']").click(function () {
                    // Reset form fields
                    $("#dataForm")[0].reset();
                    // Clear response data
                    $("#consumerNumberSpan, #consumerNumberSpan1, #nameSpan, #streetSpan, #citySpan, #stateNoSpan, #meterNumberSpan, #docketNoSpan, #dateSpan, #examineDateSpan").text("");
                });
            });
        </script>
    </body>
</html>
