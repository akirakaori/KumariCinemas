<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Hall.aspx.cs" Inherits="KumariCinemas.Hall" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href= "/content/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="GridView1" CssClass="table" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="HALL_ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    <asp:BoundField DataField="HALL_ID" HeaderText="HALL_ID" ReadOnly="True" SortExpression="HALL_ID" />
                    <asp:BoundField DataField="HALL_CAPACITY" HeaderText="HALL_CAPACITY" SortExpression="HALL_CAPACITY" />
                    <asp:BoundField DataField="HALL_NAME" HeaderText="HALL_NAME" SortExpression="HALL_NAME" />
                    <asp:BoundField DataField="HALL_TYPE" HeaderText="HALL_TYPE" SortExpression="HALL_TYPE" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
                ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
                SelectCommand="SELECT HALL_ID, HALL_CAPACITY, HALL_NAME, HALL_TYPE FROM HALL" 
                InsertCommand="INSERT INTO HALL (HALL_ID, HALL_CAPACITY, HALL_NAME, HALL_TYPE) VALUES ((SELECT NVL(MAX(HALL_ID), 0) + 1 FROM HALL), :HALL_CAPACITY, :HALL_NAME, :HALL_TYPE)" 
                UpdateCommand="UPDATE HALL SET HALL_CAPACITY = :HALL_CAPACITY, HALL_NAME = :HALL_NAME, HALL_TYPE = :HALL_TYPE WHERE HALL_ID = :HALL_ID" 
                DeleteCommand="DELETE FROM HALL WHERE HALL_ID = :HALL_ID">
                <DeleteParameters>
                    <asp:Parameter Name="HALL_ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="HALL_CAPACITY" Type="Int32" />
                    <asp:Parameter Name="HALL_NAME" Type="String" />
                    <asp:Parameter Name="HALL_TYPE" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="HALL_CAPACITY" Type="Int32" />
                    <asp:Parameter Name="HALL_NAME" Type="String" />
                    <asp:Parameter Name="HALL_TYPE" Type="String" />
                    <asp:Parameter Name="HALL_ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="HALL_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">

                <InsertItemTemplate>
                    HALL_CAPACITY:
                    <asp:TextBox ID="HALL_CAPACITYTextBox" runat="server" Text='<%# Bind("HALL_CAPACITY") %>' />
                    <br />
                    HALL_NAME:
                    <asp:TextBox ID="HALL_NAMETextBox" runat="server" Text='<%# Bind("HALL_NAME") %>' />
                    <br />
                    HALL_TYPE:
                    <asp:TextBox ID="HALL_TYPETextBox" runat="server" Text='<%# Bind("HALL_TYPE") %>' />
                    <br />
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </InsertItemTemplate>
                <ItemTemplate>
                    
                    <br />
                    
                    &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="New" />
                </ItemTemplate>
            </asp:FormView>
        </div>
    </form>
</body>
</html>
