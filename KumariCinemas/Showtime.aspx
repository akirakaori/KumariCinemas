<%@ Page Title="Showtime Management" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="Showtime.aspx.cs"
Inherits="KumariCinemas.Showtime" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container-fluid px-4 py-4">

    <h2>Showtime Management</h2>

    <asp:Label ID="errorAlert" ClientIDMode="Static" runat="server"
        CssClass="d-none" Visible="false" EnableViewState="false"></asp:Label>

    <!-- FILTER CARD -->
    <div class="section-card mb-4">
        <div class="section-card-header">
            <div class="d-flex align-items-center">
                <i class="fas fa-filter me-2"></i>
                <div>
                    <h3 class="section-card-title mb-0">Filter Showtime Records</h3>
                    <p class="section-card-subtitle mb-0">Filter by theatre branch, movie, hall, show type, and show date.</p>
                </div>
            </div>
        </div>
        <div class="section-card-body">
            <div class="row g-3">
                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre</label>
                    <asp:DropDownList ID="ddlFilterTheatre" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Movie</label>
                    <asp:DropDownList ID="ddlFilterMovie" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall</label>
                    <asp:DropDownList ID="ddlFilterHall" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Type</label>
                    <asp:DropDownList ID="ddlFilterShowType" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="All Show Types" Value="" />
                        <asp:ListItem Text="Morning" Value="Morning" />
                        <asp:ListItem Text="Afternoon" Value="Afternoon" />
                        <asp:ListItem Text="Evening" Value="Evening" />
                        <asp:ListItem Text="Night" Value="Night" />
                    </asp:DropDownList>
                </div>

                <div class="col-lg-2">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Date</label>
                    <asp:TextBox ID="txtFilterDate" runat="server" TextMode="Date" CssClass="form-control form-control-lg" />
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <asp:LinkButton ID="btnApplyFilters" runat="server"
                    CssClass="btn btn-emerald px-4"
                    OnClick="btnApplyFilters_Click">
                    <i class="fas fa-filter me-2"></i>Apply Filters
                </asp:LinkButton>

                <asp:LinkButton ID="btnResetFilters" runat="server"
                    CssClass="btn btn-outline-secondary px-4"
                    OnClick="btnResetFilters_Click">
                    <i class="fas fa-undo me-2"></i>Reset
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- FORM CARD -->
    <div class="card shadow-sm border-0 mb-4 bg-light">
        <div class="card-header bg-transparent border-0 pb-0">
            <div class="d-flex align-items-center">
                <i class="fas fa-clock text-success me-2"></i>
                <div>
                    <h5 class="mb-0">Showtime Information</h5>
                    <small class="text-muted">Manage show schedules by theatre branch, hall, movie, and customer.</small>
                </div>
            </div>
        </div>
        <div class="card-body">

            <asp:ValidationSummary ID="ShowtimeInsertSummary" runat="server"
                ValidationGroup="ShowtimeInsert"
                CssClass="alert alert-danger"
                HeaderText="Please correct the following errors:"
                DisplayMode="BulletList" />

            <asp:ValidationSummary ID="ShowtimeEditSummary" runat="server"
                ValidationGroup="ShowtimeEdit"
                CssClass="alert alert-danger"
                HeaderText="Please correct the following errors:"
                DisplayMode="BulletList" />

            <asp:HiddenField ID="hfSelectedShowId" runat="server" />
            <asp:HiddenField ID="hfOldShowId" runat="server" />
            <asp:HiddenField ID="hfOldCustomerId" runat="server" />
            <asp:HiddenField ID="hfOldTheatreId" runat="server" />
            <asp:HiddenField ID="hfOldHallId" runat="server" />
            <asp:HiddenField ID="hfOldMovieId" runat="server" />

            <div class="row g-3">
                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre</label>
                    <asp:DropDownList ID="ddlTheatre" runat="server"
                        CssClass="form-select form-select-lg"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlTheatre_SelectedIndexChanged" />
                    <asp:RequiredFieldValidator ID="rfvTheatre" runat="server"
                        ControlToValidate="ddlTheatre"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Theatre is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvTheatreEdit" runat="server"
                        ControlToValidate="ddlTheatre"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Theatre is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre City Hall</label>
                    <asp:TextBox ID="txtTheatreCityHall" runat="server" CssClass="form-control form-control-lg" ReadOnly="true" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Theatre Location</label>
                    <asp:TextBox ID="txtTheatreLocation" runat="server" CssClass="form-control form-control-lg" ReadOnly="true" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall</label>
                    <asp:DropDownList ID="ddlHall" runat="server"
                        CssClass="form-select form-select-lg"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlHall_SelectedIndexChanged" />
                    <asp:RequiredFieldValidator ID="rfvHall" runat="server"
                        ControlToValidate="ddlHall"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Hall is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvHallEdit" runat="server"
                        ControlToValidate="ddlHall"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Hall is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall Type</label>
                    <asp:TextBox ID="txtHallType" runat="server" CssClass="form-control form-control-lg" ReadOnly="true" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Hall Capacity</label>
                    <asp:TextBox ID="txtHallCapacity" runat="server" CssClass="form-control form-control-lg" ReadOnly="true" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Movie</label>
                    <asp:DropDownList ID="ddlMovie" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvMovie" runat="server"
                        ControlToValidate="ddlMovie"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Movie is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvMovieEdit" runat="server"
                        ControlToValidate="ddlMovie"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Movie is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-3">
                    <label class="form-label fw-bold text-muted text-uppercase small">Customer</label>
                    <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select form-select-lg" />
                    <asp:RequiredFieldValidator ID="rfvCustomer" runat="server"
                        ControlToValidate="ddlCustomer"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Customer is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvCustomerEdit" runat="server"
                        ControlToValidate="ddlCustomer"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Customer is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-4">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Date</label>
                    <asp:TextBox ID="txtShowDate" runat="server" TextMode="Date" CssClass="form-control form-control-lg" />
                    <asp:RequiredFieldValidator ID="rfvShowDate" runat="server"
                        ControlToValidate="txtShowDate"
                        CssClass="text-danger small"
                        ErrorMessage="Show date is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvShowDateEdit" runat="server"
                        ControlToValidate="txtShowDate"
                        CssClass="text-danger small"
                        ErrorMessage="Show date is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-4">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Time</label>
                    <asp:TextBox ID="txtShowTime" runat="server" TextMode="Time" CssClass="form-control form-control-lg" />
                    <asp:RequiredFieldValidator ID="rfvShowTime" runat="server"
                        ControlToValidate="txtShowTime"
                        CssClass="text-danger small"
                        ErrorMessage="Show time is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvShowTimeEdit" runat="server"
                        ControlToValidate="txtShowTime"
                        CssClass="text-danger small"
                        ErrorMessage="Show time is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>

                <div class="col-lg-4">
                    <label class="form-label fw-bold text-muted text-uppercase small">Show Type</label>
                    <asp:DropDownList ID="ddlShowType" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="Select Show Type" Value="" />
                        <asp:ListItem Text="Morning" Value="Morning" />
                        <asp:ListItem Text="Afternoon" Value="Afternoon" />
                        <asp:ListItem Text="Evening" Value="Evening" />
                        <asp:ListItem Text="Night" Value="Night" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvShowType" runat="server"
                        ControlToValidate="ddlShowType"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Show type is required."
                        ValidationGroup="ShowtimeInsert"
                        Display="Dynamic" />
                    <asp:RequiredFieldValidator ID="rfvShowTypeEdit" runat="server"
                        ControlToValidate="ddlShowType"
                        InitialValue=""
                        CssClass="text-danger small"
                        ErrorMessage="Show type is required."
                        ValidationGroup="ShowtimeEdit"
                        Display="Dynamic" />
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <asp:LinkButton ID="btnSave" runat="server"
                    CssClass="btn btn-emerald px-4"
                    OnClick="btnSave_Click"
                    CausesValidation="True"
                    ValidationGroup="ShowtimeInsert">
                    <i class="fas fa-save me-2"></i>Save Showtime
                </asp:LinkButton>

                <asp:LinkButton ID="btnUpdate" runat="server"
                    CssClass="btn btn-warning px-4"
                    OnClick="btnUpdate_Click"
                    CausesValidation="True"
                    ValidationGroup="ShowtimeEdit"
                    Visible="false">
                    <i class="fas fa-save me-2"></i>Update Showtime
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

    <!-- GRIDVIEW -->
    <div class="section-card">
        <div class="section-card-header">
            <div class="d-flex align-items-center">
                <i class="fas fa-calendar-alt me-2"></i>
                <div>
                    <h3 class="section-card-title mb-0">Showtime Directory</h3>
                    <p class="section-card-subtitle mb-0">Search, sort, filter, and manage scheduled movie shows.</p>
                </div>
            </div>
        </div>
        <div class="section-card-body">
            <div class="table-container">
                <asp:GridView ID="GridView1"
                    runat="server"
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
                        <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre" SortExpression="THEATRE_NAME" />
                        <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City Hall" SortExpression="THEATRE_CITY_HALL" />
                        <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Location" SortExpression="THEATRE_LOCATION" />
                        <asp:BoundField DataField="HALL_NAME" HeaderText="Hall" SortExpression="HALL_NAME" />
                        <asp:BoundField DataField="HALL_TYPE" HeaderText="Hall Type" SortExpression="HALL_TYPE" />
                        <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Capacity" SortExpression="HALL_CAPACITY" />
                        <asp:BoundField DataField="TITLE" HeaderText="Movie" SortExpression="TITLE" />
                        <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" SortExpression="CUSTOMER_NAME" />
                        <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" SortExpression="SHOW_DATE" />
                        <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                        <asp:BoundField DataField="SHOW_TYPE" HeaderText="Show Type" SortExpression="SHOW_TYPE" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    CommandName="EditShowtime"
                                    CommandArgument='<%# Eval("SHOW_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("MOVIE_ID") %>'
                                    CssClass="table-action-link">
                                    Edit
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CommandName="DeleteShowtime"
                                    CommandArgument='<%# Eval("SHOW_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("MOVIE_ID") %>'
                                    CssClass="table-action-link"
                                    OnClientClick="return confirm('Are you sure you want to delete this showtime?');">
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
                if (alertEl && alertEl.parentNode) {
                    alertEl.parentNode.removeChild(alertEl);
                }
            });
        }, 3000);
    });
</script>

</asp:Content>