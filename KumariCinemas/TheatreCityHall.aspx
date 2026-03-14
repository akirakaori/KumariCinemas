<%@ Page Title="Theatre Hall Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TheatreCityHall.aspx.cs" Inherits="KumariCinemas.TheatreCityHall" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        <div class="mb-4">
            <h1 class="page-title">Theatre Hall Management</h1>
            <p class="page-subtitle">Manage hall records for each theatre and city hall combination.</p>
        </div>

        <div class="row">
            <div class="col-12">

                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0"><i class="fas fa-door-open me-2"></i>Entry Form</h3>
                        <small class="text-muted">Add or update hall assignments for the selected theatre and city hall.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>

                        <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                            ValidationGroup="TheatreCityHall"
                            CssClass="alert alert-danger mt-3"
                            HeaderText="Please correct the following errors:"
                            DisplayMode="BulletList" />

                        <asp:HiddenField ID="hfSelectedTheatreId" runat="server" />
                        <asp:HiddenField ID="hfSelectedHallId" runat="server" />
                        <asp:HiddenField ID="hfSelectedCustomerId" runat="server" />
                        <asp:HiddenField ID="hfSelectedMovieId" runat="server" />

                        <div class="row mt-3">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-building me-1"></i>Theatre
                                </label>
                                <asp:DropDownList ID="ddlTheatre" runat="server" CssClass="form-select"
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

                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-city me-1"></i>City Hall
                                </label>
                                <asp:DropDownList ID="ddlCityHall" runat="server" CssClass="form-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlCityHall_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCityHall" runat="server"
                                    ControlToValidate="ddlCityHall"
                                    InitialValue=""
                                    ValidationGroup="TheatreCityHall"
                                    ErrorMessage="City Hall is required."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-map-marker-alt me-1"></i>Location
                                </label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-door-open me-1"></i>Hall
                                </label>
                                <asp:DropDownList ID="ddlHall" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvHall" runat="server"
                                    ControlToValidate="ddlHall"
                                    InitialValue=""
                                    ValidationGroup="TheatreCityHall"
                                    ErrorMessage="Hall is required."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-user me-1"></i>Customer
                                </label>
                                <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCustomer" runat="server"
                                    ControlToValidate="ddlCustomer"
                                    InitialValue=""
                                    ValidationGroup="TheatreCityHall"
                                    ErrorMessage="Customer is required."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                    <i class="fas fa-film me-1"></i>Movie
                                </label>
                                <asp:DropDownList ID="ddlMovie" runat="server" CssClass="form-select"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvMovie" runat="server"
                                    ControlToValidate="ddlMovie"
                                    InitialValue=""
                                    ValidationGroup="TheatreCityHall"
                                    ErrorMessage="Movie is required."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mt-3">
                            <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-emerald me-2"
                                ValidationGroup="TheatreCityHall" OnClick="btnSave_Click">
                                <i class="fas fa-save me-2"></i>Save
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-warning me-2"
                                ValidationGroup="TheatreCityHall" OnClick="btnUpdate_Click">
                                <i class="fas fa-sync-alt me-2"></i>Update
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary"
                                CausesValidation="false" OnClick="btnClear_Click">
                                <i class="fas fa-eraser me-2"></i>Clear
                            </asp:LinkButton>
                        </div>

                        <div class="mt-4 border-top pt-3">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-filter me-2 text-emerald"></i>
                                <h5 class="mb-0">Filters</h5>
                            </div>
                            <div class="row g-3 align-items-end">
                                <div class="col-md-4">
                                    <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                        <i class="fas fa-building me-1"></i>Filter Theatre
                                    </label>
                                    <asp:DropDownList ID="ddlFilterTheatre" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                        <i class="fas fa-city me-1"></i>Filter City Hall
                                    </label>
                                    <asp:DropDownList ID="ddlFilterCityHall" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                        <i class="fas fa-search me-1"></i>Filter Hall Name
                                    </label>
                                    <asp:TextBox ID="txtFilterHallName" runat="server" CssClass="form-control" placeholder="Search by hall name..."></asp:TextBox>
                                </div>
                            </div>
                            <div class="mt-3">
                                <asp:LinkButton ID="btnApplyFilter" runat="server" CssClass="btn btn-emerald me-2" OnClick="btnApplyFilter_Click">
                                    <i class="fas fa-search me-2"></i>Apply Filter
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnClearFilter" runat="server" CssClass="btn btn-outline-secondary" OnClick="btnClearFilter_Click">
                                    <i class="fas fa-broom me-2"></i>Clear Filter
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="crud-card" id="gridSection">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0"><i class="fas fa-table me-2"></i>Hall Assignments</h3>
                        <small class="text-muted">View, edit, or delete existing theatre hall records.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="gvTheatreCityHall" runat="server"
                                AutoGenerateColumns="False"
                                CssClass="gridview"
                                GridLines="None"
                                AllowPaging="True"
                                PageSize="10"
                                DataKeyNames="THEATRE_ID,HALL_ID,CUSTOMER_ID,MOVIE_ID"
                                PagerStyle-CssClass="gridview-pager"
                                OnRowCommand="gvTheatreCityHall_RowCommand"
                                OnPageIndexChanging="gvTheatreCityHall_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre" />
                                    <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City Hall" />
                                    <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Location" />
                                    <asp:BoundField DataField="HALL_NAME" HeaderText="Hall Name" />
                                    <asp:BoundField DataField="HALL_TYPE" HeaderText="Hall Type" />
                                    <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Capacity" />
                                    <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" />
                                    <asp:BoundField DataField="MOVIE_TITLE" HeaderText="Movie" />
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemStyle CssClass="text-center" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server"
                                                CommandName="EditRow"
                                                CommandArgument='<%# Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("MOVIE_ID") %>'
                                                CssClass="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-edit"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Delete">
                                        <ItemStyle CssClass="text-center" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnDelete" runat="server"
                                                CommandName="DeleteRow"
                                                CommandArgument='<%# Eval("THEATRE_ID") + "|" + Eval("HALL_ID") + "|" + Eval("CUSTOMER_ID") + "|" + Eval("MOVIE_ID") %>'
                                                CssClass="btn btn-sm btn-outline-danger"
                                                OnClientClick="return confirm('Are you sure you want to delete this record?');">
                                                <i class="fas fa-trash-alt"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"></asp:SqlDataSource>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
