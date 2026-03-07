<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Show.aspx.cs" Inherits="KumariCinemas.Show" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="SHOW_ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    <asp:BoundField DataField="SHOW_ID" HeaderText="SHOW_ID" ReadOnly="True" SortExpression="SHOW_ID" />
                    <asp:BoundField DataField="SHOW_DATE" HeaderText="SHOW_DATE" SortExpression="SHOW_DATE" />
                    <asp:BoundField DataField="SHOW_TIME" HeaderText="SHOW_TIME" SortExpression="SHOW_TIME" />
                    <asp:BoundField DataField="SHOW_TYPE" HeaderText="SHOW_TYPE" SortExpression="SHOW_TYPE" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
                ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
                SelectCommand="SELECT SHOW_ID, SHOW_DATE, SHOW_TIME, SHOW_TYPE FROM SHOW" 
                InsertCommand="INSERT INTO SHOW (SHOW_ID, SHOW_DATE, SHOW_TIME, SHOW_TYPE) VALUES ((SELECT NVL(MAX(SHOW_ID), 0) + 1 FROM SHOW), :SHOW_DATE, :SHOW_TIME, :SHOW_TYPE)" 
                UpdateCommand="UPDATE SHOW SET SHOW_DATE = :SHOW_DATE, SHOW_TIME = :SHOW_TIME, SHOW_TYPE = :SHOW_TYPE WHERE SHOW_ID = :SHOW_ID" 
                DeleteCommand="DELETE FROM SHOW WHERE SHOW_ID = :SHOW_ID">
                <DeleteParameters>
                    <asp:Parameter Name="SHOW_ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
                    <asp:Parameter Name="SHOW_TIME" Type="String" />
                    <asp:Parameter Name="SHOW_TYPE" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
                    <asp:Parameter Name="SHOW_TIME" Type="String" />
                    <asp:Parameter Name="SHOW_TYPE" Type="String" />
                    <asp:Parameter Name="SHOW_ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="SHOW_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">

                <InsertItemTemplate>
                    SHOW_DATE:
                    <asp:TextBox ID="SHOW_DATETextBox" runat="server" Text='<%# Bind("SHOW_DATE") %>' />
                    <br />
                    SHOW_TIME:
                    <asp:TextBox ID="SHOW_TIMETextBox" runat="server" Text='<%# Bind("SHOW_TIME") %>' />
                    <br />
                    SHOW_TYPE:
                    <asp:TextBox ID="SHOW_TYPETextBox" runat="server" Text='<%# Bind("SHOW_TYPE") %>' />
                    <br />
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </InsertItemTemplate>
                <ItemTemplate>
                    
                    &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="Insert" />
                </ItemTemplate>
            </asp:FormView>
        </div>
    </form>
</body>
</html>
