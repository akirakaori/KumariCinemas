using System;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class TheatreCityHall : Page
    {
        private string ConnectionString => ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        private string SortExpression
        {
            get { return ViewState["SortExpression"] == null ? "THEATRE_NAME" : ViewState["SortExpression"].ToString(); }
            set { ViewState["SortExpression"] = value; }
        }

        private string SortDirection
        {
            get { return ViewState["SortDirection"] == null ? "ASC" : ViewState["SortDirection"].ToString(); }
            set { ViewState["SortDirection"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTheatres();
                LoadHallDropdownAll();
                LoadCustomers();
                LoadMovies();
                LoadFilterDropdowns();
                LoadGrid();
                ClearForm();
                // In normal (insert) mode, show only Save
                btnSave.Visible = true;
                btnUpdate.Visible = false;
            }
        }

        protected void LoadTheatres()
        {
            ddlTheatre.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT THEATRE_ID,
                       THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME
                FROM THEATRE
                ORDER BY THEATRE_NAME, THEATRE_CITY_HALL", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlTheatre.DataSource = reader;
                    ddlTheatre.DataTextField = "DISPLAY_NAME";
                    ddlTheatre.DataValueField = "THEATRE_ID";
                    ddlTheatre.DataBind();
                }
            }

            ddlTheatre.Items.Insert(0, new ListItem("Select Theatre Branch", string.Empty));
        }

        protected void LoadHallDropdownAll()
        {
            ddlHall.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlHall.DataSource = reader;
                    ddlHall.DataTextField = "HALL_NAME";
                    ddlHall.DataValueField = "HALL_ID";
                    ddlHall.DataBind();
                }
            }

            ddlHall.Items.Insert(0, new ListItem("Select Hall", string.Empty));
        }

        protected void LoadHallByTheatre()
        {
            ddlHall.Items.Clear();

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                ddlHall.Items.Insert(0, new ListItem("Select Hall", string.Empty));
                return;
            }

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT DISTINCT H.HALL_ID, H.HALL_NAME
                FROM HALL H
                JOIN THEATRE_HALL TH ON H.HALL_ID = TH.HALL_ID
                WHERE TH.THEATRE_ID = :THEATRE_ID
                ORDER BY H.HALL_NAME", conn))
            {
                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlHall.DataSource = reader;
                    ddlHall.DataTextField = "HALL_NAME";
                    ddlHall.DataValueField = "HALL_ID";
                    ddlHall.DataBind();
                }
            }

            ddlHall.Items.Insert(0, new ListItem("Select Hall", string.Empty));
        }

        protected void LoadHallDetails()
        {
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlHall.SelectedValue))
                return;

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT HALL_TYPE, HALL_CAPACITY
                FROM HALL
                WHERE HALL_ID = :HALL_ID", conn))
            {
                cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtHallType.Text = reader["HALL_TYPE"].ToString();
                        txtHallCapacity.Text = reader["HALL_CAPACITY"].ToString();
                    }
                }
            }
        }

        protected void LoadTheatreDetails()
        {
            txtCityHall.Text = string.Empty;
            txtLocation.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
                return;

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT THEATRE_CITY_HALL, THEATRE_LOCATION
                FROM THEATRE
                WHERE THEATRE_ID = :THEATRE_ID", conn))
            {
                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtCityHall.Text = reader["THEATRE_CITY_HALL"].ToString();
                        txtLocation.Text = reader["THEATRE_LOCATION"].ToString();
                    }
                }
            }
        }

        protected void LoadMovies()
        {
            ddlMovie.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT MOVIE_ID, TITLE FROM MOVIE ORDER BY TITLE", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlMovie.DataSource = reader;
                    ddlMovie.DataTextField = "TITLE";
                    ddlMovie.DataValueField = "MOVIE_ID";
                    ddlMovie.DataBind();
                }
            }

            ddlMovie.Items.Insert(0, new ListItem("Select Movie", string.Empty));
        }

        protected void LoadCustomers()
        {
            ddlCustomer.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlCustomer.DataSource = reader;
                    ddlCustomer.DataTextField = "CUSTOMER_NAME";
                    ddlCustomer.DataValueField = "CUSTOMER_ID";
                    ddlCustomer.DataBind();
                }
            }

            ddlCustomer.Items.Insert(0, new ListItem("Select Customer", string.Empty));
        }

        protected void LoadFilterDropdowns()
        {
            ddlFilterTheatre.Items.Clear();
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT THEATRE_ID,
                       THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME
                FROM THEATRE
                ORDER BY THEATRE_NAME, THEATRE_CITY_HALL", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlFilterTheatre.DataSource = reader;
                    ddlFilterTheatre.DataTextField = "DISPLAY_NAME";
                    ddlFilterTheatre.DataValueField = "THEATRE_ID";
                    ddlFilterTheatre.DataBind();
                }
            }
            ddlFilterTheatre.Items.Insert(0, new ListItem("All Theatre Branches", string.Empty));

            ddlFilterCityHall.Items.Clear();
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"
                SELECT DISTINCT THEATRE_CITY_HALL
                FROM THEATRE
                WHERE THEATRE_CITY_HALL IS NOT NULL
                ORDER BY THEATRE_CITY_HALL", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlFilterCityHall.DataSource = reader;
                    ddlFilterCityHall.DataTextField = "THEATRE_CITY_HALL";
                    ddlFilterCityHall.DataValueField = "THEATRE_CITY_HALL";
                    ddlFilterCityHall.DataBind();
                }
            }
            ddlFilterCityHall.Items.Insert(0, new ListItem("All City Halls", string.Empty));
        }

        protected void LoadGrid()
        {
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand())
            {
                cmd.Connection = conn;
                cmd.BindByName = true;

                StringBuilder sql = new StringBuilder();
                sql.Append(@"
                    SELECT
                        THL.THEATRE_ID,
                        THL.HALL_ID,
                        THL.CUSTOMER_ID,
                        THL.MOVIE_ID,
                        TH.THEATRE_NAME,
                        TH.THEATRE_CITY_HALL,
                        TH.THEATRE_LOCATION,
                        H.HALL_NAME,
                        H.HALL_TYPE,
                        H.HALL_CAPACITY,
                        C.CUSTOMER_NAME,
                        M.TITLE AS MOVIE_TITLE
                    FROM THEATRE_HALL THL
                    JOIN THEATRE TH ON THL.THEATRE_ID = TH.THEATRE_ID
                    JOIN HALL H ON THL.HALL_ID = H.HALL_ID
                    JOIN CUSTOMER C ON THL.CUSTOMER_ID = C.CUSTOMER_ID
                    JOIN MOVIE M ON THL.MOVIE_ID = M.MOVIE_ID
                    WHERE 1 = 1");

                if (!string.IsNullOrWhiteSpace(ddlFilterTheatre.SelectedValue))
                {
                    sql.Append(" AND THL.THEATRE_ID = :F_THEATRE_ID");
                    cmd.Parameters.Add(":F_THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterTheatre.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterCityHall.SelectedValue))
                {
                    sql.Append(" AND TH.THEATRE_CITY_HALL = :F_CITY_HALL");
                    cmd.Parameters.Add(":F_CITY_HALL", OracleDbType.Varchar2).Value = ddlFilterCityHall.SelectedValue;
                }

                if (!string.IsNullOrWhiteSpace(txtFilterHallName.Text))
                {
                    sql.Append(" AND UPPER(H.HALL_NAME) LIKE '%' || UPPER(:F_HALL_NAME) || '%'");
                    cmd.Parameters.Add(":F_HALL_NAME", OracleDbType.Varchar2).Value = txtFilterHallName.Text.Trim();
                }

                sql.Append($" ORDER BY {SortExpression} {SortDirection}");
                cmd.CommandText = sql.ToString();

                using (var adapter = new OracleDataAdapter(cmd))
                {
                    var table = new DataTable();
                    adapter.Fill(table);
                    gvTheatreCityHall.DataSource = table;
                    gvTheatreCityHall.DataBind();
                }
            }
        }

        protected void ClearForm()
        {
            if (ddlTheatre.Items.Count > 0) ddlTheatre.SelectedIndex = 0;
            LoadHallDropdownAll();
            if (ddlHall.Items.Count > 0) ddlHall.SelectedIndex = 0;
            if (ddlCustomer.Items.Count > 0) ddlCustomer.SelectedIndex = 0;
            if (ddlMovie.Items.Count > 0) ddlMovie.SelectedIndex = 0;

            txtCityHall.Text = string.Empty;
            txtLocation.Text = string.Empty;
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;

            hfSelectedTheatreId.Value = string.Empty;
            hfSelectedHallId.Value = string.Empty;
            hfSelectedCustomerId.Value = string.Empty;
            hfSelectedMovieId.Value = string.Empty;

            // Reset to insert mode: show Save, hide Update
            btnSave.Visible = true;
            btnUpdate.Visible = false;

            ShowMessage(string.Empty, true);
        }

        protected void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;

            if (string.IsNullOrWhiteSpace(message))
            {
                lblMessage.Visible = false;
                lblMessage.CssClass = "d-none";
                // Ensure any inline styles added by client-side fade are cleared
                lblMessage.Style.Remove("opacity");
                lblMessage.Style.Remove("transition");
                return;
            }

            // Reset any inline styles from previous fades so the alert displays correctly
            lblMessage.Style.Remove("opacity");
            lblMessage.Style.Remove("transition");

            lblMessage.Visible = true;
            lblMessage.CssClass = isSuccess ? "alert alert-success" : "alert alert-danger";
        }

        protected bool ValidateForm(out string errorMessage)
        {
            errorMessage = string.Empty;

            Page.Validate("TheatreCityHall");
            if (!Page.IsValid)
            {
                errorMessage = "Please fix validation errors and try again.";
                return false;
            }

            return true;
        }

        protected bool AssignmentExists(int theatreId, int hallId, int customerId, int movieId)
        {
            const string sql = @"
                SELECT COUNT(*)
                FROM THEATRE_HALL
                WHERE THEATRE_ID = :THEATRE_ID
                  AND HALL_ID = :HALL_ID
                  AND CUSTOMER_ID = :CUSTOMER_ID
                  AND MOVIE_ID = :MOVIE_ID";

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(sql, conn))
            {
                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;
                cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = hallId;
                cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = customerId;
                cmd.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = movieId;

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        protected void ddlTheatre_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTheatreDetails();
            LoadHallByTheatre();
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;
        }

        protected void ddlHall_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadHallDetails();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            ShowMessage(string.Empty, true);

            if (!ValidateForm(out string validationError))
            {
                ShowMessage(validationError, false);
                return;
            }

            int theatreId = Convert.ToInt32(ddlTheatre.SelectedValue);
            int hallId = Convert.ToInt32(ddlHall.SelectedValue);
            int customerId = Convert.ToInt32(ddlCustomer.SelectedValue);
            int movieId = Convert.ToInt32(ddlMovie.SelectedValue);

            if (AssignmentExists(theatreId, hallId, customerId, movieId))
            {
                ShowMessage("The selected theatre, hall, customer, and movie combination already exists.", false);
                return;
            }

            try
            {
                using (var conn = new OracleConnection(ConnectionString))
                using (var cmd = new OracleCommand(@"
                    INSERT INTO THEATRE_HALL (THEATRE_ID, HALL_ID, CUSTOMER_ID, MOVIE_ID)
                    VALUES (:THEATRE_ID, :HALL_ID, :CUSTOMER_ID, :MOVIE_ID)", conn))
                {
                    cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;
                    cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = hallId;
                    cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = customerId;
                    cmd.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = movieId;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadGrid();
                ClearForm();
                ShowMessage("Hall assignment saved successfully.", true);
            }
            catch (OracleException ex)
            {
                ShowMessage($"Error saving hall record: {ex.Message}", false);
            }
            catch (Exception ex)
            {
                ShowMessage($"An unexpected error occurred: {ex.Message}", false);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            ShowMessage(string.Empty, true);

            if (string.IsNullOrWhiteSpace(hfSelectedHallId.Value) ||
                string.IsNullOrWhiteSpace(hfSelectedTheatreId.Value) ||
                string.IsNullOrWhiteSpace(hfSelectedCustomerId.Value) ||
                string.IsNullOrWhiteSpace(hfSelectedMovieId.Value))
            {
                ShowMessage("No record is selected for update.", false);
                return;
            }

            if (!ValidateForm(out string validationError))
            {
                ShowMessage(validationError, false);
                return;
            }

            int originalTheatreId = Convert.ToInt32(hfSelectedTheatreId.Value);
            int originalHallId = Convert.ToInt32(hfSelectedHallId.Value);
            int originalCustomerId = Convert.ToInt32(hfSelectedCustomerId.Value);
            int originalMovieId = Convert.ToInt32(hfSelectedMovieId.Value);

            int updatedTheatreId = Convert.ToInt32(ddlTheatre.SelectedValue);
            int updatedHallId = Convert.ToInt32(ddlHall.SelectedValue);
            int updatedCustomerId = Convert.ToInt32(ddlCustomer.SelectedValue);
            int updatedMovieId = Convert.ToInt32(ddlMovie.SelectedValue);

            bool isSameRecord = originalTheatreId == updatedTheatreId &&
                                originalHallId == updatedHallId &&
                                originalCustomerId == updatedCustomerId &&
                                originalMovieId == updatedMovieId;

            if (!isSameRecord && AssignmentExists(updatedTheatreId, updatedHallId, updatedCustomerId, updatedMovieId))
            {
                ShowMessage("Another assignment with the same theatre, hall, customer, and movie already exists.", false);
                return;
            }

            try
            {
                using (var conn = new OracleConnection(ConnectionString))
                using (var cmd = new OracleCommand(@"
                    UPDATE THEATRE_HALL
                    SET THEATRE_ID = :NEW_THEATRE_ID,
                        HALL_ID = :NEW_HALL_ID,
                        CUSTOMER_ID = :NEW_CUSTOMER_ID,
                        MOVIE_ID = :NEW_MOVIE_ID
                    WHERE THEATRE_ID = :OLD_THEATRE_ID
                      AND HALL_ID = :OLD_HALL_ID
                      AND CUSTOMER_ID = :OLD_CUSTOMER_ID
                      AND MOVIE_ID = :OLD_MOVIE_ID", conn))
                {
                    cmd.Parameters.Add(":NEW_THEATRE_ID", OracleDbType.Int32).Value = updatedTheatreId;
                    cmd.Parameters.Add(":NEW_HALL_ID", OracleDbType.Int32).Value = updatedHallId;
                    cmd.Parameters.Add(":NEW_CUSTOMER_ID", OracleDbType.Int32).Value = updatedCustomerId;
                    cmd.Parameters.Add(":NEW_MOVIE_ID", OracleDbType.Int32).Value = updatedMovieId;
                    cmd.Parameters.Add(":OLD_THEATRE_ID", OracleDbType.Int32).Value = originalTheatreId;
                    cmd.Parameters.Add(":OLD_HALL_ID", OracleDbType.Int32).Value = originalHallId;
                    cmd.Parameters.Add(":OLD_CUSTOMER_ID", OracleDbType.Int32).Value = originalCustomerId;
                    cmd.Parameters.Add(":OLD_MOVIE_ID", OracleDbType.Int32).Value = originalMovieId;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadGrid();
                ClearForm();
                ShowMessage("Hall assignment updated successfully.", true);
            }
            catch (OracleException ex)
            {
                ShowMessage($"Error updating hall assignment: {ex.Message}", false);
            }
            catch (Exception ex)
            {
                ShowMessage($"An unexpected error occurred: {ex.Message}", false);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            gvTheatreCityHall.PageIndex = 0;
            LoadGrid();
        }

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            ddlFilterTheatre.SelectedIndex = 0;
            ddlFilterCityHall.SelectedIndex = 0;
            txtFilterHallName.Text = string.Empty;
            gvTheatreCityHall.PageIndex = 0;
            LoadGrid();
        }

        protected void gvTheatreCityHall_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTheatreCityHall.PageIndex = e.NewPageIndex;
            LoadGrid();
        }

        protected void gvTheatreCityHall_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (SortExpression == e.SortExpression)
            {
                SortDirection = SortDirection == "ASC" ? "DESC" : "ASC";
            }
            else
            {
                SortExpression = e.SortExpression;
                SortDirection = "ASC";
            }

            LoadGrid();
        }

        protected void gvTheatreCityHall_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null) return;

            if (e.CommandName == "EditRow")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length != 4) return;

                if (!int.TryParse(args[0], out int theatreId) ||
                    !int.TryParse(args[1], out int hallId) ||
                    !int.TryParse(args[2], out int customerId) ||
                    !int.TryParse(args[3], out int movieId))
                {
                    return;
                }

                ddlTheatre.SelectedValue = theatreId.ToString();
                LoadTheatreDetails();
                LoadHallByTheatre();

                if (ddlHall.Items.FindByValue(hallId.ToString()) != null)
                    ddlHall.SelectedValue = hallId.ToString();

                LoadHallDetails();

                if (ddlCustomer.Items.FindByValue(customerId.ToString()) != null)
                    ddlCustomer.SelectedValue = customerId.ToString();

                if (ddlMovie.Items.FindByValue(movieId.ToString()) != null)
                    ddlMovie.SelectedValue = movieId.ToString();

                hfSelectedTheatreId.Value = theatreId.ToString();
                hfSelectedHallId.Value = hallId.ToString();
                hfSelectedCustomerId.Value = customerId.ToString();
                hfSelectedMovieId.Value = movieId.ToString();

                // Switch to edit mode: hide Save and show Update
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                ShowMessage("Edit mode: update the details and click Update to save changes.", true);
            }
            else if (e.CommandName == "DeleteRow")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length != 4) return;

                if (!int.TryParse(args[0], out int theatreId) ||
                    !int.TryParse(args[1], out int hallId) ||
                    !int.TryParse(args[2], out int customerId) ||
                    !int.TryParse(args[3], out int movieId))
                {
                    return;
                }

                try
                {
                    using (var conn = new OracleConnection(ConnectionString))
                    using (var cmd = new OracleCommand(@"
                        DELETE FROM THEATRE_HALL
                        WHERE THEATRE_ID = :THEATRE_ID
                          AND HALL_ID = :HALL_ID
                          AND CUSTOMER_ID = :CUSTOMER_ID
                          AND MOVIE_ID = :MOVIE_ID", conn))
                    {
                        cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;
                        cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = hallId;
                        cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = customerId;
                        cmd.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = movieId;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    LoadGrid();
                    ClearForm();
                    ShowMessage("Hall assignment deleted successfully.", true);
                }
                catch (OracleException ex) when (ex.Number == 2292)
                {
                    ShowMessage("Unable to delete this record because related records exist in another table.", false);
                }
                catch (OracleException ex)
                {
                    ShowMessage($"Error deleting hall assignment: {ex.Message}", false);
                }
                catch (Exception ex)
                {
                    ShowMessage($"An unexpected error occurred: {ex.Message}", false);
                }
            }
        }
    }
}