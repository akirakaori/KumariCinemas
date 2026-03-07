<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>

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
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, EMAIL, CONTACT_NUMBER FROM CUSTOMER"
            InsertCommand="INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, EMAIL, CONTACT_NUMBER) VALUES ((SELECT NVL(MAX(CUSTOMER_ID), 0) + 1 FROM CUSTOMER), :CUSTOMER_NAME, :ADDRESS, :EMAIL, :CONTACT_NUMBER)"
            UpdateCommand="UPDATE CUSTOMER SET CUSTOMER_NAME = :CUSTOMER_NAME, ADDRESS = :ADDRESS, EMAIL = :EMAIL, CONTACT_NUMBER = :CONTACT_NUMBER WHERE CUSTOMER_ID = :CUSTOMER_ID"
            DeleteCommand="DELETE FROM CUSTOMER WHERE CUSTOMER_ID = :CUSTOMER_ID">
            <DeleteParameters>
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
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
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="CUSTOMER_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-user me-1"></i>Full Name
                                        </label>
                                        <asp:TextBox ID="CUSTOMER_NAMETextBox" runat="server" 
                                            Text=''<%# Bind("CUSTOMER_NAME") %>'' 
                                            CssClass="form-control"
                                            placeholder="e.g. John Doe" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-envelope me-1"></i>Email Address
                                        </label>
                                        <asp:TextBox ID="EMAILTextBox" runat="server" 
                                            Text=''<%# Bind("EMAIL") %>'' 
                                            CssClass="form-control"
                                            placeholder="john@example.com" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-phone me-1"></i>Phone Number
                                        </label>
                                        <asp:TextBox ID="CONTACT_NUMBERTextBox" runat="server" 
                                            Text=''<%# Bind("CONTACT_NUMBER") %>'' 
                                            CssClass="form-control"
                                            placeholder="+94 XX XXX XXXX" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-map-marker-alt me-1"></i>Address
                                        </label>
                                        <asp:TextBox ID="ADDRESSTextBox" runat="server" 
                                            Text=''<%# Bind("ADDRESS") %>'' 
                                            CssClass="form-control"
                                            placeholder="Detailed physical address..." />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
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
                <div class="crud-card">
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
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="CUSTOMER_ID" HeaderText="ID" ReadOnly="True" SortExpression="CUSTOMER_ID" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer" SortExpression="CUSTOMER_NAME" />
                                    <asp:BoundField DataField="EMAIL" HeaderText="Contact" SortExpression="EMAIL" />
                                    <asp:BoundField DataField="CONTACT_NUMBER" HeaderText="Phone Number" SortExpression="CONTACT_NUMBER" />
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
