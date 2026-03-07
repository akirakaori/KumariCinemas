<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ticket.aspx.cs" Inherits="KumariCinemas.Ticket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="TICKET_ID" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="TICKET_ID" HeaderText="TICKET_ID" ReadOnly="True" SortExpression="TICKET_ID" />
                <asp:BoundField DataField="TICKET_PRICE" HeaderText="TICKET_PRICE" SortExpression="TICKET_PRICE" />
                <asp:BoundField DataField="BOOKING_DATE" HeaderText="BOOKING_DATE" SortExpression="BOOKING_DATE" />
                <asp:BoundField DataField="STATUS" HeaderText="STATUS" SortExpression="STATUS" />
                <asp:BoundField DataField="SEAT_NUMBER" HeaderText="SEAT_NUMBER" SortExpression="SEAT_NUMBER" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT TICKET_ID, TICKET_PRICE, BOOKING_DATE, STATUS, SEAT_NUMBER FROM TICKET" 
            InsertCommand="INSERT INTO TICKET (TICKET_ID, TICKET_PRICE, BOOKING_DATE, STATUS, SEAT_NUMBER) VALUES ((SELECT NVL(MAX(TICKET_ID), 0) + 1 FROM TICKET), :TICKET_PRICE, :BOOKING_DATE, :STATUS, :SEAT_NUMBER)" 
            UpdateCommand="UPDATE TICKET SET TICKET_PRICE = :TICKET_PRICE, BOOKING_DATE = :BOOKING_DATE, STATUS = :STATUS, SEAT_NUMBER = :SEAT_NUMBER WHERE TICKET_ID = :TICKET_ID" 
            DeleteCommand="DELETE FROM TICKET WHERE TICKET_ID = :TICKET_ID">
            <DeleteParameters>
                <asp:Parameter Name="TICKET_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="TICKET_PRICE" Type="Decimal" />
                <asp:Parameter Name="BOOKING_DATE" Type="DateTime" />
                <asp:Parameter Name="STATUS" Type="String" />
                <asp:Parameter Name="SEAT_NUMBER" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="TICKET_PRICE" Type="Decimal" />
                <asp:Parameter Name="BOOKING_DATE" Type="DateTime" />
                <asp:Parameter Name="STATUS" Type="String" />
                <asp:Parameter Name="SEAT_NUMBER" Type="String" />
                <asp:Parameter Name="TICKET_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="TICKET_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">

            <InsertItemTemplate>
                TICKET_PRICE:
                <asp:TextBox ID="TICKET_PRICETextBox" runat="server" Text='<%# Bind("TICKET_PRICE") %>' />
                <br />
                BOOKING_DATE:
                <asp:TextBox ID="BOOKING_DATETextBox" runat="server" Text='<%# Bind("BOOKING_DATE") %>' />
                <br />
                STATUS:
                <asp:TextBox ID="STATUSTextBox" runat="server" Text='<%# Bind("STATUS") %>' />
                <br />
                SEAT_NUMBER:
                <asp:TextBox ID="SEAT_NUMBERTextBox" runat="server" Text='<%# Bind("SEAT_NUMBER") %>' />
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                
                &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="New" />
            </ItemTemplate>
        </asp:FormView>
    </form>
</body>
</html>
