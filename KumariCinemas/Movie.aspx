<%@ Page Title="Movie Management" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="Movie.aspx.cs"
Inherits="KumariCinemas.Movie" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container-fluid px-4 py-4">

    <h2>Movie Management</h2>

    <asp:Label ID="errorAlert" ClientIDMode="Static" runat="server"
        CssClass="d-none" Visible="false" EnableViewState="false"></asp:Label>

    <!-- SqlDataSource -->
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:OracleConnection %>"
        ProviderName="<%$ ConnectionStrings:OracleConnection.ProviderName %>"

        SelectCommand="SELECT MOVIE_ID, TITLE, GENRE, DURATION, LANGUAGE, RELEASE_DATE FROM MOVIE ORDER BY MOVIE_ID"

        InsertCommand="INSERT INTO MOVIE
        (MOVIE_ID, TITLE, GENRE, DURATION, LANGUAGE, RELEASE_DATE)
        VALUES ((SELECT NVL(MAX(MOVIE_ID),0)+1 FROM MOVIE),
        :TITLE,:GENRE,:DURATION,:LANGUAGE,:RELEASE_DATE)"

        UpdateCommand="UPDATE MOVIE
        SET TITLE=:TITLE,
            GENRE=:GENRE,
            DURATION=:DURATION,
            LANGUAGE=:LANGUAGE,
            RELEASE_DATE=:RELEASE_DATE
        WHERE MOVIE_ID=:MOVIE_ID"

        DeleteCommand="DELETE FROM MOVIE WHERE MOVIE_ID=:MOVIE_ID">

        <InsertParameters>
            <asp:Parameter Name="TITLE" Type="String" />
            <asp:Parameter Name="GENRE" Type="String" />
            <asp:Parameter Name="DURATION" Type="String" />
            <asp:Parameter Name="LANGUAGE" Type="String" />
            <asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="TITLE" Type="String" />
            <asp:Parameter Name="GENRE" Type="String" />
            <asp:Parameter Name="DURATION" Type="String" />
            <asp:Parameter Name="LANGUAGE" Type="String" />
            <asp:Parameter Name="RELEASE_DATE" Type="DateTime" />
            <asp:Parameter Name="MOVIE_ID" Type="Int32" />
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="MOVIE_ID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <!-- FORMVIEW -->
    <asp:FormView ID="FormView1"
        runat="server"
        DataKeyNames="MOVIE_ID"
        DataSourceID="SqlDataSource1"
        DefaultMode="Insert">

        <InsertItemTemplate>
            <div class="card shadow-sm border-0 mb-4 bg-light">
                <div class="card-header bg-transparent border-0 pb-0">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-film text-success me-2"></i>
                        <div>
                            <h5 class="mb-0">Movie Information</h5>
                            <small class="text-muted">Manage movie metadata, duration, and active status for booking.</small>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <asp:ValidationSummary ID="MovieInsertSummary" runat="server"
                        ValidationGroup="MovieInsert"
                        CssClass="alert alert-danger"
                        HeaderText="Please correct the following errors:"
                        DisplayMode="BulletList" />
                    <div class="row g-3">
                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Movie Title</label>
                            <asp:TextBox ID="txtTitle" runat="server"
                                Text='<%# Bind("TITLE") %>'
                                placeholder="e.g. Inception"
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvMovieTitle" runat="server"
                                ControlToValidate="txtTitle"
                                CssClass="text-danger small"
                                ErrorMessage="Title is required."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Duration (Min)</label>
                            <asp:TextBox ID="txtDuration" runat="server"
                                Text='<%# Bind("DURATION") %>'
                                placeholder="120"
                                CssClass="form-control form-control-lg"
                                TextMode="Number" />
                            <asp:RequiredFieldValidator ID="rfvDuration" runat="server"
                                ControlToValidate="txtDuration"
                                CssClass="text-danger small"
                                ErrorMessage="Duration is required."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic" />
                            <asp:RangeValidator ID="rngDuration" runat="server"
                                ControlToValidate="txtDuration"
                                CssClass="text-danger small"
                                ErrorMessage="Duration must be between 30 and 300 minutes."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic"
                                MinimumValue="30"
                                MaximumValue="300"
                                Type="Integer" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Language</label>
                            <asp:TextBox ID="txtLanguage" runat="server"
                                Text='<%# Bind("LANGUAGE") %>'
                                placeholder="English"
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvLanguage" runat="server"
                                ControlToValidate="txtLanguage"
                                CssClass="text-danger small"
                                ErrorMessage="Language is required."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Genre</label>
                            <asp:TextBox ID="txtGenre" runat="server"
                                Text='<%# Bind("GENRE") %>'
                                placeholder="Action"
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvGenre" runat="server"
                                ControlToValidate="txtGenre"
                                CssClass="text-danger small"
                                ErrorMessage="Genre is required."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Release Date</label>
                            <asp:TextBox ID="txtReleaseDate" runat="server"
                                Text='<%# Bind("RELEASE_DATE", "{0:yyyy-MM-dd}") %>'
                                TextMode="Date"
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvReleaseDate" runat="server"
                                ControlToValidate="txtReleaseDate"
                                CssClass="text-danger small"
                                ErrorMessage="Release date is required."
                                ValidationGroup="MovieInsert"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="d-flex gap-2 mt-4">
                        <asp:LinkButton ID="InsertButton"
                            runat="server"
                            CommandName="Insert"
                            CausesValidation="True"
                            ValidationGroup="MovieInsert"
                            CssClass="btn btn-emerald px-4">
                            <i class="fas fa-save me-2"></i>Save Movie
                        </asp:LinkButton>
                        <asp:LinkButton ID="InsertCancelButton"
                            runat="server"
                            OnClick="ResetInsertForm"
                            CausesValidation="False"
                            CssClass="btn btn-outline-secondary px-4">
                            <i class="fas fa-times me-2"></i>Clear
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </InsertItemTemplate>

        <EditItemTemplate>
            <div class="card shadow-sm border-0 mb-4 bg-light">
                <div class="card-header bg-transparent border-0 pb-0">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-edit text-warning me-2"></i>
                        <div>
                            <h5 class="mb-0">Edit Movie</h5>
                            <small class="text-muted">Update title, metadata, or release information.</small>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <asp:ValidationSummary ID="MovieEditSummary" runat="server"
                        ValidationGroup="MovieEdit"
                        CssClass="alert alert-danger"
                        HeaderText="Please correct the following errors:"
                        DisplayMode="BulletList" />
                    <div class="row g-3">
                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Movie Title</label>
                            <asp:TextBox ID="txtTitleEdit" runat="server"
                                Text='<%# Bind("TITLE") %>'
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvMovieTitleEdit" runat="server"
                                ControlToValidate="txtTitleEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Title is required."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Duration (Min)</label>
                            <asp:TextBox ID="txtDurationEdit" runat="server"
                                Text='<%# Bind("DURATION") %>'
                                CssClass="form-control form-control-lg"
                                TextMode="Number" />
                            <asp:RequiredFieldValidator ID="rfvDurationEdit" runat="server"
                                ControlToValidate="txtDurationEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Duration is required."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic" />
                            <asp:RangeValidator ID="rngDurationEdit" runat="server"
                                ControlToValidate="txtDurationEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Duration must be between 30 and 300 minutes."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic"
                                MinimumValue="30"
                                MaximumValue="300"
                                Type="Integer" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Language</label>
                            <asp:TextBox ID="txtLanguageEdit" runat="server"
                                Text='<%# Bind("LANGUAGE") %>'
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvLanguageEdit" runat="server"
                                ControlToValidate="txtLanguageEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Language is required."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Genre</label>
                            <asp:TextBox ID="txtGenreEdit" runat="server"
                                Text='<%# Bind("GENRE") %>'
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvGenreEdit" runat="server"
                                ControlToValidate="txtGenreEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Genre is required."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic" />
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold text-muted text-uppercase small">Release Date</label>
                            <asp:TextBox ID="txtReleaseDateEdit" runat="server"
                                Text='<%# Bind("RELEASE_DATE", "{0:yyyy-MM-dd}") %>'
                                TextMode="Date"
                                CssClass="form-control form-control-lg" />
                            <asp:RequiredFieldValidator ID="rfvReleaseDateEdit" runat="server"
                                ControlToValidate="txtReleaseDateEdit"
                                CssClass="text-danger small"
                                ErrorMessage="Release date is required."
                                ValidationGroup="MovieEdit"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="d-flex gap-2 mt-4">
                        <asp:LinkButton ID="UpdateButton"
                            runat="server"
                            OnClick="UpdateMovie"
                            CausesValidation="True"
                            ValidationGroup="MovieEdit"
                            CssClass="btn btn-warning px-4">
                            <i class="fas fa-save me-2"></i>Update
                        </asp:LinkButton>

                        <asp:LinkButton ID="CancelButton"
                            runat="server"
                            OnClick="CancelEdit"
                            CausesValidation="False"
                            CssClass="btn btn-outline-secondary px-4">
                            <i class="fas fa-times me-2"></i>Cancel
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </EditItemTemplate>
    </asp:FormView>

    <!-- GRIDVIEW -->
    <div class="section-card">
        <div class="section-card-header">
            <div class="d-flex align-items-center">
                <i class="fas fa-film me-2"></i>
                <div>
                    <h3 class="section-card-title mb-0">Movie Directory</h3>
                    <p class="section-card-subtitle mb-0">Search and filter active movies across all genres and languages.</p>
                </div>
            </div>
        </div>
        <div class="section-card-body">
            <div class="table-container">
                <asp:GridView ID="GridView1"
                    runat="server"
                    DataSourceID="SqlDataSource1"
                    DataKeyNames="MOVIE_ID"
                    AllowPaging="True"
                    AllowSorting="True"
                    PageSize="8"
                    AutoGenerateColumns="False"
                    CssClass="gridview"
                    GridLines="None"
                    PagerStyle-CssClass="gridview-pager"
                    OnRowCommand="GridView1_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="MOVIE_ID" HeaderText="Movie ID" ReadOnly="True" SortExpression="MOVIE_ID" />
                        <asp:BoundField DataField="TITLE" HeaderText="Title" SortExpression="TITLE" />
                        <asp:BoundField DataField="GENRE" HeaderText="Genre" SortExpression="GENRE" />
                        <asp:BoundField DataField="LANGUAGE" HeaderText="Language" SortExpression="LANGUAGE" />
                        <asp:BoundField DataField="DURATION" HeaderText="Duration (Min)" SortExpression="DURATION" />
                        <asp:BoundField DataField="RELEASE_DATE" HeaderText="Release Date" DataFormatString="{0:yyyy-MM-dd}" SortExpression="RELEASE_DATE" HtmlEncode="false" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    CommandName="EditMovie"
                                    CommandArgument='<%# Eval("MOVIE_ID") %>'
                                    CssClass="table-action-link">
                                    Edit
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CommandName="DeleteMovie"
                                    CommandArgument='<%# Eval("MOVIE_ID") %>'
                                    CssClass="table-action-link"
                                    OnClientClick="return confirm('Are you sure you want to delete this movie?');">
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
        if (!alertEl || alertEl.classList.contains('d-none')) return;
        if (alertEl.textContent.trim().length === 0) return;

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