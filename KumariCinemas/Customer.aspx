<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Customer Details</h1>
            <p class="page-subtitle">Maintain and audit customer information, booking history, and membership records for the cinema booking system.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME, CONTACT_NUMBER, EMAIL, ADDRESS FROM CUSTOMER"
            InsertCommand="INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, CONTACT_NUMBER, EMAIL, ADDRESS) VALUES ((SELECT NVL(MAX(CUSTOMER_ID), 0) + 1 FROM CUSTOMER), :CUSTOMER_NAME, :CONTACT_NUMBER, :EMAIL, :ADDRESS)"
            UpdateCommand="UPDATE CUSTOMER SET CUSTOMER_NAME = :CUSTOMER_NAME, CONTACT_NUMBER = :CONTACT_NUMBER, EMAIL = :EMAIL, ADDRESS = :ADDRESS WHERE CUSTOMER_ID = :CUSTOMER_ID"
            DeleteCommand="DELETE FROM CUSTOMER WHERE CUSTOMER_ID = :CUSTOMER_ID">
            <DeleteParameters>
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Add New Customer Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-user-plus me-2"></i>Customer Management
                        </h3>
                        <small class="text-muted">Enter customer details to register a new record or update existing ones.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="CUSTOMER_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert" OnItemInserting="FormView1_ItemInserting" OnItemUpdating="FormView1_ItemUpdating">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="CustomerInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-user me-1"></i>Full Name
                                        </label>
                                        <asp:TextBox ID="CUSTOMER_NAMETextBox" runat="server" 
                                            Text='<%# Bind("CUSTOMER_NAME") %>' 
                                            CssClass="form-control"
                                            placeholder="e.g. John Doe" 
                                            MaxLength="100" />
                                        <asp:RequiredFieldValidator ID="rfvCustomerName" runat="server" 
                                            ControlToValidate="CUSTOMER_NAMETextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Customer Name is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Customer Name is required" />
                                        <asp:RegularExpressionValidator ID="revCustomerName" runat="server" 
                                            ControlToValidate="CUSTOMER_NAMETextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Name must contain only letters and spaces (2-100 characters)" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            ValidationExpression="^[a-zA-Z\s]{2,100}$"
                                            Text="* Name must be 2-100 letters only" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-envelope me-1"></i>Email Address
                                        </label>
                                        <asp:TextBox ID="EMAILTextBox" runat="server" 
                                            Text='<%# Bind("EMAIL") %>' 
                                            CssClass="form-control"
                                            TextMode="Email"
                                            placeholder="john@example.com" />
                                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                            ControlToValidate="EMAILTextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Email Address is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Email Address is required" />
                                        <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                            ControlToValidate="EMAILTextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Please enter a valid email address (e.g., user@domain.com)" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                            Text="* Invalid email format" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-phone me-1"></i>Phone Number
                                        </label>
                                        <asp:TextBox ID="CONTACT_NUMBERTextBox" runat="server" 
                                            Text='<%# Bind("CONTACT_NUMBER") %>' 
                                            CssClass="form-control"
                                            placeholder="+94 XX XXX XXXX or 10-digit number" />
                                        <asp:RequiredFieldValidator ID="rfvContactNumber" runat="server" 
                                            ControlToValidate="CONTACT_NUMBERTextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Phone Number is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Phone Number is required" />
                                        <asp:RegularExpressionValidator ID="revContactNumber" runat="server" 
                                            ControlToValidate="CONTACT_NUMBERTextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Please enter a valid phone number (10 digits or +94XXXXXXXXX format)" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            ValidationExpression="^(\+94[0-9]{9}|[0-9]{10})$"
                                            Text="* Invalid phone format (use 10 digits or +94XXXXXXXXX)" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-map-marker-alt me-1"></i>Address
                                        </label>
                                        <asp:TextBox ID="ADDRESSTextBox" runat="server" 
                                            Text='<%# Bind("ADDRESS") %>' 
                                            CssClass="form-control"
                                            placeholder="Detailed physical address..." />
                                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" 
                                            ControlToValidate="ADDRESSTextBox" 
                                            ValidationGroup="CustomerInsert" 
                                            ErrorMessage="Address is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Address is required" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="CustomerInsert" 
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-save me-2"></i>Save Record
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" 
                                            CausesValidation="False" 
                                            CommandName="Cancel" 
                                            CssClass="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-times me-2"></i>Reset Form
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No records selected. Use the form above to add a new customer.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Customer Directory Card -->
                <div class="crud-card" id="gridSection">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-users me-2"></i>Customer Directory
                        </h3>
                        <small class="text-muted">Complete list of registered customers across all branches.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="CUSTOMER_ID" 
                                DataSourceID="SqlDataSource1"
                                CssClass="gridview"
                                GridLines="None"
                                PagerStyle-CssClass="gridview-pager"
                                OnPageIndexChanging="GridView1_PageIndexChanging"
                                OnSorting="GridView1_Sorting"
                                OnRowEditing="GridView1_RowEditing"
                                OnRowUpdating="GridView1_RowUpdating"
                                OnRowCancelingEdit="GridView1_RowCancelingEdit"
                                OnRowDeleting="GridView1_RowDeleting">
                                <Columns>
                                    <asp:BoundField DataField="CUSTOMER_ID" HeaderText="Customer ID" ReadOnly="True" SortExpression="CUSTOMER_ID" ItemStyle-Width="100px" />
                                    <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer Name" SortExpression="CUSTOMER_NAME" />
                                    <asp:BoundField DataField="CONTACT_NUMBER" HeaderText="Contact Number" SortExpression="CONTACT_NUMBER" />
                                    <asp:BoundField DataField="EMAIL" HeaderText="Email" SortExpression="EMAIL" />
                                    <asp:BoundField DataField="ADDRESS" HeaderText="Address" SortExpression="ADDRESS" />
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
