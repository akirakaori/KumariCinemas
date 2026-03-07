<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TheatreMovie.aspx.cs" Inherits="KumariCinemas.TheatreMovie" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TheatreCityHall Movie Report</title>

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
            padding: 6px;
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

        <h2>TheatreCityHall Movie Report</h2>

        <div class="form-section">
            <span class="label">Select Theatre:</span>

            <asp:DropDownList
                ID="ddlTheatre"
                runat="server"
                CssClass="dropdown"
                DataSourceID="TheatreSource"
                DataTextField="THEATRE_NAME"
                DataValueField="THEATRE_ID"
                AppendDataBoundItems="True">
                <asp:ListItem Text="-- Select Theatre --" Value="" />
            </asp:DropDownList>

            <asp:Button
                ID="btnSearch"
                runat="server"
                Text="Search"
                CssClass="button"
                OnClick="btnSearch_Click" />
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            ForeColor="Red">
        </asp:Label>

        <asp:GridView
            ID="GridView1"
            runat="server"
            CssClass="grid"
            AutoGenerateColumns="False"
            AllowPaging="True"
            AllowSorting="True"
            PageSize="5"
            DataSourceID="MovieSource"
            EmptyDataText="No movie and showtime records found for the selected theatre."
            GridLines="Both"
            CellPadding="8">

            <Columns>
                <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre Name" SortExpression="THEATRE_NAME" />
                <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City Hall" SortExpression="THEATRE_CITY_HALL" />
                <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Location" SortExpression="THEATRE_LOCATION" />
                <asp:BoundField DataField="HALL_NAME" HeaderText="Hall Name" SortExpression="HALL_NAME" />
                <asp:BoundField DataField="HALL_TYPE" HeaderText="Hall Type" SortExpression="HALL_TYPE" />
                <asp:BoundField DataField="TITLE" HeaderText="Movie Title" SortExpression="TITLE" />
                <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" DataFormatString="{0:dd-MMM-yyyy}" SortExpression="SHOW_DATE" />
                <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                <asp:BoundField DataField="SHOW_TYPE" HeaderText="Show Type" SortExpression="SHOW_TYPE" />
            </Columns>

        </asp:GridView>

        <!-- Theatre Dropdown Source -->
        <asp:SqlDataSource
            ID="TheatreSource"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT THEATRE_ID, THEATRE_NAME
                FROM THEATRE
                ORDER BY THEATRE_NAME">
        </asp:SqlDataSource>

        <!-- Theatre Movie Report Query -->
        <asp:SqlDataSource
            ID="MovieSource"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT DISTINCT
                       TH.THEATRE_NAME,
                       TH.THEATRE_CITY_HALL,
                       TH.THEATRE_LOCATION,
                       H.HALL_NAME,
                       H.HALL_TYPE,
                       M.TITLE,
                       S.SHOW_DATE,
                       S.SHOW_TIME,
                       S.SHOW_TYPE
                FROM SHOW_TICKET ST
                JOIN THEATRE TH ON ST.THEATRE_ID = TH.THEATRE_ID
                JOIN HALL H ON ST.HALL_ID = H.HALL_ID
                JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
                JOIN SHOW S ON ST.SHOW_ID = S.SHOW_ID
                WHERE TH.THEATRE_ID = :THEATRE_ID
                ORDER BY S.SHOW_DATE DESC, S.SHOW_TIME ASC">

            <SelectParameters>
                <asp:ControlParameter
                    Name="THEATRE_ID"
                    ControlID="ddlTheatre"
                    PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>

        </asp:SqlDataSource>

    </form>
</body>
</html>