
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Movie.aspx.cs" Inherits="KumariCinemas.Movie" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Movie Management</title>
</head>

<body>

<form id="form1" runat="server">

<asp:SqlDataSource ID="SqlDataSource1" runat="server"

ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"

SelectCommand="SELECT MOVIE_ID, TITLE, DURATION, LANGUAGE, GENRE, RELEASE_DATE FROM MOVIE"

InsertCommand="INSERT INTO MOVIE (MOVIE_ID, TITLE, DURATION, LANGUAGE, GENRE, RELEASE_DATE)
VALUES ((SELECT NVL(MAX(MOVIE_ID), 0) + 1 FROM MOVIE), :TITLE, :DURATION, :LANGUAGE, :GENRE, :RELEASE_DATE)"

UpdateCommand="UPDATE MOVIE SET
TITLE=:TITLE,
DURATION=:DURATION,
LANGUAGE=:LANGUAGE,
GENRE=:GENRE,
RELEASE_DATE=:RELEASE_DATE
WHERE MOVIE_ID=:MOVIE_ID"

DeleteCommand="DELETE FROM MOVIE WHERE MOVIE_ID=:MOVIE_ID">

<DeleteParameters>
<asp:Parameter Name="MOVIE_ID" Type="Int32" />
</DeleteParameters>

<InsertParameters>
<asp:Parameter Name="TITLE" Type="String" />
<asp:Parameter Name="DURATION" Type="Int32" />
<asp:Parameter Name="LANGUAGE" Type="String" />
<asp:Parameter Name="GENRE" Type="String" />
<asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
</InsertParameters>

<UpdateParameters>
<asp:Parameter Name="TITLE" Type="String" />
<asp:Parameter Name="DURATION" Type="Int32" />
<asp:Parameter Name="LANGUAGE" Type="String" />
<asp:Parameter Name="GENRE" Type="String" />
<asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
<asp:Parameter Name="MOVIE_ID" Type="Int32" />
</UpdateParameters>

</asp:SqlDataSource>

<div>

<h2>Movie Information</h2>

<asp:GridView ID="GridView1" runat="server"
AllowPaging="True"
AllowSorting="True"
AutoGenerateColumns="False"
DataKeyNames="MOVIE_ID"
DataSourceID="SqlDataSource1">

<Columns>

<asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />

<asp:BoundField DataField="MOVIE_ID" HeaderText="MOVIE_ID" ReadOnly="True" />

<asp:BoundField DataField="TITLE" HeaderText="TITLE" />

<asp:BoundField DataField="DURATION" HeaderText="DURATION" />

<asp:BoundField DataField="LANGUAGE" HeaderText="LANGUAGE" />

<asp:BoundField DataField="GENRE" HeaderText="GENRE" />

<asp:BoundField DataField="RELEASE_DATE" HeaderText="RELEASE_DATE" />

</Columns>

</asp:GridView>

<hr />

<h2>Add New Movie</h2>

<asp:FormView ID="FormView1" runat="server"
DataKeyNames="MOVIE_ID"
DataSourceID="SqlDataSource1"
DefaultMode="Insert">

<InsertItemTemplate>

TITLE:
<asp:TextBox ID="TITLETextBox" runat="server" Text='<%# Bind("TITLE") %>' />
<br />

DURATION:
<asp:TextBox ID="DURATIONTextBox" runat="server" Text='<%# Bind("DURATION") %>' />
<br />

LANGUAGE:
<asp:TextBox ID="LANGUAGETextBox" runat="server" Text='<%# Bind("LANGUAGE") %>' />
<br />

GENRE:
<asp:TextBox ID="GENRETextBox" runat="server" Text='<%# Bind("GENRE") %>' />
<br />

RELEASE_DATE:
<asp:TextBox ID="RELEASE_DATETextBox" runat="server" Text='<%# Bind("RELEASE_DATE") %>' />
<br />

<asp:LinkButton ID="InsertButton" runat="server"
CommandName="Insert"
Text="Insert" />

&nbsp;

<asp:LinkButton ID="CancelButton" runat="server"
CommandName="Cancel"
Text="Cancel" />

</InsertItemTemplate>

</asp:FormView>

</div>

</form>

</body>
</html>
