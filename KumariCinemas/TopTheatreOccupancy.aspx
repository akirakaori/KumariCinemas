<%@ Page Title="Top Theatre Occupancy Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TopTheatreOccupancy.aspx.cs" Inherits="KumariCinemas.TopTheatreOccupancy" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Top Theatre Occupancy Report</h1>
            <p class="page-subtitle">View the top 3 theatre occupancy results and detailed hall performance analytics.</p>
        </div>

        <!-- Filter Section Card -->
        <div class="filter-card mb-4">
            <div class="filter-card-header">
                <h3 class="card-header-title mb-0">
                    <i class="fas fa-chart-line me-2"></i>Report Filters
                </h3>
            </div>
            <div class="filter-card-body">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                    ValidationGroup="MovieSearch" 
                    CssClass="alert alert-danger" 
                    HeaderText="Please correct the following errors:" 
                    DisplayMode="BulletList" />
                <div class="row align-items-end">
                    <div class="col-md-8 mb-3 mb-md-0">
                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                            <i class="fas fa-film me-1"></i>Select Movie
                        </label>
                        <asp:DropDownList
                            ID="ddlMovie"
                            runat="server"
                            CssClass="form-select"
                            DataSourceID="MovieSource"
                            DataTextField="TITLE"
                            DataValueField="MOVIE_ID"
                            AppendDataBoundItems="True">
                            <asp:ListItem Text="-- Select Movie --" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvMovie" runat="server" 
                            ControlToValidate="ddlMovie" 
                            ValidationGroup="MovieSearch" 
                            ErrorMessage="Please select a movie" 
                            Display="Dynamic" 
                            CssClass="text-danger small" 
                            Text="* Please select a movie" />
                    </div>
                    <div class="col-md-4">
                        <asp:LinkButton
                            ID="btnSearch"
                            runat="server"
                            CssClass="btn btn-emerald w-100"
                            CausesValidation="True"
                            ValidationGroup="MovieSearch"
                            OnClick="btnSearch_Click">
                            <i class="fas fa-chart-bar me-2"></i>Generate Report
                        </asp:LinkButton>
                    </div>
                </div>
                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    CssClass="text-danger mt-2 d-block">
                </asp:Label>
            </div>
        </div>

        <!-- Report Results Card -->
        <div class="section-card">
            <div class="section-card-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-trophy me-2"></i>
                    <div>
                        <h3 class="section-card-title mb-0">Top 3 Performers (This Period)</h3>
                        <p class="section-card-subtitle mb-0">Updated live based on the selected movie.</p>
                    </div>
                </div>
            </div>
            <div class="section-card-body">
                <div class="table-container">
                    <asp:GridView
                        ID="GridView1"
                        runat="server"
                        AutoGenerateColumns="False"
                        AllowPaging="True"
                        AllowSorting="True"
                        PageSize="5"
                        DataSourceID="OccupancySource"
                        EmptyDataText="No occupancy data found for the selected movie."
                        CssClass="gridview"
                        GridLines="None"
                        PagerStyle-CssClass="gridview-pager">
                        <Columns>
                            <asp:BoundField DataField="TITLE" HeaderText="Theatre & Hall" SortExpression="TITLE" />
                            <asp:BoundField DataField="THEATRE_NAME" HeaderText="Active Movie" SortExpression="THEATRE_NAME" />
                            <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="Capacity" SortExpression="THEATRE_CITY_HALL" />
                            <asp:BoundField DataField="HALL_NAME" HeaderText="Sold" SortExpression="HALL_NAME" />
                            <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Hall Capacity" SortExpression="HALL_CAPACITY" />
                            <asp:BoundField DataField="TICKETS_SOLD" HeaderText="Tickets Sold" SortExpression="TICKETS_SOLD" />
                            <asp:BoundField DataField="OCCUPANCY_PERCENT" HeaderText="Occupancy %" DataFormatString="{0:N2}" SortExpression="OCCUPANCY_PERCENT" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

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
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>
