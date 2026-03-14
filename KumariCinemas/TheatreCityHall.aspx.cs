using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class TheatreCityHall : Page
    {
        private string ConnectionString => ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTheatres();
                LoadCityHalls();
                LoadHalls();
                LoadCustomers();
                LoadMovies();
                LoadFilterDropdowns();
                LoadGrid();
                LoadLocationByCityHall();

                btnSave.Enabled = true;
                btnUpdate.Enabled = false;
            }
        }

        #region Load Methods

        protected void LoadTheatres()
        {
            ddlTheatre.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand("SELECT THEATRE_ID, THEATRE_NAME FROM THEATRE ORDER BY THEATRE_NAME", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlTheatre.DataSource = reader;
                    ddlTheatre.DataTextField = "THEATRE_NAME";
                    ddlTheatre.DataValueField = "THEATRE_ID";
                    ddlTheatre.DataBind();
                }
            }

            ddlTheatre.Items.Insert(0, new ListItem("-- Select Theatre --", string.Empty));
        }

        protected void LoadCityHalls()
        {
            ddlCityHall.Items.Clear();
            ddlCityHall.Items.Insert(0, new ListItem("-- Select City Hall --", string.Empty));
        }

        protected void LoadCityHallByTheatre()
        {
            ddlCityHall.Items.Clear();

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                ddlCityHall.Items.Insert(0, new ListItem("-- Select City Hall --", string.Empty));
                return;
            }

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT THEATRE_CITY_HALL
FROM THEATRE
WHERE THEATRE_ID = :THEATRE_ID", conn))
            {
                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlCityHall.DataSource = reader;
                    ddlCityHall.DataTextField = "THEATRE_CITY_HALL";
                    ddlCityHall.DataValueField = "THEATRE_CITY_HALL";
                    ddlCityHall.DataBind();
                }
            }

            ddlCityHall.Items.Insert(0, new ListItem("-- Select City Hall --", string.Empty));
            if (ddlCityHall.Items.Count > 1)
            {
                ddlCityHall.SelectedIndex = 1;
            }
        }

        protected void LoadHalls()
        {
            ddlHall.Items.Clear();
            ddlHall.Items.Insert(0, new ListItem("-- Select Hall --", string.Empty));
        }

        protected void LoadHallByTheatre()
        {
            ddlHall.Items.Clear();

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                ddlHall.Items.Insert(0, new ListItem("-- Select Hall --", string.Empty));
                return;
            }

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT H.HALL_ID, H.HALL_NAME
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

            ddlHall.Items.Insert(0, new ListItem("-- Select Hall --", string.Empty));
            if (ddlHall.Items.Count > 1)
            {
                ddlHall.SelectedIndex = 1;
            }
        }

        protected void LoadMovies()
        {
            ddlMovie.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT MOVIE_ID, TITLE
FROM MOVIE
ORDER BY TITLE", conn))
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

            ddlMovie.Items.Insert(0, new ListItem("-- Select Movie --", string.Empty));
        }

        protected void LoadCustomers()
        {
            ddlCustomer.Items.Clear();

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT CUSTOMER_ID, CUSTOMER_NAME
FROM CUSTOMER
ORDER BY CUSTOMER_NAME", conn))
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

            ddlCustomer.Items.Insert(0, new ListItem("-- Select Customer --", string.Empty));
        }

        protected void LoadFilterDropdowns()
        {
            ddlFilterTheatre.Items.Clear();
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand("SELECT THEATRE_ID, THEATRE_NAME FROM THEATRE ORDER BY THEATRE_NAME", conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    ddlFilterTheatre.DataSource = reader;
                    ddlFilterTheatre.DataTextField = "THEATRE_NAME";
                    ddlFilterTheatre.DataValueField = "THEATRE_ID";
                    ddlFilterTheatre.DataBind();
                }
            }
            ddlFilterTheatre.Items.Insert(0, new ListItem("-- All Theatres --", string.Empty));

            ddlFilterCityHall.Items.Clear();
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT DISTINCT THEATRE_CITY_HALL
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
            ddlFilterCityHall.Items.Insert(0, new ListItem("-- All City Halls --", string.Empty));
        }

        protected void LoadLocationByCityHall()
        {
            txtLocation.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlCityHall.SelectedValue))
            {
                return;
            }

            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand(@"SELECT THEATRE_LOCATION
FROM THEATRE
WHERE THEATRE_CITY_HALL = :CITY_HALL", conn))
            {
                cmd.Parameters.Add(":CITY_HALL", OracleDbType.Varchar2).Value = ddlCityHall.SelectedValue;

                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    txtLocation.Text = result.ToString();
                }
            }
        }

        protected void LoadGrid()
        {
            using (var conn = new OracleConnection(ConnectionString))
            using (var cmd = new OracleCommand())
            {
                cmd.Connection = conn;
                cmd.BindByName = true;

                string sql = @"SELECT
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
WHERE 1 = 1";

                if (!string.IsNullOrWhiteSpace(ddlFilterTheatre.SelectedValue))
                {
                    sql += " AND THL.THEATRE_ID = :F_THEATRE_ID";
                    cmd.Parameters.Add(":F_THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterTheatre.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterCityHall.SelectedValue))
                {
                    sql += " AND TH.THEATRE_CITY_HALL = :F_CITY_HALL";
                    cmd.Parameters.Add(":F_CITY_HALL", OracleDbType.Varchar2).Value = ddlFilterCityHall.SelectedValue;
                }

                if (!string.IsNullOrWhiteSpace(txtFilterHallName.Text))
                {
                    sql += " AND UPPER(H.HALL_NAME) LIKE '%' || UPPER(:F_HALL_NAME) || '%'";
                    cmd.Parameters.Add(":F_HALL_NAME", OracleDbType.Varchar2).Value = txtFilterHallName.Text.Trim();
                }

                sql += " ORDER BY TH.THEATRE_NAME, H.HALL_NAME";
                cmd.CommandText = sql;

                using (var adapter = new OracleDataAdapter(cmd))
                {
                    var table = new DataTable();
                    adapter.Fill(table);
                    gvTheatreCityHall.DataSource = table;
                    gvTheatreCityHall.DataBind();
                }
            }
        }

        #endregion

        #region Helpers

        protected void ClearForm()
        {
            ddlTheatre.SelectedIndex = 0;
            LoadCityHalls();
            ddlCityHall.SelectedIndex = 0;
            LoadHalls();
            ddlHall.SelectedIndex = 0;
            ddlCustomer.SelectedIndex = 0;
            ddlMovie.SelectedIndex = 0;
            hfSelectedTheatreId.Value = string.Empty;
            hfSelectedHallId.Value = string.Empty;
            hfSelectedCustomerId.Value = string.Empty;
            hfSelectedMovieId.Value = string.Empty;

            btnSave.Enabled = true;
            btnUpdate.Enabled = false;

            ShowMessage(string.Empty, true);
            LoadLocationByCityHall();
        }

        protected void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = string.IsNullOrWhiteSpace(message)
                ? string.Empty
                : (isSuccess ? "alert alert-success" : "alert alert-danger");
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

            if (string.IsNullOrWhiteSpace(ddlHall.SelectedValue))
            {
                errorMessage = "Hall selection is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(ddlCustomer.SelectedValue))
            {
                errorMessage = "Customer selection is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(ddlMovie.SelectedValue))
            {
                errorMessage = "Movie selection is required.";
                return false;
            }

            return true;
        }

        protected bool AssignmentExists(int theatreId, int hallId, int customerId, int movieId)
        {
            const string sql = @"SELECT COUNT(*)
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
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                return count > 0;
            }
        }

        #endregion

        #region Event Handlers

        protected void ddlTheatre_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCityHallByTheatre();
            LoadHallByTheatre();
            LoadLocationByCityHall();
        }

        protected void ddlCityHall_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLocationByCityHall();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            ShowMessage(string.Empty, true);

            if (!ValidateForm(out string validationError))
            {
                ShowMessage(validationError, false);
                return;
            }

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                ShowMessage("Please select a theatre before saving.", false);
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
                using (var cmd = new OracleCommand(@"INSERT INTO THEATRE_HALL (THEATRE_ID, HALL_ID, CUSTOMER_ID, MOVIE_ID)
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
                using (var cmd = new OracleCommand(@"UPDATE THEATRE_HALL
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
            LoadGrid();
        }

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            ddlFilterTheatre.SelectedIndex = 0;
            ddlFilterCityHall.SelectedIndex = 0;
            txtFilterHallName.Text = string.Empty;
            LoadGrid();
        }

        protected void gvTheatreCityHall_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTheatreCityHall.PageIndex = e.NewPageIndex;
            LoadGrid();
        }

        protected void gvTheatreCityHall_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null)
            {
                return;
            }

            if (e.CommandName == "EditRow")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length != 2)
                {
                    return;
                }

                if (!int.TryParse(args[0], out int theatreId) ||
                    !int.TryParse(args[1], out int hallId))
                {
                    return;
                }

                ddlTheatre.SelectedValue = theatreId.ToString();
                LoadCityHallByTheatre();
                LoadHallByTheatre();
                LoadLocationByCityHall();

                var hallItem = ddlHall.Items.FindByValue(hallId.ToString());
                if (hallItem != null)
                {
                    ddlHall.ClearSelection();
                    hallItem.Selected = true;
                }

                var row = (e.CommandSource as Control)?.NamingContainer as GridViewRow;
                if (row != null)
                {
                    var dataKey = gvTheatreCityHall.DataKeys[row.RowIndex];
                    if (dataKey != null)
                    {
                        int customerId = Convert.ToInt32(dataKey["CUSTOMER_ID"]);
                        int movieId = Convert.ToInt32(dataKey["MOVIE_ID"]);

                        var customerItem = ddlCustomer.Items.FindByValue(customerId.ToString());
                        if (customerItem != null)
                        {
                            ddlCustomer.ClearSelection();
                            customerItem.Selected = true;
                        }

                        var movieItem = ddlMovie.Items.FindByValue(movieId.ToString());
                        if (movieItem != null)
                        {
                            ddlMovie.ClearSelection();
                            movieItem.Selected = true;
                        }

                        hfSelectedTheatreId.Value = theatreId.ToString();
                        hfSelectedHallId.Value = hallId.ToString();
                        hfSelectedCustomerId.Value = customerId.ToString();
                        hfSelectedMovieId.Value = movieId.ToString();
                    }
                }

                btnSave.Enabled = false;
                btnUpdate.Enabled = true;
                ShowMessage("Edit mode: update the details and click Update to save changes.", true);
            }
            else if (e.CommandName == "DeleteRow")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length != 4)
                {
                    return;
                }

                if (!int.TryParse(args[0], out int theatreId) ||
                    !int.TryParse(args[1], out int hallId) ||
                    !int.TryParse(args[2], out int customerId) ||
                    !int.TryParse(args[3], out int movieId))
                {
                    return;
                }

                using (var conn = new OracleConnection(ConnectionString))
                using (var cmd = new OracleCommand(@"DELETE FROM THEATRE_HALL
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
        }

        #endregion
    }
}
