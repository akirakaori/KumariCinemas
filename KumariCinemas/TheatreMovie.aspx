<%@ Page Title="Theatre Movie Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TheatreMovie.aspx.cs" Inherits="KumariCinemas.TheatreMovie" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Theatre Movie Report</h1>
            <p class="page-subtitle">View movie and showtime details for the selected theatre.</p>
        </div>

        <!-- Filter Section Card -->
        <div class="filter-card mb-4">
            <div class="filter-card-header">
                <h3 class="card-header-title mb-0">
                    <i class="fas fa-sliders-h me-2"></i>Report Filters
                </h3>
            </div>
            <div class="filter-card-body">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                    ValidationGroup="TheatreSearch" 
                    CssClass="alert alert-danger" 
                    HeaderText="Please correct the following errors:" 
                    DisplayMode="BulletList" />
                <div class="row align-items-end">
                    <div class="col-md-8 mb-3 mb-md-0">
                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                            <i class="fas fa-building me-1"></i>Select Theatre
                        </label>
                        <asp:DropDownList
                            ID="ddlTheatre"
                            runat="server"
                            CssClass="form-select"
                            DataSourceID="TheatreSource"
                            DataTextField="THEATRE_NAME"
                            DataValueField="THEATRE_ID"
                            AppendDataBoundItems="True">
                            <asp:ListItem Text="-- Select Theatre --" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTheatre" runat="server" 
                            ControlToValidate="ddlTheatre" 
                            ValidationGroup="TheatreSearch" 
                            ErrorMessage="Please select a theatre" 
                            Display="Dynamic" 
                            CssClass="text-danger small" 
                            Text="* Please select a theatre" />
                    </div>
                    <div class="col-md-4">
                        <asp:LinkButton
                            ID="btnSearch"
                            runat="server"
                            CssClass="btn btn-emerald w-100"
                            CausesValidation="True"
                            ValidationGroup="TheatreSearch"
                            OnClick="btnSearch_Click">
                            <i class="fas fa-search me-2"></i>Generate Report
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
        <div class="crud-card">
            <div class="crud-card-header">
                <h3 class="card-header-title mb-0">
                    <i class="fas fa-film-can me-2"></i>Report Results
                </h3>
                <small class="text-muted">Showing 5 results based on your current selection.</small>
            </div>
            <div class="crud-card-body p-0">
                <div class="table-container">
                    <asp:GridView
                        ID="GridView1"
                        runat="server"
                        AutoGenerateColumns="False"
                        AllowPaging="True"
                        AllowSorting="True"
                        PageSize="5"
                        DataSourceID="MovieSource"
                        EmptyDataText="No movie and showtime records found for the selected theatre."
                        CssClass="gridview"
                        GridLines="None"
                        PagerStyle-CssClass="gridview-pager">
                        <Columns>
                            <asp:BoundField DataField="THEATRE_NAME" HeaderText="Movie Details" SortExpression="THEATRE_NAME" />
                            <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="Theatre & Hall" SortExpression="THEATRE_CITY_HALL" />
                            <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Schedule" SortExpression="THEATRE_LOCATION" />
                            <asp:BoundField DataField="HALL_NAME" HeaderText="Occupancy" SortExpression="HALL_NAME" />
                            <asp:BoundField DataField="HALL_TYPE" HeaderText="Status" SortExpression="HALL_TYPE" />
                            <asp:BoundField DataField="TITLE" HeaderText="Movie Title" SortExpression="TITLE" />
                            <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" DataFormatString="{0:dd-MMM-yyyy}" SortExpression="SHOW_DATE" />
                            <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                            <asp:BoundField DataField="SHOW_TYPE" HeaderText="Show Type" SortExpression="SHOW_TYPE" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

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

    </div>
</asp:Content>
