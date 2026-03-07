<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TopTheatreOccupancy.aspx.cs" Inherits="KumariCinemas.TopTheatreOccupancy" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Top Theatre Occupancy Report</title>

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

        <h2>Top 3 Theatre Occupancy by Selected Movie</h2>

        <div class="form-section">
            <span class="label">Select Movie:</span>

            <asp:DropDownList
                ID="ddlMovie"
                runat="server"
                CssClass="dropdown"
                DataSourceID="MovieSource"
                DataTextField="TITLE"
                DataValueField="MOVIE_ID"
                AppendDataBoundItems="True">
                <asp:ListItem Text="-- Select Movie --" Value="" />
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
            DataSourceID="OccupancySource"
            EmptyDataText="No occupancy data found for the selected movie."
            GridLines="Both"
            CellPadding="8">

            <Columns>
                <asp:BoundField DataField="TITLE" HeaderText="Movie Title" SortExpression="TITLE" />
                <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre Name" SortExpression="THEATRE_NAME" />
                <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City Hall" SortExpression="THEATRE_CITY_HALL" />
                <asp:BoundField DataField="HALL_NAME" HeaderText="Hall Name" SortExpression="HALL_NAME" />
                <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Hall Capacity" SortExpression="HALL_CAPACITY" />
                <asp:BoundField DataField="TICKETS_SOLD" HeaderText="Tickets Sold" SortExpression="TICKETS_SOLD" />
                <asp:BoundField DataField="OCCUPANCY_PERCENT" HeaderText="Occupancy %" DataFormatString="{0:N2}" SortExpression="OCCUPANCY_PERCENT" />
            </Columns>

        </asp:GridView>

        <!-- Movie Dropdown Source -->
        <asp:SqlDataSource
            ID="MovieSource"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT MOVIE_ID, TITLE
                FROM MOVIE
                ORDER BY TITLE">
        </asp:SqlDataSource>

        <!-- Occupancy Report Source -->
        <asp:SqlDataSource
            ID="OccupancySource"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT *
                FROM (
                    SELECT
                        M.TITLE,
                        TH.THEATRE_NAME,
                        TH.THEATRE_CITY_HALL,
                        H.HALL_NAME,
                        H.HALL_CAPACITY,
                        COUNT(T.TICKET_ID) AS TICKETS_SOLD,
                        ROUND((COUNT(T.TICKET_ID) / H.HALL_CAPACITY) * 100, 2) AS OCCUPANCY_PERCENT
                    FROM SHOW_TICKET ST
                    JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
                    JOIN THEATRE TH ON ST.THEATRE_ID = TH.THEATRE_ID
                    JOIN HALL H ON ST.HALL_ID = H.HALL_ID
                    JOIN TICKET T ON ST.TICKET_ID = T.TICKET_ID
                    WHERE M.MOVIE_ID = :MOVIE_ID
                      AND UPPER(T.STATUS) = 'PAID'
                    GROUP BY
                        M.TITLE,
                        TH.THEATRE_NAME,
                        TH.THEATRE_CITY_HALL,
                        H.HALL_NAME,
                        H.HALL_CAPACITY
                    ORDER BY ROUND((COUNT(T.TICKET_ID) / H.HALL_CAPACITY) * 100, 2) DESC
                )
                WHERE ROWNUM <= 3">

            <SelectParameters>
                <asp:ControlParameter
                    Name="MOVIE_ID"
                    ControlID="ddlMovie"
                    PropertyName="SelectedValue"
                    Type="Int32" />
            </Sele<asp:SqlDataSource runat="server"></asp:SqlDataSource>
            ctParameters>

        </asp:SqlDataSource>

    </form>
</body>
</html>