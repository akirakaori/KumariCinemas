<%@ Page Title="Theatre Hall Management" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="TheatreCityHall.aspx.cs"
Inherits="KumariCinemas.TheatreCityHall" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        <h2>Theatre Hall Management</h2>

        <asp:Label ID="lblMessage" runat="server" ClientIDMode="Static" EnableViewState="false" CssClass="d-none" Visible="false"></asp:Label>

        <div class="card shadow-sm border-0 mb-4 bg-light">
            <div class="card-header bg-transparent border-0 pb-0">
                <div class="d-flex align-items-center">
                    <i class="fas fa-door-open text-success me-2"></i>
                    <div>
                        <h5 class="mb-0">Theatre Hall Information</h5>
                        <small class="text-muted">Assign theatre branch, hall, customer, and movie details.</small>
                    </div>
                </div>
            </div>

            <div class="card-body">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                    ValidationGroup="TheatreCityHall"
                    CssClass="alert alert-danger"
                    HeaderText="Please correct the following errors:"
                    DisplayMode="BulletList" />

                <asp:HiddenField ID="hfSelectedTheatreId" runat="server" />
                <asp:HiddenField ID="hfSelectedHallId" runat="server" />
                <asp:HiddenField ID="hfSelectedCustomerId" runat="server" />
                <asp:HiddenField ID="hfSelectedMovieId" runat="server" />

                <div class="row g-3">
                    <div class="col-lg-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">Theatre Branch</label>
                        <asp:DropDownList ID="ddlTheatre" runat="server" CssClass="form-select form-select-lg"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlTheatre_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTheatre" runat="server"
                            ControlToValidate="ddlTheatre"
                            InitialValue=""
                            ValidationGroup="TheatreCityHall"
                            ErrorMessage="Theatre is required."
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>

                    <div class="col-lg-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">City Hall</label>
                        <asp:TextBox ID="txtCityHall" runat="server" CssClass="form-control form-control-lg" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="col-lg-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">Location</label>
                        <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control form-control-lg" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="col-lg-3">
                        <label class="form-label fw-bold text-muted text-uppercase small">Hall</label>
                        <asp:DropDownList ID="ddlHall" runat="server" CssClass="form-select form-select-lg"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlHall_SelectedIndexChanged"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvHall" runat="server"
                            ControlToValidate="ddlHall"
                            InitialValue=""
                            ValidationGroup="TheatreCityHall"
                            ErrorMessage="Hall is required."
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>

                    <div class="col-lg-3">
                        <label class="form-label fw-bold text-muted text-uppercase small">Hall Type</label>
                        <asp:TextBox ID="txtHallType" runat="server" CssClass="form-control form-control-lg" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="col-lg-3">
                        <label class="form-label fw-bold text-muted text-uppercase small">Hall Capacity</label>
                        <asp:TextBox ID="txtHallCapacity" runat="server" CssClass="form-control form-control-lg" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="col-lg-3">
                        <label class="form-label fw-bold text-muted text-uppercase small">Customer</label>
                        <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select form-select-lg"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCustomer" runat="server"
                            ControlToValidate="ddlCustomer"
                            InitialValue=""
                            ValidationGroup="TheatreCityHall"
                            ErrorMessage="Customer is required."
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>

                    <div class="col-lg-6">
                        <label class="form-label fw-bold text-muted text-uppercase small">Movie</label>
                        <asp:DropDownList ID="ddlMovie" runat="server" CssClass="form-select form-select-lg"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvMovie" runat="server"
                            ControlToValidate="ddlMovie"
                            InitialValue=""
                            ValidationGroup="TheatreCityHall"
                            ErrorMessage="Movie is required."
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-emerald px-4"
                        ValidationGroup="TheatreCityHall" OnClick="btnSave_Click">
                        <i class="fas fa-save me-2"></i>Save
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-warning px-4"
                        ValidationGroup="TheatreCityHall" OnClick="btnUpdate_Click" Visible="false">
                        <i class="fas fa-save me-2"></i>Update
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary px-4"
                        CausesValidation="false" OnClick="btnClear_Click">
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
                        <h3 class="section-card-title mb-0">Filter Hall Assignments</h3>
                        <p class="section-card-subtitle mb-0">Filter by theatre branch, city hall, or hall name.</p>
                    </div>
                </div>
            </div>
            <div class="section-card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">Filter Theatre Branch</label>
                        <asp:DropDownList ID="ddlFilterTheatre" runat="server" CssClass="form-select form-select-lg"></asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">Filter City Hall</label>
                        <asp:DropDownList ID="ddlFilterCityHall" runat="server" CssClass="form-select form-select-lg"></asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-muted text-uppercase small">Filter Hall Name</label>
                        <asp:TextBox ID="txtFilterHallName" runat="server" CssClass="form-control form-control-lg"
                            placeholder="Search by hall name..."></asp:TextBox>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <asp:LinkButton ID="btnApplyFilter" runat="server" CssClass="btn btn-emerald px-4" OnClick="btnApplyFilter_Click">
                        <i class="fas fa-search me-2"></i>Apply Filter
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnClearFilter" runat="server" CssClass="btn btn-outline-secondary px-4" OnClick="btnClearFilter_Click">
                        <i class="fas fa-broom me-2"></i>Clear Filter
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- GRID -->
        <div class="section-card">
            <div class="section-card-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-table me-2"></i>
                    <div>
                        <h3 class="section-card-title mb-0">Hall Assignments</h3>
                        <p class="section-card-subtitle mb-0">View, sort, edit, or delete theatre hall records.</p>
                    </div>
                </div>
            </div>
            <div class="section-card-body">
                <div class="table-container">
                    <asp:GridView ID="gvTheatreCityHall" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="gridview"
                        GridLines="None"
                        AllowPaging="True"
                        AllowSorting="True"
                        ShowHeaderWhenEmpty="True"
                        PageSize="9"
                        DataKeyNames="THEATRE_ID,HALL_ID,CUSTOMER_ID,MOVIE_ID"
                        PagerStyle-CssClass="gridview-pager"
                        OnRowCommand="gvTheatreCityHall_RowCommand"
                        OnPageIndexChanging="gvTheatreCityHall_PageIndexChanging"
                        OnSorting="gvTheatreCityHall_Sorting">

                        <Columns>
                            <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre" SortExpression="THEATRE_NAME" />
                            <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City Hall" SortExpression="THEATRE_CITY_HALL" />
                            <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Location" SortExpression="THEATRE_LOCATION" />
                            <asp:BoundField DataField="HALL_NAME" HeaderText="Hall Name" SortExpression="HALL_NAME" />
                            <asp:BoundField DataField="HALL_TYPE" HeaderText="Hall Type" SortExpression="HALL_TYPE" />
                            <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Capacity" SortExpression="HALL_CAPACITY" />
                            <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" SortExpression="CUSTOMER_NAME" />
                            <asp:BoundField DataField="MOVIE_TITLE" HeaderText="Movie" SortExpression="MOVIE_TITLE" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server"
                                        CommandName="EditRow"
                                        CommandArgument='<%# Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("MOVIE_ID") %>'
                                        CssClass="table-action-link">
                                        Edit
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server"
                                        CommandName="DeleteRow"
                                        CommandArgument='<%# Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("MOVIE_ID") %>'
                                        CssClass="table-action-link"
                                        OnClientClick="return confirm('Are you sure you want to delete this record?');">
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
            var msg = document.getElementById('lblMessage');
            if (!msg || msg.classList.contains('d-none')) {
                return;
            }

            if (msg.textContent.trim().length === 0) {
                return;
            }

            setTimeout(function () {
                msg.style.transition = 'opacity 0.6s ease';
                msg.style.opacity = '0';

                msg.addEventListener('transitionend', function handler() {
                    msg.removeEventListener('transitionend', handler);
                    if (msg) {
                        // hide the element after fade
                        msg.classList.add('d-none');
                        // reset inline styles so future messages display normally
                        msg.style.opacity = '';
                        msg.style.transition = '';
                    }
                });
            }, 3000);
        });
    </script>
</asp:Content>