<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Theatre.aspx.cs" Inherits="KumariCinemas.Theatre" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="THEATRE_ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    <asp:BoundField DataField="THEATRE_ID" HeaderText="THEATRE_ID" ReadOnly="True" SortExpression="THEATRE_ID" />
                    <asp:BoundField DataField="THEATRE_NAME" HeaderText="THEATRE_NAME" SortExpression="THEATRE_NAME" />
                    <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="THEATRE_CITY_HALL" SortExpression="THEATRE_CITY_HALL" />
                    <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="THEATRE_LOCATION" SortExpression="THEATRE_LOCATION" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
                ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
                SelectCommand="SELECT THEATRE_ID, THEATRE_NAME, THEATRE_CITY_HALL, THEATRE_LOCATION FROM THEATRE" 
                InsertCommand="INSERT INTO THEATRE (THEATRE_ID, THEATRE_NAME, THEATRE_CITY_HALL, THEATRE_LOCATION) VALUES ((SELECT NVL(MAX(THEATRE_ID), 0) + 1 FROM THEATRE), :THEATRE_NAME, :THEATRE_CITY_HALL, :THEATRE_LOCATION)" 
                UpdateCommand="UPDATE THEATRE SET THEATRE_NAME = :THEATRE_NAME, THEATRE_CITY_HALL = :THEATRE_CITY_HALL, THEATRE_LOCATION = :THEATRE_LOCATION WHERE THEATRE_ID = :THEATRE_ID" 
                DeleteCommand="DELETE FROM THEATRE WHERE THEATRE_ID = :THEATRE_ID">
                <DeleteParameters>
                    <asp:Parameter Name="THEATRE_ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="THEATRE_NAME" Type="String" />
                    <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
                    <asp:Parameter Name="THEATRE_LOCATION" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="THEATRE_NAME" Type="String" />
                    <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
                    <asp:Parameter Name="THEATRE_LOCATION" Type="String" />
                    <asp:Parameter Name="THEATRE_ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="THEATRE_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">

                <InsertItemTemplate>
                    THEATRE_NAME:
                    <asp:TextBox ID="THEATRE_NAMETextBox" runat="server" Text='<%# Bind("THEATRE_NAME") %>' />
                    <br />
                    THEATRE_CITY_HALL:
                    <asp:TextBox ID="THEATRE_CITY_HALLTextBox" runat="server" Text='<%# Bind("THEATRE_CITY_HALL") %>' />
                    <br />
                    THEATRE_LOCATION:
                    <asp:TextBox ID="THEATRE_LOCATIONTextBox" runat="server" Text='<%# Bind("THEATRE_LOCATION") %>' />
                    <br />
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="Insert" />
                </ItemTemplate>
            </asp:FormView>
        </div>
    </form>
</body>
</html>
