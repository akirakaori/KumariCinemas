<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">

        <!-- Page Header Card -->
        <div class="card shadow-sm rounded border-0 mb-4">
            <div class="card-header bg-white border-0 py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="card-title mb-1">
                            <i class="fas fa-users text-emerald me-2"></i>Customer Management
                        </h4>
                        <p class="card-subtitle text-muted small mb-0">Manage customer information and contact details</p>
                    </div>
                    <div>
                        <span class="badge bg-emerald-light text-emerald px-3 py-2">
                            <i class="fas fa-database me-1"></i>Database Connected
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- SqlDataSource -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, CONTACT_NUMBER, EMAIL FROM CUSTOMER"
            InsertCommand="INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, ADDRESS, CONTACT_NUMBER, EMAIL) VALUES ((SELECT NVL(MAX(CUSTOMER_ID),0)+1 FROM CUSTOMER), :CUSTOMER_NAME, :ADDRESS, :CONTACT_NUMBER, :EMAIL)"
            UpdateCommand="UPDATE CUSTOMER SET CUSTOMER_NAME = :CUSTOMER_NAME, ADDRESS = :ADDRESS, CONTACT_NUMBER = :CONTACT_NUMBER, EMAIL = :EMAIL WHERE CUSTOMER_ID = :CUSTOMER_ID"
            DeleteCommand="DELETE FROM CUSTOMER WHERE CUSTOMER_ID = :CUSTOMER_ID">

            <DeleteParameters>
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </DeleteParameters>

            <InsertParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
            </InsertParameters>

            <UpdateParameters>
                <asp:Parameter Name="CUSTOMER_NAME" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="CONTACT_NUMBER" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="CUSTOMER_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <!-- Customer List Card -->
        <div class="card shadow-sm rounded border-0 mb-4">
            <div class="card-header bg-white border-0 py-3">
                <h5 class="mb-0">Customer Information</h5>
            </div>
            <div class="card-body">
                <asp:GridView ID="GridView1" runat="server"
                    AllowPaging="True"
                    AllowSorting="True"
                    AutoGenerateColumns="False"
                    DataKeyNames="CUSTOMER_ID"
                    DataSourceID="SqlDataSource1"
                    CssClass="table table-hover table-striped"
                    HeaderStyle-CssClass="table-light"
                    PagerStyle-CssClass="pagination-ys">

                    <Columns>
                        <asp:BoundField DataField="CUSTOMER_ID" HeaderText="Customer ID" ReadOnly="True" SortExpression="CUSTOMER_ID" />
                        <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="Customer Name" SortExpression="CUSTOMER_NAME" />
                        <asp:BoundField DataField="ADDRESS" HeaderText="Address" SortExpression="ADDRESS" />
                        <asp:BoundField DataField="CONTACT_NUMBER" HeaderText="Contact Number" SortExpression="CONTACT_NUMBER" />
                        <asp:BoundField DataField="EMAIL" HeaderText="Email" SortExpression="EMAIL" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" HeaderText="Actions" ButtonType="Button" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Add New Customer Card -->
        <div class="card shadow-sm rounded border-0">
            <div class="card-header bg-emerald text-white py-3">
                <h5 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Add New Customer</h5>
            </div>
            <div class="card-body">
                <asp:FormView ID="FormView1" runat="server" DataKeyNames="CUSTOMER_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                    <InsertItemTemplate>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Customer Name</label>
                                <asp:TextBox ID="CUSTOMER_NAMETextBox" runat="server" Text='<%# Bind("CUSTOMER_NAME") %>' CssClass="form-control" placeholder="Enter customer name" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Address</label>
                                <asp:TextBox ID="ADDRESSTextBox" runat="server" Text='<%# Bind("ADDRESS") %>' CssClass="form-control" placeholder="Enter address" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Contact Number</label>
                                <asp:TextBox ID="CONTACT_NUMBERTextBox" runat="server" Text='<%# Bind("CONTACT_NUMBER") %>' CssClass="form-control" placeholder="Enter contact number" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email</label>
                                <asp:TextBox ID="EMAILTextBox" runat="server" Text='<%# Bind("EMAIL") %>' CssClass="form-control" placeholder="Enter email address" />
                            </div>

                            <div class="col-12 mt-4">
                                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-emerald me-2">
                                    <i class="fas fa-save me-2"></i>Insert Customer
                                </asp:LinkButton>

                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="btn btn-outline-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </InsertItemTemplate>

                    <ItemTemplate>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i>
                            Customer added successfully!
                            <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" CssClass="btn btn-sm btn-emerald ms-3">
                                Add Another Customer
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:FormView>
            </div>
        </div>

    </div>

    <style>
        .bg-emerald {
            background: linear-gradient(135deg, #10b981, #059669) !important;
        }

        .btn-emerald {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .btn-emerald:hover {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
        }

        .bg-emerald-light {
            background-color: #ecfdf5 !important;
        }

        .text-emerald {
            color: #10b981 !important;
        }

        .table th {
            background-color: #f3f4f6;
            font-weight: 600;
            color: #374151;
            border-bottom: 2px solid #10b981;
        }

        .table-hover tbody tr:hover {
            background-color: #ecfdf5;
        }
    </style>
</asp:Content>