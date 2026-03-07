<%@ Page Title="Show Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Show.aspx.cs" Inherits="KumariCinemas.Show" %>

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
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="SHOW_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-calendar me-1"></i>Show Date
                                        </label>
                                        <asp:TextBox ID="SHOW_DATETextBox" runat="server" 
                                            Text=''<%# Bind("SHOW_DATE") %>'' 
                                            CssClass="form-control"
                                            TextMode="Date" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-clock me-1"></i>Show Time
                                        </label>
                                        <asp:TextBox ID="SHOW_TIMETextBox" runat="server" 
                                            Text=''<%# Bind("SHOW_TIME") %>'' 
                                            CssClass="form-control"
                                            placeholder="18:30" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-tag me-1"></i>Show Status
                                        </label>
                                        <asp:TextBox ID="SHOW_TYPETextBox" runat="server" 
                                            Text=''<%# Bind("SHOW_TYPE") %>'' 
                                            CssClass="form-control"
                                            placeholder="Upcoming" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
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
                <div class="crud-card">
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
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="SHOW_ID" HeaderText="ID" ReadOnly="True" SortExpression="SHOW_ID" ItemStyle-Width="70px" />
                                    <asp:BoundField DataField="SHOW_DATE" HeaderText="Date / Time" SortExpression="SHOW_DATE" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField DataField="SHOW_TIME" HeaderText="Theatre & Hall" SortExpression="SHOW_TIME" />
                                    <asp:BoundField DataField="SHOW_TYPE" HeaderText="Price" SortExpression="SHOW_TYPE" />
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
