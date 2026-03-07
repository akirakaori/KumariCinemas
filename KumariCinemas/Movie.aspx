<%@ Page Title="Movie Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Movie.aspx.cs" Inherits="KumariCinemas.Movie" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        
        <!-- Page Header -->
        <div class="mb-4">
            <h1 class="page-title">Movie Details</h1>
            <p class="page-subtitle">Manage movie information, metadata, and active status for booking.</p>
        </div>

        <!-- Data Sources -->
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
            ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"
            SelectCommand="SELECT MOVIE_ID, TITLE, DURATION, LANGUAGE, GENRE, RELEASE_DATE FROM MOVIE"
            InsertCommand="INSERT INTO MOVIE (MOVIE_ID, TITLE, DURATION, LANGUAGE, GENRE, RELEASE_DATE) VALUES ((SELECT NVL(MAX(MOVIE_ID), 0) + 1 FROM MOVIE), :TITLE, :DURATION, :LANGUAGE, :GENRE, :RELEASE_DATE)"
            UpdateCommand="UPDATE MOVIE SET TITLE=:TITLE, DURATION=:DURATION, LANGUAGE=:LANGUAGE, GENRE=:GENRE, RELEASE_DATE=:RELEASE_DATE WHERE MOVIE_ID=:MOVIE_ID"
            DeleteCommand="DELETE FROM MOVIE WHERE MOVIE_ID=:MOVIE_ID">
            <DeleteParameters>
                <asp:Parameter Name="MOVIE_ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="TITLE" Type="String" />
                <asp:Parameter Name="DURATION" Type="Int32" />
                <asp:Parameter Name="LANGUAGE" Type="String" />
                <asp:Parameter Name="GENRE" Type="String" />
                <asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="TITLE" Type="String" />
                <asp:Parameter Name="DURATION" Type="Int32" />
                <asp:Parameter Name="LANGUAGE" Type="String" />
                <asp:Parameter Name="GENRE" Type="String" />
                <asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
                <asp:Parameter Name="MOVIE_ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <div class="row">
            <div class="col-12">
                
                <!-- Add New Movie Card -->
                <div class="crud-card mb-4">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-film me-2"></i>Movie Information
                        </h3>
                        <small class="text-muted">Upload poster, enter metadata, and manage movie catalog.</small>
                    </div>
                    <div class="crud-card-body">
                        <asp:FormView ID="FormView1" runat="server" DataKeyNames="MOVIE_ID" DataSourceID="SqlDataSource1" DefaultMode="Insert">
                            <InsertItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    ValidationGroup="MovieInsert" 
                                    CssClass="alert alert-danger" 
                                    HeaderText="Please correct the following errors:" 
                                    DisplayMode="BulletList" />
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-heading me-1"></i>Movie Title
                                        </label>
                                        <asp:TextBox ID="TITLETextBox" runat="server" 
                                            Text='<%# Bind("TITLE") %>' 
                                            CssClass="form-control"
                                            placeholder="e.g. Inception" />
                                        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                                            ControlToValidate="TITLETextBox" 
                                            ValidationGroup="MovieInsert" 
                                            ErrorMessage="Movie Title is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Movie Title is required" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-clock me-1"></i>Duration (Min)
                                        </label>
                                        <asp:TextBox ID="DURATIONTextBox" runat="server" 
                                            Text='<%# Bind("DURATION") %>' 
                                            CssClass="form-control"
                                            TextMode="Number"
                                            placeholder="120" />
                                        <asp:RequiredFieldValidator ID="rfvDuration" runat="server" 
                                            ControlToValidate="DURATIONTextBox" 
                                            ValidationGroup="MovieInsert" 
                                            ErrorMessage="Duration is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Duration is required" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-language me-1"></i>Language
                                        </label>
                                        <asp:TextBox ID="LANGUAGETextBox" runat="server" 
                                            Text='<%# Bind("LANGUAGE") %>' 
                                            CssClass="form-control"
                                            placeholder="English" />
                                        <asp:RequiredFieldValidator ID="rfvLanguage" runat="server" 
                                            ControlToValidate="LANGUAGETextBox" 
                                            ValidationGroup="MovieInsert" 
                                            ErrorMessage="Language is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Language is required" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-theater-masks me-1"></i>Genre
                                        </label>
                                        <asp:TextBox ID="GENRETextBox" runat="server" 
                                            Text='<%# Bind("GENRE") %>' 
                                            CssClass="form-control"
                                            placeholder="Action" />
                                        <asp:RequiredFieldValidator ID="rfvGenre" runat="server" 
                                            ControlToValidate="GENRETextBox" 
                                            ValidationGroup="MovieInsert" 
                                            ErrorMessage="Genre is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Genre is required" />
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold" style="color: var(--bottle-green);">
                                            <i class="fas fa-calendar me-1"></i>Release Date
                                        </label>
                                        <asp:TextBox ID="RELEASE_DATETextBox" runat="server" 
                                            Text='<%# Bind("RELEASE_DATE") %>' 
                                            CssClass="form-control"
                                            TextMode="Date" />
                                        <asp:RequiredFieldValidator ID="rfvReleaseDate" runat="server" 
                                            ControlToValidate="RELEASE_DATETextBox" 
                                            ValidationGroup="MovieInsert" 
                                            ErrorMessage="Release Date is required" 
                                            Display="Dynamic" 
                                            CssClass="text-danger small" 
                                            Text="* Release Date is required" />
                                    </div>
                                    <div class="col-12">
                                        <asp:LinkButton ID="InsertButton" runat="server" 
                                            CausesValidation="True" 
                                            CommandName="Insert" 
                                            ValidationGroup="MovieInsert" 
                                            CssClass="btn btn-emerald">
                                            <i class="fas fa-save me-2"></i>Save Movie
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="CancelButton" runat="server" 
                                            CausesValidation="False" 
                                            CommandName="Cancel" 
                                            CssClass="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-times me-2"></i>Clear
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </InsertItemTemplate>
                            
                            <ItemTemplate>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No records selected. Use the form above to add a new movie.
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <!-- Movie Directory Card -->
                <div class="crud-card">
                    <div class="crud-card-header">
                        <h3 class="card-header-title mb-0">
                            <i class="fas fa-video me-2"></i>Movie Directory
                        </h3>
                        <small class="text-muted">Search and filter active movies across all genres and languages.</small>
                    </div>
                    <div class="crud-card-body p-0">
                        <div class="table-container">
                            <asp:GridView ID="GridView1" runat="server" 
                                AllowPaging="True" 
                                AllowSorting="True" 
                                AutoGenerateColumns="False" 
                                DataKeyNames="MOVIE_ID" 
                                DataSourceID="SqlDataSource1"
                                CssClass="gridview"
                                GridLines="None"
                                PagerStyle-CssClass="gridview-pager">
                                <Columns>
                                    <asp:BoundField DataField="MOVIE_ID" HeaderText="Movie ID" ReadOnly="True" SortExpression="MOVIE_ID" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="TITLE" HeaderText="Title" SortExpression="TITLE" />
                                    <asp:BoundField DataField="GENRE" HeaderText="Genre" SortExpression="GENRE" ItemStyle-Width="120px" />
                                    <asp:BoundField DataField="LANGUAGE" HeaderText="Language" SortExpression="LANGUAGE" ItemStyle-Width="100px" />
                                    <asp:BoundField DataField="DURATION" HeaderText="Duration (min)" SortExpression="DURATION" ItemStyle-Width="120px" />
                                    <asp:BoundField DataField="RELEASE_DATE" HeaderText="Release Date" SortExpression="RELEASE_DATE" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="120px" />
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
