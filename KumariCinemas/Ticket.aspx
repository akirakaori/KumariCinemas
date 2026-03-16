<%@ Page Title="Ticket Management" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="Ticket.aspx.cs"
Inherits="KumariCinemas.Ticket" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container-fluid px-4 py-4">

    <h2>Ticket Management</h2>

    <asp:Label ID="errorAlert" ClientIDMode="Static" runat="server"
        CssClass="d-none" Visible="false" EnableViewState="false"></asp:Label>

    <!-- FORM CARD -->
    <div class="card shadow-sm border-0 mb-4 bg-light">
        <div class="card-header bg-transparent border-0 pb-0">
            <div class="d-flex align-items-center">
                <i class="fas fa-ticket-alt text-success me-2"></i>
                <div>
                    <h5 class="mb-0">Ticket Information</h5>
                    <small class="text-muted">Create and manage ticket booking records.</small>
                </div>
            </div>
        </div>

        <div class="card-body">
            <asp:ValidationSummary ID="TicketInsertSummary" runat="server"
                ValidationGroup="TicketInsert"
                CssClass="alert alert-danger"
                HeaderText="Please correct the following errors:"
                DisplayMode="BulletList" />

            <asp:ValidationSummary ID="TicketEditSummary" runat="server"
                ValidationGroup="TicketEdit"
                CssClass="alert alert-danger"
                HeaderText="Please correct the following errors:"
                DisplayMode="BulletList" />

            <asp:HiddenField ID="hfSelectedTicketId" runat="server" />

            <div class="row g-3">
                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Customer</label>
                    <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvCustomer" runat="server"
                        ControlToValidate="ddlCustomer"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Customer is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvCustomerEdit" runat="server"
                        ControlToValidate="ddlCustomer"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Customer is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Movie</label>
                    <asp:DropDownList ID="ddlMovie" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvMovie" runat="server"
                        ControlToValidate="ddlMovie"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Movie is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvMovieEdit" runat="server"
                        ControlToValidate="ddlMovie"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Movie is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre Branch</label>
                    <asp:DropDownList ID="ddlTheatre" runat="server"
                        CssClass="form-select form-select-lg"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlTheatre_SelectedIndexChanged" />
                    <asp:RequiredFieldValidator ID="rfvTheatre" runat="server"
                        ControlToValidate="ddlTheatre"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Theatre is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvTheatreEdit" runat="server"
                        ControlToValidate="ddlTheatre"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Theatre is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall</label>
                    <asp:DropDownList ID="ddlHall" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvHall" runat="server"
                        ControlToValidate="ddlHall"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Hall is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvHallEdit" runat="server"
                        ControlToValidate="ddlHall"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Hall is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show</label>
                    <asp:DropDownList ID="ddlShow" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvShow" runat="server"
                        ControlToValidate="ddlShow"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Show is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvShowEdit" runat="server"
                        ControlToValidate="ddlShow"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Show is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Seat Number</label>
                    <asp:TextBox ID="txtSeatNumber" runat="server"
                        CssClass="form-control form-control-lg"
                        placeholder="e.g. A5" />
                    <asp:RequiredFieldValidator ID="rfvSeat" runat="server"
                        ControlToValidate="txtSeatNumber"
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Seat number is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvSeatEdit" runat="server"
                        ControlToValidate="txtSeatNumber"
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Seat number is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Ticket Price</label>
                    <asp:TextBox ID="txtTicketPrice" runat="server"
                        CssClass="form-control form-control-lg"
                        TextMode="Number"
                        placeholder="450" />
                    <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                        ControlToValidate="txtTicketPrice"
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Ticket price is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvPriceEdit" runat="server"
                        ControlToValidate="txtTicketPrice"
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Ticket price is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Booking Date</label>
                    <asp:TextBox ID="txtBookingDate" runat="server"
                        CssClass="form-control form-control-lg"
                        TextMode="Date" />
                    <asp:RequiredFieldValidator ID="rfvBookingDate" runat="server"
                        ControlToValidate="txtBookingDate"
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Booking date is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvBookingDateEdit" runat="server"
                        ControlToValidate="txtBookingDate"
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Booking date is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="Select Status" Value="" />
                        <asp:ListItem Text="Booked" Value="Booked" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                        <asp:ListItem Text="Paid" Value="Paid" />
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Used" Value="Used" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvStatus" runat="server"
                        ControlToValidate="ddlStatus"
                        InitialValue=""
                        ValidationGroup="TicketInsert"
                        ErrorMessage="Status is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvStatusEdit" runat="server"
                        ControlToValidate="ddlStatus"
                        InitialValue=""
                        ValidationGroup="TicketEdit"
                        ErrorMessage="Status is required."
                        CssClass="text-danger small"
                        Display="Dynamic" />
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <asp:LinkButton ID="btnSave" runat="server"
                    CssClass="btn btn-emerald px-4"
                    OnClick="btnSave_Click"
                    CausesValidation="True"
                    ValidationGroup="TicketInsert">
                    <i class="fas fa-save me-2"></i>Save Ticket
                </asp:LinkButton>

                <asp:LinkButton ID="btnUpdate" runat="server"
                    CssClass="btn btn-warning px-4"
                    OnClick="btnUpdate_Click"
                    CausesValidation="True"
                    ValidationGroup="TicketEdit"
                    Visible="false">
                    <i class="fas fa-save me-2"></i>Update Ticket
                </asp:LinkButton>

                <asp:LinkButton ID="btnClear" runat="server"
                    CssClass="btn btn-outline-secondary px-4"
                    OnClick="btnClear_Click"
                    CausesValidation="False">
                    <i class="fas fa-times me-2"></i>Clear
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- FILTER CARD -->
    <div class="section-card mb-4">
        <div class="section-card-header">
            <div class="d-flex align-items-center">
                <i class="fas fa-filter me-2"></i>
                <div>
                    <h3 class="section-card-title mb-0">Ticket Filters</h3>
                    <p class="section-card-subtitle mb-0">Filter tickets by customer, movie, theatre, hall, date, and status.</p>
                </div>
            </div>
        </div>
        <div class="section-card-body">
            <div class="row g-3">
                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Customer</label>
                    <asp:DropDownList ID="ddlFilterCustomer" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Movie</label>
                    <asp:DropDownList ID="ddlFilterMovie" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre</label>
                    <asp:DropDownList ID="ddlFilterTheatre" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall</label>
                    <asp:DropDownList ID="ddlFilterHall" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Status</label>
                    <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Booked" Value="Booked" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                        <asp:ListItem Text="Paid" Value="Paid" />
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Used" Value="Used" />
                    </asp:DropDownList>
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Date</label>
                    <asp:TextBox ID="txtFilterShowDate" runat="server" TextMode="Date" CssClass="form-control form-control-lg" />
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <asp:LinkButton ID="btnApplyFilters" runat="server"
                    CssClass="btn btn-emerald px-4"
                    OnClick="btnApplyFilters_Click">
                    <i class="fas fa-search me-2"></i>Apply Filters
                </asp:LinkButton>

                <asp:LinkButton ID="btnResetFilters" runat="server"
                    CssClass="btn btn-outline-secondary px-4"
                    OnClick="btnResetFilters_Click">
                    <i class="fas fa-undo me-2"></i>Reset
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- GRIDVIEW -->
    <div class="section-card">
        <div class="section-card-header">
            <div class="d-flex align-items-center">
                <i class="fas fa-ticket-alt me-2"></i>
                <div>
                    <h3 class="section-card-title mb-0">Ticket Directory</h3>
                    <p class="section-card-subtitle mb-0">View, sort, filter, edit, and delete ticket booking records.</p>
                </div>
            </div>
        </div>

        <div class="section-card-body">
            <div class="table-container">
                <asp:GridView ID="GridView1" runat="server"
                    AutoGenerateColumns="False"
                    AllowPaging="True"
                    AllowSorting="True"
                    PageSize="8"
                    CssClass="gridview"
                    GridLines="None"
                    PagerStyle-CssClass="gridview-pager"
                    OnPageIndexChanging="GridView1_PageIndexChanging"
                    OnSorting="GridView1_Sorting"
                    OnRowCommand="GridView1_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="TICKET_ID" HeaderText="Ticket ID" SortExpression="TICKET_ID" />
                        <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" SortExpression="CUSTOMER_NAME" />
                        <asp:BoundField DataField="TITLE" HeaderText="Movie" SortExpression="TITLE" />
                        <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre" SortExpression="THEATRE_NAME" />
                        <asp:BoundField DataField="HALL_NAME" HeaderText="Hall" SortExpression="HALL_NAME" />
                        <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" SortExpression="SHOW_DATE" />
                        <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                        <asp:BoundField DataField="SEAT_NUMBER" HeaderText="Seat Number" SortExpression="SEAT_NUMBER" />
                        <asp:BoundField DataField="BOOKING_DATE" HeaderText="Booking Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" SortExpression="BOOKING_DATE" />
                        <asp:BoundField DataField="TICKET_PRICE" HeaderText="Price" DataFormatString="{0:N2}" SortExpression="TICKET_PRICE" />
                        <asp:BoundField DataField="STATUS" HeaderText="Status" SortExpression="STATUS" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    CommandName="EditTicket"
                                    CommandArgument='<%# Eval("TICKET_ID") %>'
                                    CssClass="table-action-link">
                                    Edit
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CommandName="DeleteTicket"
                                    CommandArgument='<%# Eval("TICKET_ID") %>'
                                    CssClass="table-action-link"
                                    OnClientClick="return confirm('Are you sure you want to delete this ticket and all related records?');">
                                    Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</div>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        var alertEl = document.getElementById('errorAlert');
        if (!alertEl || alertEl.classList.contains('d-none')) return;
        if (alertEl.textContent.trim().length === 0) return;

        setTimeout(function () {
            alertEl.style.transition = 'opacity 0.6s ease';
            alertEl.style.opacity = '0';

            alertEl.addEventListener('transitionend', function handler() {
                alertEl.removeEventListener('transitionend', handler);
                alertEl.classList.add('d-none');
                alertEl.style.opacity = '1';
            });
        }, 3000);
    });
</script>

</asp:Content>