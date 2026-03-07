<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerTicket.aspx.cs" Inherits="KumariCinemas.CustomerTicket" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Ticket Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }

        h2 {
            color: #333333;
        }

        .form-section {
            margin-bottom: 20px;
        }

        .label {
            font-weight: bold;
            margin-right: 10px;
        }

        .dropdown {
            padding: 5px;
            width: 220px;
        }

        .button {
            padding: 6px 14px;
            margin-left: 10px;
        }

        .grid {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <h2>Customer Ticket Report (Last 6 Months)</h2>

        <div class="form-section">
            <span class="label">Select Customer:</span>

            <asp:DropDownList ID="ddlCustomer" runat="server"
                CssClass="dropdown"
                DataSourceID="CustomerSource"
                DataTextField="CUSTOMER_NAME"
                DataValueField="CUSTOMER_ID"
                AppendDataBoundItems="True">
                <asp:ListItem Text="-- Select Customer --" Value="" />
            </asp:DropDownList>

            <asp:Button ID="btnSearch" runat="server"
                Text="Search Tickets"
                CssClass="button"
                OnClick="btnSearch_Click" />
        </div>

        <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>

        <asp:GridView ID="GridView1" runat="server"
            CssClass="grid"
            AutoGenerateColumns="False"
            AllowPaging="True"
            AllowSorting="True"
            PageSize="5"
            EmptyDataText="No ticket history found for the selected customer in the last 6 months."
            DataSourceID="TicketSource"
            GridLines="Both"
            CellPadding="8">

            <Columns>
                <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer Name" SortExpression="CUSTOMER_NAME" />
                <asp:BoundField DataField="TICKET_ID" HeaderText="Ticket ID" SortExpression="TICKET_ID" />
                <asp:BoundField DataField="TITLE" HeaderText="Movie Title" SortExpression="TITLE" />
                <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" DataFormatString="{0:dd-MMM-yyyy}" SortExpression="SHOW_DATE" />
                <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                <asp:BoundField DataField="SEAT_NUMBER" HeaderText="Seat Number" SortExpression="SEAT_NUMBER" />
                <asp:BoundField DataField="TICKET_PRICE" HeaderText="Ticket Price" DataFormatString="{0:N2}" SortExpression="TICKET_PRICE" />
                <asp:BoundField DataField="STATUS" HeaderText="Status" SortExpression="STATUS" />
            </Columns>
        </asp:GridView>

        <!-- Customer Dropdown Source -->
        <asp:SqlDataSource ID="CustomerSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME">
        </asp:SqlDataSource>

        <!-- Ticket Report Source -->
        <asp:SqlDataSource ID="TicketSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT C.CUSTOMER_NAME,
                       T.TICKET_ID,
                       M.TITLE,
                       S.SHOW_DATE,
                       S.SHOW_TIME,
                       T.SEAT_NUMBER,
                       T.TICKET_PRICE,
                       T.STATUS
                FROM CUSTOMER C
                JOIN SHOW_TICKET ST ON C.CUSTOMER_ID = ST.CUSTOMER_ID
                JOIN TICKET T ON ST.TICKET_ID = T.TICKET_ID
                JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
                JOIN SHOW S ON ST.SHOW_ID = S.SHOW_ID
                WHERE C.CUSTOMER_ID = :CUSTOMER_ID
                  AND T.BOOKING_DATE >= ADD_MONTHS(SYSDATE, -6)
                ORDER BY S.SHOW_DATE DESC">

            <SelectParameters>
                <asp:ControlParameter
                    Name="CUSTOMER_ID"
                    ControlID="ddlCustomer"
                    PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

    </form>
</body>
</html>