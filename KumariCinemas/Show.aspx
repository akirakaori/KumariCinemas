<%@ Page Title="Show Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Show.aspx.cs" Inherits="KumariCinemas.Show" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Show Details</h1>
            <p class="page-subtitle">Manage cinema show schedules, movie pairings, and screening timings.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>" 
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT SHOW_ID, SHOW_DATE, SHOW_TIME, SHOW_TYPE FROM SHOW"
            InsertCommand="INSERT INTO SHOW (SHOW_ID, SHOW_DATE, SHOW_TIME, SHOW_TYPE) VALUES ((SELECT NVL(MAX(SHOW_ID), 0) + 1 FROM SHOW), :SHOW_DATE, :SHOW_TIME, :SHOW_TYPE)"
            UpdateCommand="UPDATE SHOW SET SHOW_DATE = :SHOW_DATE, SHOW_TIME = :SHOW_TIME, SHOW_TYPE = :SHOW_TYPE WHERE SHOW_ID = :SHOW_ID"
            DeleteCommand="DELETE FROM SHOW WHERE SHOW_ID = :SHOW_ID">
            <DeleteParameters>
                <asp:Parameter Name="SHOW_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
                <asp:Parameter Name="SHOW_TIME" Type="String" />
                <asp:Parameter Name="SHOW_TYPE" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
                <asp:Parameter Name="SHOW_TIME" Type="String" />
                <asp:Parameter Name="SHOW_TYPE" Type="String" />
                <asp:Parameter Name="SHOW_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Schedule a New Show Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-calendar-plus me-2"></i>Schedule a New Show
                        </h3>
                        <small class="text-muted">Enter show schedule, select movie, and configure screening details.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="SHOW_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert" OnItemInserting="FormView1_ItemInserting" OnItemUpdating="FormView1_ItemUpdating">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="ShowInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-calendar me-1"></i>Show Date
                                        </label>
                                        <asp:TextBox ID="SHOW_DATETextBox" runat="server" 
                                            Text='<%# Bind("SHOW_DATE") %>' 
                                            CssClass="form-control"
                                            TextMode="Date" />
                                        <asp:RequiredFieldValidator ID="rfvShowDate" runat="server" 
                                            ControlToValidate="SHOW_DATETextBox" 
                                            ValidationGroup="ShowInsert" 
                                            ErrorMessage="Show Date is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Show Date is required" />
                                        <small class="text-muted">Select the screening date</small>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-clock me-1"></i>Show Time
                                        </label>
                                        <div class="input-group">
                                            <asp:DropDownList ID="ddlHour" runat="server" CssClass="form-select" style="max-width: 80px;">
                                                <asp:ListItem Text="01" Value="01" />
                                                <asp:ListItem Text="02" Value="02" />
                                                <asp:ListItem Text="03" Value="03" />
                                                <asp:ListItem Text="04" Value="04" />
                                                <asp:ListItem Text="05" Value="05" />
                                                <asp:ListItem Text="06" Value="06" />
                                                <asp:ListItem Text="07" Value="07" />
                                                <asp:ListItem Text="08" Value="08" />
                                                <asp:ListItem Text="09" Value="09" />
                                                <asp:ListItem Text="10" Value="10" Selected="True" />
                                                <asp:ListItem Text="11" Value="11" />
                                                <asp:ListItem Text="12" Value="12" />
                                            </asp:DropDownList>
                                            <span class="input-group-text">:</span>
                                            <asp:DropDownList ID="ddlMinute" runat="server" CssClass="form-select" style="max-width: 80px;">
                                                <asp:ListItem Text="00" Value="00" Selected="True" />
                                                <asp:ListItem Text="15" Value="15" />
                                                <asp:ListItem Text="30" Value="30" />
                                                <asp:ListItem Text="45" Value="45" />
                                            </asp:DropDownList>
                                            <asp:DropDownList ID="ddlAMPM" runat="server" CssClass="form-select" style="max-width: 80px;">
                                                <asp:ListItem Text="AM" Value="AM" Selected="True" />
                                                <asp:ListItem Text="PM" Value="PM" />
                                            </asp:DropDownList>
                                        </div>
                                        <asp:HiddenField ID="SHOW_TIMETextBox" runat="server" Value='<%# Bind("SHOW_TIME") %>' />
                                        <small class="text-muted">Select hour, minute, and AM/PM</small>
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-tag me-1"></i>Show Type/Status
                                        </label>
                                        <asp:DropDownList ID="SHOW_TYPEDropDown" runat="server" 
                                            CssClass="form-select"
                                            SelectedValue='<%# Bind("SHOW_TYPE") %>'>
                                            <asp:ListItem Text="-- Select Show Type --" Value="" />
                                            <asp:ListItem Text="Regular Screening" Value="Regular" />
                                            <asp:ListItem Text="Premiere" Value="Premiere" />
                                            <asp:ListItem Text="Matinee" Value="Matinee" />
                                            <asp:ListItem Text="Late Night Show" Value="Late Night" />
                                            <asp:ListItem Text="Special Event" Value="Special" />
                                            <asp:ListItem Text="Private Screening" Value="Private" />
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvShowType" runat="server" 
                                            ControlToValidate="SHOW_TYPEDropDown" 
                                            ValidationGroup="ShowInsert" 
                                            ErrorMessage="Show Type is required" 
                                            Display="Dynamic" 
                                            InitialValue=""
                                            CssClass="text-danger small" 
                                            Text="* Show Type is required" />
                                        <small class="text-muted">Choose the type of screening</small>
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="ShowInsert" 
                                            OnClick="InsertButton_Click"
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-calendar-check me-2"></i>Create Schedule
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
                                    No records selected. Use the form above to schedule a new show.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Current Show Schedules Card -->
                <div class="crud-card" id="gridSection">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-film me-2"></i>Current Show Schedules
                        </h3>
                        <small class="text-muted">Search and filter show schedules by movie or theatre.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="SHOW_ID" 
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
                                    <asp:BoundField DataField="SHOW_ID" HeaderText="Show ID" ReadOnly="True" SortExpression="SHOW_ID" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="SHOW_DATE" HeaderText="Show Date" SortExpression="SHOW_DATE" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField DataField="SHOW_TIME" HeaderText="Show Time" SortExpression="SHOW_TIME" />
                                    <asp:BoundField DataField="SHOW_TYPE" HeaderText="Show Type" SortExpression="SHOW_TYPE" />
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
