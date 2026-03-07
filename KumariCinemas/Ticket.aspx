<%@ Page Title="Ticket Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ticket.aspx.cs" Inherits="KumariCinemas.Ticket" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Ticket Details</h1>
            <p class="page-subtitle">Manage ticket booking information and records.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT TICKET_ID, TICKET_PRICE, BOOKING_DATE, STATUS, SEAT_NUMBER FROM TICKET"
            InsertCommand="INSERT INTO TICKET (TICKET_ID, TICKET_PRICE, BOOKING_DATE, STATUS, SEAT_NUMBER) VALUES ((SELECT NVL(MAX(TICKET_ID), 0) + 1 FROM TICKET), :TICKET_PRICE, :BOOKING_DATE, :STATUS, :SEAT_NUMBER)"
            UpdateCommand="UPDATE TICKET SET TICKET_PRICE = :TICKET_PRICE, BOOKING_DATE = :BOOKING_DATE, STATUS = :STATUS, SEAT_NUMBER = :SEAT_NUMBER WHERE TICKET_ID = :TICKET_ID"
            DeleteCommand="DELETE FROM TICKET WHERE TICKET_ID = :TICKET_ID">
            <DeleteParameters>
                <asp:Parameter Name="TICKET_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="TICKET_PRICE" Type="Decimal" />
                <asp:Parameter Name="BOOKING_DATE" Type="DateTime" />
                <asp:Parameter Name="STATUS" Type="String" />
                <asp:Parameter Name="SEAT_NUMBER" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="TICKET_PRICE" Type="Decimal" />
                <asp:Parameter Name="BOOKING_DATE" Type="DateTime" />
                <asp:Parameter Name="STATUS" Type="String" />
                <asp:Parameter Name="SEAT_NUMBER" Type="String" />
                <asp:Parameter Name="TICKET_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Ticket Entry Form Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-ticket-alt me-2"></i>Ticket Entry Form
                        </h3>
                        <small class="text-muted">Create new booking or update existing ticket records.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="TICKET_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="TicketInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-tag me-1"></i>Seat Number
                                        </label>
                                        <asp:TextBox ID="SEAT_NUMBERTextBox" runat="server" 
                                            Text='<%# Bind("SEAT_NUMBER") %>' 
                                            CssClass="form-control"
                                            placeholder="e.g. B-12" />
                                        <asp:RequiredFieldValidator ID="rfvSeatNumber" runat="server" 
                                            ControlToValidate="SEAT_NUMBERTextBox" 
                                            ValidationGroup="TicketInsert" 
                                            ErrorMessage="Seat Number is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Seat Number is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-money-bill-wave me-1"></i>Ticket Price
                                        </label>
                                        <asp:TextBox ID="TICKET_PRICETextBox" runat="server" 
                                            Text='<%# Bind("TICKET_PRICE") %>' 
                                            CssClass="form-control"
                                            TextMode="Number"
                                            step="0.01"
                                            placeholder="0.00" />
                                        <asp:RequiredFieldValidator ID="rfvTicketPrice" runat="server" 
                                            ControlToValidate="TICKET_PRICETextBox" 
                                            ValidationGroup="TicketInsert" 
                                            ErrorMessage="Ticket Price is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Ticket Price is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-calendar me-1"></i>Booking Date
                                        </label>
                                        <asp:TextBox ID="BOOKING_DATETextBox" runat="server" 
                                            Text='<%# Bind("BOOKING_DATE") %>' 
                                            CssClass="form-control"
                                            TextMode="Date" />
                                        <asp:RequiredFieldValidator ID="rfvBookingDate" runat="server" 
                                            ControlToValidate="BOOKING_DATETextBox" 
                                            ValidationGroup="TicketInsert" 
                                            ErrorMessage="Booking Date is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Booking Date is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-info-circle me-1"></i>Ticket Status
                                        </label>
                                        <asp:TextBox ID="STATUSTextBox" runat="server" 
                                            Text='<%# Bind("STATUS") %>' 
                                            CssClass="form-control"
                                            placeholder="All Statuses" />
                                        <asp:RequiredFieldValidator ID="rfvStatus" runat="server" 
                                            ControlToValidate="STATUSTextBox" 
                                            ValidationGroup="TicketInsert" 
                                            ErrorMessage="Status is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Status is required" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="TicketInsert" 
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-save me-2"></i>Save Record
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" 
                                            CausesValidation="False" 
                                            CommandName="Cancel" 
                                            CssClass="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-times me-2"></i>Clear Fields
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No records selected. Use the form above to add a new ticket.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Ticket Records History Card -->
                <div class="crud-card">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-history me-2"></i>Ticket Records History
                        </h3>
                        <small class="text-muted">Search by Ticket ID or Customer name.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="TICKET_ID" 
                                DataSourceID="SqlDataSource1"
                                CssClass="gridview"
                                GridLines="None"
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="TICKET_ID" HeaderText="Ticket ID" ReadOnly="True" SortExpression="TICKET_ID" ItemStyle-Width="90px" />
                                    <asp:BoundField DataField="TICKET_PRICE" HeaderText="Ticket Price" SortExpression="TICKET_PRICE" DataFormatString="{0:C}" />
                                    <asp:BoundField DataField="BOOKING_DATE" HeaderText="Booking Date" SortExpression="BOOKING_DATE" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField DataField="STATUS" HeaderText="Status" SortExpression="STATUS" />
                                    <asp:BoundField DataField="SEAT_NUMBER" HeaderText="Seat Number" SortExpression="SEAT_NUMBER" />
                                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" HeaderText="Actions" ButtonType="Link" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</asp:Content>
