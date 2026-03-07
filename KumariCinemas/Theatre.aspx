<%@ Page Title="Theatre Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Theatre.aspx.cs" Inherits="KumariCinemas.Theatre" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Theatre Details</h1>
            <p class="page-subtitle">Maintain theatre details and related records for the Kumari Cinemas circuit.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT THEATRE_ID, THEATRE_NAME, THEATRE_CITY_HALL, THEATRE_LOCATION FROM THEATRE"
            InsertCommand="INSERT INTO THEATRE (THEATRE_ID, THEATRE_NAME, THEATRE_CITY_HALL, THEATRE_LOCATION) VALUES ((SELECT NVL(MAX(THEATRE_ID), 0) + 1 FROM THEATRE), :THEATRE_NAME, :THEATRE_CITY_HALL, :THEATRE_LOCATION)"
            UpdateCommand="UPDATE THEATRE SET THEATRE_NAME = :THEATRE_NAME, THEATRE_CITY_HALL = :THEATRE_CITY_HALL, THEATRE_LOCATION = :THEATRE_LOCATION WHERE THEATRE_ID = :THEATRE_ID"
            DeleteCommand="DELETE FROM THEATRE WHERE THEATRE_ID = :THEATRE_ID">
            <DeleteParameters>
                <asp:Parameter Name="THEATRE_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="THEATRE_NAME" Type="String" />
                <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
                <asp:Parameter Name="THEATRE_LOCATION" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="THEATRE_NAME" Type="String" />
                <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
                <asp:Parameter Name="THEATRE_LOCATION" Type="String" />
                <asp:Parameter Name="THEATRE_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Theatre Information Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-building me-2"></i>Theatre Information
                        </h3>
                        <small class="text-muted">Enter details for a new or existing cinema location.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="THEATRE_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="TheatreInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-landmark me-1"></i>Theatre Name
                                        </label>
                                        <asp:TextBox ID="THEATRE_NAMETextBox" runat="server" 
                                            Text='<%# Bind("THEATRE_NAME") %>' 
                                            CssClass="form-control"
                                            placeholder="e.g. Kumari Grand" />
                                        <asp:RequiredFieldValidator ID="rfvTheatreName" runat="server" 
                                            ControlToValidate="THEATRE_NAMETextBox" 
                                            ValidationGroup="TheatreInsert" 
                                            ErrorMessage="Theatre Name is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Theatre Name is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-map-marked-alt me-1"></i>Location / City
                                        </label>
                                        <asp:TextBox ID="THEATRE_CITY_HALLTextBox" runat="server" 
                                            Text='<%# Bind("THEATRE_CITY_HALL") %>' 
                                            CssClass="form-control"
                                            placeholder="Colombo 03" />
                                        <asp:RequiredFieldValidator ID="rfvCityHall" runat="server" 
                                            ControlToValidate="THEATRE_CITY_HALLTextBox" 
                                            ValidationGroup="TheatreInsert" 
                                            ErrorMessage="City/Hall is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* City/Hall is required" />
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-location-arrow me-1"></i>Full Address
                                        </label>
                                        <asp:TextBox ID="THEATRE_LOCATIONTextBox" runat="server" 
                                            Text='<%# Bind("THEATRE_LOCATION") %>' 
                                            CssClass="form-control"
                                            placeholder="Detailed physical address..." />
                                        <asp:RequiredFieldValidator ID="rfvLocation" runat="server" 
                                            ControlToValidate="THEATRE_LOCATIONTextBox" 
                                            ValidationGroup="TheatreInsert" 
                                            ErrorMessage="Location is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Location is required" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="TheatreInsert" 
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-save me-2"></i>Save Theatre
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" 
                                            CausesValidation="False" 
                                            CommandName="Cancel" 
                                            CssClass="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-times me-2"></i>Clear Form
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No records selected. Use the form above to add a new theatre.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Registered Theatres Card -->
                <div class="crud-card">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-store-alt me-2"></i>Registered Theatres
                        </h3>
                        <small class="text-muted">View and manage the list of active cinema locations.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="THEATRE_ID" 
                                DataSourceID="SqlDataSource1"
                                CssClass="gridview"
                                GridLines="None"
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="THEATRE_ID" HeaderText="Theatre ID" ReadOnly="True" SortExpression="THEATRE_ID" ItemStyle-Width="90px" />
                                    <asp:BoundField DataField="THEATRE_NAME" HeaderText="Theatre Name" SortExpression="THEATRE_NAME" />
                                    <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="City/Hall" SortExpression="THEATRE_CITY_HALL" />
                                    <asp:BoundField DataField="THEATRE_LOCATION" HeaderText="Location" SortExpression="THEATRE_LOCATION" />
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
