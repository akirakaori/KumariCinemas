using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KumariCinemas
{
    public partial class Movie : Page
    {
        private int SelectedMovieId
        {
            get
            {
                object value = ViewState["SelectedMovieId"];
                return value == null ? 0 : Convert.ToInt32(value);
            }
            set
            {
                ViewState["SelectedMovieId"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            ToggleValidationSummaries();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "EditMovie")
                {
                    int movieId = Convert.ToInt32(e.CommandArgument);
                    SelectedMovieId = movieId;

                    FormView1.ChangeMode(FormViewMode.Edit);
                    FormView1.DataSourceID = null;
                    FormView1.DataSource = GetMovieData(movieId);
                    FormView1.DataBind();
                }
                else if (e.CommandName == "DeleteMovie")
                {
                    int movieId = Convert.ToInt32(e.CommandArgument);

                    SqlDataSource1.DeleteParameters["MOVIE_ID"].DefaultValue = movieId.ToString();
                    SqlDataSource1.Delete();

                    GridView1.DataBind();

                    FormView1.ChangeMode(FormViewMode.Insert);
                    FormView1.DataSourceID = "SqlDataSource1";
                    FormView1.DataBind();

                    ShowSuccess("Movie deleted successfully.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        protected void UpdateMovie(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                if (SelectedMovieId == 0)
                {
                    ShowError("No movie selected for update.");
                    return;
                }

                TextBox txtTitleEdit = (TextBox)FormView1.FindControl("txtTitleEdit");
                TextBox txtGenreEdit = (TextBox)FormView1.FindControl("txtGenreEdit");
                TextBox txtDurationEdit = (TextBox)FormView1.FindControl("txtDurationEdit");
                TextBox txtLanguageEdit = (TextBox)FormView1.FindControl("txtLanguageEdit");
                TextBox txtReleaseDateEdit = (TextBox)FormView1.FindControl("txtReleaseDateEdit");
                SqlDataSource1.UpdateParameters["MOVIE_ID"].DefaultValue = SelectedMovieId.ToString();
                SqlDataSource1.UpdateParameters["TITLE"].DefaultValue = txtTitleEdit.Text.Trim();
                SqlDataSource1.UpdateParameters["GENRE"].DefaultValue = txtGenreEdit.Text.Trim();
                SqlDataSource1.UpdateParameters["DURATION"].DefaultValue = txtDurationEdit.Text.Trim();
                SqlDataSource1.UpdateParameters["LANGUAGE"].DefaultValue = txtLanguageEdit.Text.Trim();
                SqlDataSource1.UpdateParameters["RELEASE_DATE"].DefaultValue = txtReleaseDateEdit.Text.Trim();

                SqlDataSource1.Update();

                FormView1.ChangeMode(FormViewMode.Insert);
                FormView1.DataSourceID = "SqlDataSource1";
                FormView1.DataBind();

                GridView1.DataBind();

                SelectedMovieId = 0;

                ShowSuccess("Movie updated successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        protected void CancelEdit(object sender, EventArgs e)
        {
            FormView1.ChangeMode(FormViewMode.Insert);
            FormView1.DataSourceID = "SqlDataSource1";
            FormView1.DataBind();
            SelectedMovieId = 0;
        }

        protected void ResetInsertForm(object sender, EventArgs e)
        {
            FormView1.ChangeMode(FormViewMode.Insert);
            FormView1.DataSourceID = "SqlDataSource1";
            FormView1.DataBind();
            SelectedMovieId = 0;

            errorAlert.Text = string.Empty;
            errorAlert.Visible = false;
        }

        private System.Data.DataView GetMovieData(int movieId)
        {
            SqlDataSource ds = new SqlDataSource
            {
                ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString,
                ProviderName = System.Configuration.ConfigurationManager.ConnectionStrings["OracleConnection"].ProviderName,
                SelectCommand = "SELECT MOVIE_ID, TITLE, GENRE, DURATION, LANGUAGE, RELEASE_DATE FROM MOVIE WHERE MOVIE_ID = :MOVIE_ID"
            };

            ds.SelectParameters.Add("MOVIE_ID", movieId.ToString());

            return (System.Data.DataView)ds.Select(DataSourceSelectArguments.Empty);
        }

        private void ShowError(string message)
        {
            errorAlert.Visible = true;
            errorAlert.CssClass = "alert alert-danger";
            errorAlert.Text = message;
        }

        private void ShowSuccess(string message)
        {
            errorAlert.Visible = true;
            errorAlert.CssClass = "alert alert-success";
            errorAlert.Text = message;
        }

        private void ToggleValidationSummaries()
        {
            bool validationComplete = DidValidationRun();
            bool shouldShowErrors = validationComplete && !Page.IsValid;

            if (FormView1.CurrentMode == FormViewMode.Insert)
            {
                SetSummaryVisibility("MovieInsertSummary", shouldShowErrors);
            }
            else if (FormView1.CurrentMode == FormViewMode.Edit)
            {
                SetSummaryVisibility("MovieEditSummary", shouldShowErrors);
            }
        }

        private bool DidValidationRun()
        {
            if (!IsPostBack)
            {
                return false;
            }

            Control sourceControl = FindPostBackControl();
            if (sourceControl is IButtonControl buttonControl)
            {
                return buttonControl.CausesValidation;
            }

            return false;
        }

        private Control FindPostBackControl()
        {
            string eventTarget = Request.Params["__EVENTTARGET"];
            if (!string.IsNullOrEmpty(eventTarget))
            {
                return FindControlByUniqueId(eventTarget);
            }

            foreach (string key in Request.Form)
            {
                Control candidate = FindControlByUniqueId(key);
                if (candidate is IButtonControl)
                {
                    return candidate;
                }
            }

            return null;
        }

        private Control FindControlByUniqueId(string uniqueId)
        {
            if (string.IsNullOrEmpty(uniqueId))
            {
                return null;
            }

            string path = uniqueId.Replace('$', ':');
            return Page.FindControl(path);
        }

        private void SetSummaryVisibility(string summaryId, bool visible)
        {
            ValidationSummary summary = FormView1.FindControl(summaryId) as ValidationSummary;
            if (summary != null)
            {
                summary.Visible = visible;
            }
        }
    }
}