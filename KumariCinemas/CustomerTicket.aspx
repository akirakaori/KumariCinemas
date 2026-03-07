<%@ Page Title="Customer Ticket Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerTicket.aspx.cs" Inherits="KumariCinemas.CustomerTicket" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Customer Ticket Report</h1>
            <p class="page-subtitle">View and analyze detailed customer booking history and ticket performance.</p>
        </div>

        <!-- Filter Section Card -->
        <div class="filter-card mb-4">
            <div class="filter-card-header">
                <h3 class="card-header-title mb-0">
                    <i class="fas fa-filter me-2"></i>Report Filters
                </h3>
            </div>
            <div class="filter-card-body">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                    ValidationGroup="CustomerSearch" 
                    CssClass="alert alert-danger" 
                    HeaderText="Please correct the following errors:" 
                    DisplayMode="BulletList" />
                <div class="row align-items-end">
                    <div class="col-md-8 mb-3 mb-md-0">
                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                            <i class="fas fa-user me-1"></i>Customer Name
                        </label>
                        <asp:DropDownList ID="ddlCustomer" runat="server"
                            CssClass="form-select"
                            DataSourceID="CustomerSource"
                            DataTextField="CUSTOMER_NAME"
                            DataValueField="CUSTOMER_ID"
                            AppendDataBoundItems="True">
                            <asp:ListItem Text="-- Select Customer --" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCustomer" runat="server" 
                            ControlToValidate="ddlCustomer" 
                            ValidationGroup="CustomerSearch" 
                            ErrorMessage="Please select a customer" 
                            Display="Dynamic" 
                            CssClass="text-danger small" 
                            Text="* Please select a customer" />
                    </div>
                    <div class="col-md-4">
                        <asp:LinkButton ID="btnSearch" runat="server"
                            CssClass="btn btn-emerald w-100"
                            CausesValidation="True"
                            ValidationGroup="CustomerSearch"
                            OnClick="btnSearch_Click">
                            <i class="fas fa-chart-bar me-2"></i>Generate Report
                        </asp:LinkButton>
                    </div>
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mt-2 d-block"></asp:Label>
            </div>
        </div>

        <!-- Report Results Card -->
        <div class="crud-card">
            <div class="crud-card-header">
                <h3 class="card-header-title mb-0">
                    <i class="fas fa-receipt me-2"></i>Booking Details
                </h3>
                <small class="text-muted">9 Records Found</small>
            </div>
            <div class="crud-card-body p-0">
                <div class="table-container">
                    <asp:GridView ID="GridView1" runat="server"
                        AutoGenerateColumns="False"
                        AllowPaging="True"
                        AllowSorting="True"
                        PageSize="5"
                        EmptyDataText="No ticket history found for the selected customer in the last 6 months."
                        DataSourceID="TicketSource"
                        CssClass="gridview"
                        GridLines="None"
                        PagerStyle-CssClass="gridview-pager">
                        <Columns>
                            <asp:BoundField DataField="TICKET_ID" HeaderText="Ticket ID" SortExpression="TICKET_ID" ItemStyle-Width="90px" />
                            <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" SortExpression="CUSTOMER_NAME" />
                            <asp:BoundField DataField="TITLE" HeaderText="Movie Name" SortExpression="TITLE" />
                            <asp:BoundField DataField="SHOW_DATE" HeaderText="Theatre / Hall" DataFormatString="{0:dd-MMM-yyyy}" SortExpression="SHOW_DATE" />
                            <asp:BoundField DataField="SHOW_TIME" HeaderText="Seat" SortExpression="SHOW_TIME" />
                            <asp:BoundField DataField="SEAT_NUMBER" HeaderText="Ticket ID" SortExpression="SEAT_NUMBER" />
                            <asp:BoundField DataField="TICKET_PRICE" HeaderText="Amount" DataFormatString="{0:N2}" SortExpression="TICKET_PRICE" />
                            <asp:BoundField DataField="STATUS" HeaderText="Status" SortExpression="STATUS" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Customer Dropdown Source -->
        <asp:SqlDataSource ID="CustomerSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME">
        </asp:SqlDataSource>

        <!-- Ticket Report Source -->
        <asp:SqlDataSource ID="TicketSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="
                SELECT C.CUSTOMER_NAME,
                       T.TICKET_ID,
                       M.TITLE,
                       S.SHOW_DATE,
                       S.SHOW_TIME,
                       T.SEAT_NUMBER,
                       T.TICKET_PRICE,
                       T.STATUS
                FROM CUSTOMER C
                JOIN SHOW_TICKET ST ON C.CUSTOMER_ID = ST.CUSTOMER_ID
                JOIN TICKET T ON ST.TICKET_ID = T.TICKET_ID
                JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
                JOIN SHOW S ON ST.SHOW_ID = S.SHOW_ID
                WHERE C.CUSTOMER_ID = :CUSTOMER_ID
                  AND T.BOOKING_DATE >= ADD_MONTHS(SYSDATE, -6)
                ORDER BY S.SHOW_DATE DESC">
            <SelectParameters>
                <asp:ControlParameter
                    Name="CUSTOMER_ID"
                    ControlID="ddlCustomer"
                    PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>
