<%@ Page Title="Hall Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hall.aspx.cs" Inherits="KumariCinemas.Hall" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Hall Details</h1>
            <p class="page-subtitle">Configure and manage individual cinema screens, capacities, and technology across your theatre network.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT HALL_ID, HALL_CAPACITY, HALL_NAME, HALL_TYPE FROM HALL"
            InsertCommand="INSERT INTO HALL (HALL_ID, HALL_CAPACITY, HALL_NAME, HALL_TYPE) VALUES ((SELECT NVL(MAX(HALL_ID), 0) + 1 FROM HALL), :HALL_CAPACITY, :HALL_NAME, :HALL_TYPE)"
            UpdateCommand="UPDATE HALL SET HALL_CAPACITY = :HALL_CAPACITY, HALL_NAME = :HALL_NAME, HALL_TYPE = :HALL_TYPE WHERE HALL_ID = :HALL_ID"
            DeleteCommand="DELETE FROM HALL WHERE HALL_ID = :HALL_ID">
            <DeleteParameters>
                <asp:Parameter Name="HALL_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="HALL_CAPACITY" Type="Int32" />
                <asp:Parameter Name="HALL_NAME" Type="String" />
                <asp:Parameter Name="HALL_TYPE" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="HALL_CAPACITY" Type="Int32" />
                <asp:Parameter Name="HALL_NAME" Type="String" />
                <asp:Parameter Name="HALL_TYPE" Type="String" />
                <asp:Parameter Name="HALL_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Hall Configuration Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-door-open me-2"></i>Hall Configuration
                        </h3>
                        <small class="text-muted">Enter hall specifications and associate with a theatre location.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="HALL_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="HallInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-tag me-1"></i>Hall Name / Number
                                        </label>
                                        <asp:TextBox ID="HALL_NAMETextBox" runat="server" 
                                            Text='<%# Bind("HALL_NAME") %>' 
                                            CssClass="form-control"
                                            placeholder="e.g. Screen 01 or IMAX Hall" />
                                        <asp:RequiredFieldValidator ID="rfvHallName" runat="server" 
                                            ControlToValidate="HALL_NAMETextBox" 
                                            ValidationGroup="HallInsert" 
                                            ErrorMessage="Hall Name is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Hall Name is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-certificate me-1"></i>Hall Category
                                        </label>
                                        <asp:TextBox ID="HALL_TYPETextBox" runat="server" 
                                            Text='<%# Bind("HALL_TYPE") %>' 
                                            CssClass="form-control"
                                            placeholder="Select Hall Type" />
                                        <asp:RequiredFieldValidator ID="rfvHallType" runat="server" 
                                            ControlToValidate="HALL_TYPETextBox" 
                                            ValidationGroup="HallInsert" 
                                            ErrorMessage="Hall Type is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Hall Type is required" />
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-users me-1"></i>Seating Capacity
                                        </label>
                                        <asp:TextBox ID="HALL_CAPACITYTextBox" runat="server" 
                                            Text='<%# Bind("HALL_CAPACITY") %>' 
                                            CssClass="form-control"
                                            TextMode="Number"
                                            placeholder="Total seats" />
                                        <asp:RequiredFieldValidator ID="rfvCapacity" runat="server" 
                                            ControlToValidate="HALL_CAPACITYTextBox" 
                                            ValidationGroup="HallInsert" 
                                            ErrorMessage="Seating Capacity is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Seating Capacity is required" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="HallInsert" 
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-plus-circle me-2"></i>Add Hall Record
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" 
                                            CausesValidation="False" 
                                            CommandName="Cancel" 
                                            CssClass="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-redo me-2"></i>Reset Form
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No records selected. Use the form above to add a new hall.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Existing Hall Records Card -->
                <div class="crud-card">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-list me-2"></i>Existing Hall Records
                        </h3>
                        <small class="text-muted">View and manage all active cinema screens across the theatres.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="HALL_ID" 
                                DataSourceID="SqlDataSource1"
                                CssClass="gridview"
                                GridLines="None"
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="HALL_ID" HeaderText="Hall ID" ReadOnly="True" SortExpression="HALL_ID" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Hall Capacity" SortExpression="HALL_CAPACITY" ItemStyle-Width="120px" />
                                    <asp:BoundField DataField="HALL_NAME" HeaderText="Hall Name" SortExpression="HALL_NAME" />
                                    <asp:BoundField DataField="HALL_TYPE" HeaderText="Hall Type" SortExpression="HALL_TYPE" />
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
