<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="KumariCinemas.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta http-equiv="refresh" content="30" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Welcome Banner / Hero Section -->
        <div class="welcome-banner shadow-sm rounded mb-4">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <p class="section-label mb-2">DASHBOARD OVERVIEW</p>
                    <h2 class="welcome-title mb-3">Welcome back</h2>
                    <p class="welcome-description mb-4">
                        Management of cinematic experiences begins here. Access comprehensive tools for movie scheduling, theatre allocation, and real-time ticket sales tracking. Use the reports module for data-driven decisions on theatre occupancy and revenue performance.
                    </p>
                    <div class="button-group">
                        <a href="Show.aspx" class="btn btn-emerald btn-lg me-2">
                            <i class="fas fa-plus-circle me-2"></i> New Movie Show
                        </a>
                        <a href="CustomerTicket.aspx" class="btn btn-outline-emerald btn-lg">
                            View Reports <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </div>
                </div>
                <div class="col-md-4 text-center">
                    <div class="hero-illustration">
                        <i class="fas fa-film-slash fa-8x text-emerald-light"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Summary Cards -->
        <div class="row g-4 mb-4">
            <!-- Total Customers Card -->
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card shadow-sm rounded border-0" title="Query: SELECT COUNT(*) FROM CUSTOMER">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="stat-label mb-1">
                                    TOTAL CUSTOMERS
                                    <i class="fas fa-database text-muted ms-1" style="font-size: 0.7rem;" title="Live from database"></i>
                                </p>
                                <h3 class="stat-value mb-0">
                                    <asp:Label ID="lblTotalCustomers" runat="server" Text="0"></asp:Label>
                                </h3>
                                <small class="stat-change text-success">
                                    <i class="fas fa-arrow-up"></i> Active registered users
                                </small>
                            </div>
                            <div class="stat-icon stat-icon-customers">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Movies Card -->
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card shadow-sm rounded border-0" title="Query: SELECT COUNT(*) FROM MOVIE">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="stat-label mb-1">
                                    TOTAL MOVIES
                                    <i class="fas fa-database text-muted ms-1" style="font-size: 0.7rem;" title="Live from database"></i>
                                </p>
                                <h3 class="stat-value mb-0">
                                    <asp:Label ID="lblTotalMovies" runat="server" Text="0"></asp:Label>
                                </h3>
                                <small class="stat-change text-muted">
                                    Across all genres
                                </small>
                            </div>
                            <div class="stat-icon stat-icon-movies">
                                <i class="fas fa-video"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Theatres Card -->
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card shadow-sm rounded border-0" title="Query: SELECT COUNT(*) FROM THEATRE">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="stat-label mb-1">
                                    TOTAL THEATRES
                                    <i class="fas fa-database text-muted ms-1" style="font-size: 0.7rem;" title="Live from database"></i>
                                </p>
                                <h3 class="stat-value mb-0">
                                    <asp:Label ID="lblTotalTheatres" runat="server" Text="0"></asp:Label>
                                </h3>
                                <small class="stat-change text-muted">
                                    Global Partnered locations
                                </small>
                            </div>
                            <div class="stat-icon stat-icon-theatres">
                                <i class="fas fa-building"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Tickets Card -->
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card shadow-sm rounded border-0" title="Query: SELECT COUNT(*) FROM TICKET">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="stat-label mb-1">
                                    TOTAL TICKETS
                                    <i class="fas fa-database text-muted ms-1" style="font-size: 0.7rem;" title="Live from database"></i>
                                </p>
                                <h3 class="stat-value mb-0">
                                    <asp:Label ID="lblTotalTickets" runat="server" Text="0"></asp:Label>
                                </h3>
                                <small class="stat-change text-success">
                                    <i class="fas fa-arrow-up"></i> Sold this period
                                </small>
                            </div>
                            <div class="stat-icon stat-icon-tickets">
                                <i class="fas fa-ticket-alt"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Row: Recent Activity & Quick Report Links -->
        <div class="row g-4">
            <!-- Recent System Activity -->
            <div class="col-lg-7">
                <div class="card shadow-sm rounded border-0">
                    <div class="card-header bg-white border-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">Recent System Activity</h5>
                            <a href="#" class="text-emerald small">View All</a>
                        </div>
                        <p class="card-subtitle text-muted small mb-0 mt-1">Real-time updates from the booking engine</p>
                    </div>
                    <div class="card-body">
                        <div class="activity-list">
                            <!-- Recent activities will be rendered from the database -->

                            <asp:Repeater ID="rptRecentActivity" runat="server" DataSourceID="SqlDataSourceRecentActivity">
<ItemTemplate>

<div class="activity-item">
    <div class="activity-icon">
        <i class="fas fa-user-circle"></i>
    </div>

    <div class="activity-content">

        <p class="activity-title mb-1">
            <strong><%# Eval("CUSTOMER_NAME") %></strong>
        </p>

        <p class="activity-description mb-1">
            Booked ticket for '<%# Eval("TITLE") %>'
        </p>

        <div class="d-flex justify-content-between align-items-center">

            <small class="activity-time text-muted">
                <%# Eval("BOOKING_DATE","{0:g}") %>
            </small>

            <span class="badge bg-emerald-light">
                <%# Eval("STATUS") %>
            </span>

        </div>

    </div>
</div>

</ItemTemplate>
</asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Report Links -->
            <div class="col-lg-5">
                <div class="card shadow-sm rounded border-0">
                    <div class="card-header bg-white border-0 py-3">
                        <h5 class="card-title mb-0">Quick Report Links</h5>
                        <p class="card-subtitle text-muted small mb-0 mt-1">One-click access to generated data</p>
                    </div>
                    <div class="card-body">
                        <div class="report-links">
                            <a href="CustomerTicket.aspx" class="report-link-card">
                                <div class="report-icon">
                                    <i class="fas fa-file-invoice"></i>
                                </div>
                                <div class="report-details">
                                    <h6 class="mb-1">Customer Ticket Report</h6>
                                    <p class="mb-0 text-muted small">Detailed purchase history</p>
                                </div>
                                <div class="report-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>

                            <a href="TheatreMovie.aspx" class="report-link-card">
                                <div class="report-icon">
                                    <i class="fas fa-film"></i>
                                </div>
                                <div class="report-details">
                                    <h6 class="mb-1">Theatre Movie Report</h6>
                                    <p class="mb-0 text-muted small">Screen utilization by film</p>
                                </div>
                                <div class="report-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>

                            <a href="TopTheatreOccupancy.aspx" class="report-link-card">
                                <div class="report-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div class="report-details">
                                    <h6 class="mb-1">Occupancy Report</h6>
                                    <p class="mb-0 text-muted small">Top performing theatre halls</p>
                                </div>
                                <div class="report-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <asp:SqlDataSource ID="SqlDataSourceRecentActivity" runat="server"
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
        SelectCommand="
SELECT * FROM (
    SELECT 
        C.CUSTOMER_NAME,
        M.TITLE,
        T.BOOKING_DATE,
        T.STATUS
    FROM TICKET T
    JOIN SHOW_TICKET ST ON T.TICKET_ID = ST.TICKET_ID
    JOIN CUSTOMER C ON ST.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
    ORDER BY T.BOOKING_DATE DESC
) WHERE ROWNUM &lt;= 5">
    </asp:SqlDataSource>

    <!-- Hidden SqlDataSources for counts -->
    <asp:SqlDataSource ID="SqlDataSourceCustomers" runat="server" 
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
        SelectCommand="SELECT COUNT(*) AS TOTAL FROM CUSTOMER">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceMovies" runat="server" 
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
        SelectCommand="SELECT COUNT(*) AS TOTAL FROM MOVIE">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceTheatres" runat="server" 
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
        SelectCommand="SELECT COUNT(*) AS TOTAL FROM THEATRE">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
        SelectCommand="SELECT COUNT(*) AS TOTAL FROM TICKET">
    </asp:SqlDataSource>
</asp:Content>

