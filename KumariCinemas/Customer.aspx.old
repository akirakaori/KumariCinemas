
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Management</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, EMAIL, CONTACT_NUMBER FROM CUSTOMER"
            InsertCommand="INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, EMAIL, CONTACT_NUMBER) VALUES ((SELECT NVL(MAX(CUSTOMER_ID), 0) + 1 FROM CUSTOMER), :CUSTOMER_NAME, :ADDRESS, :EMAIL, :CONTACT_NUMBER)"
            UpdateCommand="UPDATE CUSTOMER SET CUSTOMER_NAME = :CUSTOMER_NAME, ADDRESS = :ADDRESS, EMAIL = :EMAIL, CONTACT_NUMBER = :CONTACT_NUMBER WHERE CUSTOMER_ID = :CUSTOMER_ID"
            DeleteCommand="DELETE FROM CUSTOMER WHERE CUSTOMER_ID = :CUSTOMER_ID">
            <DeleteParameters>
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div>
            <h2>Customer Information</h2>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="CUSTOMER_ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    <asp:BoundField DataField="CUSTOMER_ID" HeaderText="CUSTOMER_ID" ReadOnly="True" SortExpression="CUSTOMER_ID" />
                    <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="CUSTOMER_NAME" SortExpression="CUSTOMER_NAME" />
                    <asp:BoundField DataField="ADDRESS" HeaderText="ADDRESS" SortExpression="ADDRESS" />
                    <asp:BoundField DataField="EMAIL" HeaderText="EMAIL" SortExpression="EMAIL" />
                    <asp:BoundField DataField="CONTACT_NUMBER" HeaderText="CONTACT_NUMBER" SortExpression="CONTACT_NUMBER" />
                </Columns>
            </asp:GridView>
            
            <hr />
            <h2>Add New Customer</h2>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="CUSTOMER_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                <InsertItemTemplate>
                    CUSTOMER_NAME:
                    <asp:TextBox ID="CUSTOMER_NAMETextBox" runat="server" Text='<%# Bind("CUSTOMER_NAME") %>' />
                    <br />
                    ADDRESS:
                    <asp:TextBox ID="ADDRESSTextBox" runat="server" Text='<%# Bind("ADDRESS") %>' />
                    <br />
                    EMAIL:
                    <asp:TextBox ID="EMAILTextBox" runat="server" Text='<%# Bind("EMAIL") %>' />
                    <br />
                    CONTACT_NUMBER:
                    <asp:TextBox ID="CONTACT_NUMBERTextBox" runat="server" Text='<%# Bind("CONTACT_NUMBER") %>' />
                    <br />
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </InsertItemTemplate>
                <ItemTemplate>
                    CUSTOMER_ID:
                    <asp:Label ID="CUSTOMER_IDLabel" runat="server" Text='<%# Eval("CUSTOMER_ID") %>' />
                    <br />
                    CUSTOMER_NAME:
                    <asp:Label ID="CUSTOMER_NAMELabel" runat="server" Text='<%# Bind("CUSTOMER_NAME") %>' />
                    <br />
                    ADDRESS:
                    <asp:Label ID="ADDRESSLabel" runat="server" Text='<%# Bind("ADDRESS") %>' />
                    <br />
                    EMAIL:
                    <asp:Label ID="EMAILLabel" runat="server" Text='<%# Bind("EMAIL") %>' />
                    <br />
                    CONTACT_NUMBER:
                    <asp:Label ID="CONTACT_NUMBERLabel" runat="server" Text='<%# Bind("CONTACT_NUMBER") %>' />
                    <br />
                    <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="New" />
                </ItemTemplate>
            </asp:FormView>
        </div>
    </form>
</body>
</html>

