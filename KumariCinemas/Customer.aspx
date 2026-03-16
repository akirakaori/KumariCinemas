<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="Customer.aspx.cs"
Inherits="KumariCinemas.Customer" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container-fluid px-4 py-4">

    <div class="page-header mb-4">
        <h1 class="page-title mb-1">Customer Details</h1>
        <p class="page-subtitle">Manage customer information, booking history, and membership records for the cinema booking system.</p>
    </div>

<asp:Label ID="errorAlert" ClientIDMode="Static" runat="server" CssClass="d-none" Visible="false" EnableViewState="false"></asp:Label>

<!-- SqlDataSource -->

<asp:SqlDataSource ID="SqlDataSource1" runat="server"
ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"

SelectCommand="SELECT CUSTOMER_ID, CUSTOMER_NAME, CONTACT_NUMBER, EMAIL, ADDRESS FROM CUSTOMER ORDER BY CUSTOMER_ID"

InsertCommand="INSERT INTO CUSTOMER
(CUSTOMER_ID, CUSTOMER_NAME, CONTACT_NUMBER, EMAIL, ADDRESS)
VALUES ((SELECT NVL(MAX(CUSTOMER_ID),0)+1 FROM CUSTOMER),
:CUSTOMER_NAME,:CONTACT_NUMBER,:EMAIL,:ADDRESS)"

UpdateCommand="UPDATE CUSTOMER
SET CUSTOMER_NAME=:CUSTOMER_NAME,
CONTACT_NUMBER=:CONTACT_NUMBER,
EMAIL=:EMAIL,
ADDRESS=:ADDRESS
WHERE CUSTOMER_ID=:CUSTOMER_ID"

DeleteCommand="DELETE FROM CUSTOMER WHERE CUSTOMER_ID=:CUSTOMER_ID">

<InsertParameters>
<asp:Parameter Name="CUSTOMER_NAME" Type="String"/>
<asp:Parameter Name="CONTACT_NUMBER" Type="String"/>
<asp:Parameter Name="EMAIL" Type="String"/>
<asp:Parameter Name="ADDRESS" Type="String"/>
</InsertParameters>

<UpdateParameters>
<asp:Parameter Name="CUSTOMER_NAME" Type="String"/>
<asp:Parameter Name="CONTACT_NUMBER" Type="String"/>
<asp:Parameter Name="EMAIL" Type="String"/>
<asp:Parameter Name="ADDRESS" Type="String"/>
<asp:Parameter Name="CUSTOMER_ID" Type="Int32"/>
</UpdateParameters>

<DeleteParameters>
<asp:Parameter Name="CUSTOMER_ID" Type="Int32"/>
</DeleteParameters>

</asp:SqlDataSource>


<!-- Customer Entry Card -->
<div class="section-card mb-4">
    <div class="section-card-header">
        <div class="d-flex align-items-center">
            <i class="fas fa-id-card me-2"></i>
            <div>
                <h3 class="section-card-title mb-0">Customer Entry Form</h3>
                <p class="section-card-subtitle mb-0">Create new customer records or update existing ones.</p>
            </div>
        </div>
    </div>
    <div class="section-card-body">
        <asp:ValidationSummary ID="CustomerInsertSummary" runat="server"
            ValidationGroup="CustomerInsert"
            CssClass="alert alert-danger"
            HeaderText="Please correct the following errors:"
            DisplayMode="BulletList" />
        <asp:ValidationSummary ID="CustomerEditSummary" runat="server"
            ValidationGroup="CustomerEdit"
            CssClass="alert alert-danger"
            HeaderText="Please correct the following errors:"
            DisplayMode="BulletList" />
        <asp:FormView ID="FormView1"
            runat="server"
            DataKeyNames="CUSTOMER_ID"
            DataSourceID="SqlDataSource1"
            DefaultMode="Insert">

            <InsertItemTemplate>
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">
                            <i class="fas fa-user me-2"></i>Full Name
                        </label>
                        <asp:TextBox ID="txtName" runat="server"
                            Text='<%# Bind("CUSTOMER_NAME") %>'
                            CssClass="form-control form-control-lg"
                            placeholder="e.g. Jungkook" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtName"
                            CssClass="text-danger small"
                            ErrorMessage="Customer name is required."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">
                            <i class="fas fa-envelope me-2"></i>Email Address
                        </label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            Text='<%# Bind("EMAIL") %>'
                            CssClass="form-control form-control-lg"
                            TextMode="Email"
                            placeholder="customer@email.com" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail"
                            CssClass="text-danger small"
                            ErrorMessage="Email address is required."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail"
                            CssClass="text-danger small"
                            ErrorMessage="Please enter a valid email address containing '@'."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">
                            <i class="fas fa-phone me-2"></i>Phone Number
                        </label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            Text='<%# Bind("CONTACT_NUMBER") %>'
                            CssClass="form-control form-control-lg"
                            placeholder="9876543210" />
                        <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                            ControlToValidate="txtPhone"
                            CssClass="text-danger small"
                            ErrorMessage="Contact number is required."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPhoneDigits" runat="server"
                            ControlToValidate="txtPhone"
                            CssClass="text-danger small"
                            ErrorMessage="Phone number must contain exactly 10 digits."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]{10}$" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">
                            <i class="fas fa-map-marker-alt me-2"></i>Address
                        </label>
                        <asp:TextBox ID="txtAddress" runat="server"
                            Text='<%# Bind("ADDRESS") %>'
                            CssClass="form-control form-control-lg"
                            placeholder="City, Country" />
                        <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                            ControlToValidate="txtAddress"
                            CssClass="text-danger small"
                            ErrorMessage="Address is required."
                            ValidationGroup="CustomerInsert"
                            Display="Dynamic" />
                    </div>
                </div>
                <div class="d-flex gap-2 mt-4">
                    <asp:LinkButton ID="InsertButton"
                        runat="server"
                        CommandName="Insert"
                        CausesValidation="True"
                        ValidationGroup="CustomerInsert"
                        CssClass="btn btn-emerald px-4">
                        <i class="fas fa-save me-2"></i>Save Record
                    </asp:LinkButton>
                    <asp:LinkButton ID="ResetInsertButton"
                        runat="server"
                        OnClick="CancelEdit"
                        CausesValidation="False"
                        CssClass="btn btn-outline-secondary px-4">
                        <i class="fas fa-redo me-2"></i>Clear Fields
                    </asp:LinkButton>
                </div>
            </InsertItemTemplate>

            <EditItemTemplate>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted text-uppercase small">Full Name</label>
                        <asp:TextBox ID="txtNameEdit" runat="server"
                            Text='<%# Bind("CUSTOMER_NAME") %>'
                            CssClass="form-control form-control-lg" />
                        <asp:RequiredFieldValidator ID="rfvNameEdit" runat="server"
                            ControlToValidate="txtNameEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Customer name is required."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted text-uppercase small">Email Address</label>
                        <asp:TextBox ID="txtEmailEdit" runat="server"
                            Text='<%# Bind("EMAIL") %>'
                            CssClass="form-control form-control-lg"
                            TextMode="Email" />
                        <asp:RequiredFieldValidator ID="rfvEmailEdit" runat="server"
                            ControlToValidate="txtEmailEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Email address is required."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmailEdit" runat="server"
                            ControlToValidate="txtEmailEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Please enter a valid email address containing '@'."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted text-uppercase small">Phone Number</label>
                        <asp:TextBox ID="txtPhoneEdit" runat="server"
                            Text='<%# Bind("CONTACT_NUMBER") %>'
                            CssClass="form-control form-control-lg" />
                        <asp:RequiredFieldValidator ID="rfvPhoneEdit" runat="server"
                            ControlToValidate="txtPhoneEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Contact number is required."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPhoneEditDigits" runat="server"
                            ControlToValidate="txtPhoneEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Phone number must contain exactly 10 digits."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]{10}$" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted text-uppercase small">Address</label>
                        <asp:TextBox ID="txtAddressEdit" runat="server"
                            Text='<%# Bind("ADDRESS") %>'
                            CssClass="form-control form-control-lg" />
                        <asp:RequiredFieldValidator ID="rfvAddressEdit" runat="server"
                            ControlToValidate="txtAddressEdit"
                            CssClass="text-danger small"
                            ErrorMessage="Address is required."
                            ValidationGroup="CustomerEdit"
                            Display="Dynamic" />
                    </div>
                </div>
                <div class="d-flex gap-2 mt-4">
                    <asp:LinkButton ID="UpdateButton"
                        runat="server"
                        OnClick="UpdateCustomer"
                        CausesValidation="True"
                        ValidationGroup="CustomerEdit"
                        CssClass="btn btn-warning px-4">
                        <i class="fas fa-save me-2"></i>Update Record
                    </asp:LinkButton>
                    <asp:LinkButton ID="CancelButton"
                        runat="server"
                        OnClick="CancelEdit"
                        CausesValidation="False"
                        CssClass="btn btn-outline-secondary px-4">
                        <i class="fas fa-times me-2"></i>Cancel
                    </asp:LinkButton>
                </div>
            </EditItemTemplate>

        </asp:FormView>
    </div>
</div>

<!-- GRIDVIEW -->
<div class="section-card mt-4">
    <div class="section-card-header">
        <div class="d-flex align-items-center">
            <i class="fas fa-users me-2"></i>
            <div>
                <h3 class="section-card-title mb-0">Customer Directory</h3>
                <p class="section-card-subtitle mb-0">Complete list of registered customers across all branches.</p>
            </div>
        </div>
    </div>
    <div class="section-card-body">
        <div class="table-container">
            <asp:GridView ID="GridView1"
                runat="server"
                DataSourceID="SqlDataSource1"
                DataKeyNames="CUSTOMER_ID"
                AllowPaging="True"
                AllowSorting="True"
                PageSize="5"
                AutoGenerateColumns="False"
                CssClass="gridview"
                GridLines="None"
                PagerStyle-CssClass="gridview-pager"
                OnRowCommand="GridView1_RowCommand">

                <Columns>
                    <asp:BoundField DataField="CUSTOMER_ID" HeaderText="CUSTOMER_ID" ReadOnly="True" SortExpression="CUSTOMER_ID" />
                    <asp:BoundField DataField="CUSTOMER_NAME" HeaderText="CUSTOMER_NAME" SortExpression="CUSTOMER_NAME" />
                    <asp:BoundField DataField="CONTACT_NUMBER" HeaderText="CONTACT_NUMBER" SortExpression="CONTACT_NUMBER" />
                    <asp:BoundField DataField="EMAIL" HeaderText="EMAIL" SortExpression="EMAIL" />
                    <asp:BoundField DataField="ADDRESS" HeaderText="ADDRESS" SortExpression="ADDRESS" />
                    <asp:TemplateField HeaderText="ACTIONS">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server"
                                CommandName="EditCustomer"
                                CommandArgument='<%# Eval("CUSTOMER_ID") %>'
                                CssClass="table-action-link">
                                Edit
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server"
                                CommandName="DeleteCustomer"
                                CommandArgument='<%# Eval("CUSTOMER_ID") %>'
                                CssClass="table-action-link"
                                OnClientClick="return confirm('Are you sure you want to delete this customer?');">
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
        if (!alertEl || alertEl.classList.contains('d-none')) {
            return;
        }

        if (alertEl.textContent.trim().length === 0) {
            return;
        }

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