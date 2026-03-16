using System;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class Showtime : Page
    {
        private readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        private string SortExpression
        {
            get { return ViewState["SortExpression"] == null ? "SHOW_DATE" : ViewState["SortExpression"].ToString(); }
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
                LoadCustomers();
                LoadTheatres();
                LoadMovies();
                LoadHallDropdownAll();
                LoadFilterDropdowns();
                BindGrid();
                ClearForm();
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            ToggleValidationSummaries();
        }

        private void LoadCustomers()
        {
            LoadDropdown(
                ddlCustomer,
                "SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME",
                "CUSTOMER_NAME",
                "CUSTOMER_ID",
                "Select Customer");
        }

        private void LoadTheatres()
        {
            LoadDropdown(
                ddlTheatre,
                @"SELECT THEATRE_ID,
                         THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME
                  FROM THEATRE
                  ORDER BY THEATRE_NAME, THEATRE_CITY_HALL",
                "DISPLAY_NAME",
                "THEATRE_ID",
                "Select Theatre Branch");
        }

        private void LoadMovies()
        {
            LoadDropdown(
                ddlMovie,
                "SELECT MOVIE_ID, TITLE FROM MOVIE ORDER BY TITLE",
                "TITLE",
                "MOVIE_ID",
                "Select Movie");
        }

        private void LoadHallDropdownAll()
        {
            LoadDropdown(
                ddlHall,
                "SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME",
                "HALL_NAME",
                "HALL_ID",
                "Select Hall");
        }

        private void LoadHallsByTheatre(int theatreId)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;
                cmd.CommandText = @"
                    SELECT DISTINCT H.HALL_ID, H.HALL_NAME
                    FROM THEATRE_HALL TH
                    JOIN HALL H ON TH.HALL_ID = H.HALL_ID
                    WHERE TH.THEATRE_ID = :THEATRE_ID
                    ORDER BY H.HALL_NAME";

                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;

                conn.Open();
                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    ddlHall.DataSource = reader;
                    ddlHall.DataTextField = "HALL_NAME";
                    ddlHall.DataValueField = "HALL_ID";
                    ddlHall.DataBind();
                }
            }

            ddlHall.Items.Insert(0, new ListItem("Select Hall", ""));
        }

        private void LoadFilterDropdowns()
        {
            LoadDropdown(
                ddlFilterTheatre,
                @"SELECT THEATRE_ID,
                         THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME
                  FROM THEATRE
                  ORDER BY THEATRE_NAME, THEATRE_CITY_HALL",
                "DISPLAY_NAME",
                "THEATRE_ID",
                "All Theatres");

            LoadDropdown(
                ddlFilterMovie,
                "SELECT MOVIE_ID, TITLE FROM MOVIE ORDER BY TITLE",
                "TITLE",
                "MOVIE_ID",
                "All Movies");

            LoadDropdown(
                ddlFilterHall,
                "SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME",
                "HALL_NAME",
                "HALL_ID",
                "All Halls");
        }

        private void LoadDropdown(DropDownList ddl, string query, string textField, string valueField, string firstItemText)
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = new OracleCommand(query, conn))
            {
                conn.Open();
                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    ddl.DataSource = reader;
                    ddl.DataTextField = textField;
                    ddl.DataValueField = valueField;
                    ddl.DataBind();
                }
            }

            ddl.Items.Insert(0, new ListItem(firstItemText, ""));
        }

        protected void ddlTheatre_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtTheatreCityHall.Text = string.Empty;
            txtTheatreLocation.Text = string.Empty;
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                LoadHallDropdownAll();
                return;
            }

            int theatreId = Convert.ToInt32(ddlTheatre.SelectedValue);

            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;
                cmd.CommandText = @"
                    SELECT THEATRE_CITY_HALL, THEATRE_LOCATION
                    FROM THEATRE
                    WHERE THEATRE_ID = :THEATRE_ID";

                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;

                conn.Open();
                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtTheatreCityHall.Text = reader["THEATRE_CITY_HALL"].ToString();
                        txtTheatreLocation.Text = reader["THEATRE_LOCATION"].ToString();
                    }
                }
            }

            LoadHallsByTheatre(theatreId);
        }

        protected void ddlHall_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlHall.SelectedValue))
                return;

            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;
                cmd.CommandText = @"
                    SELECT HALL_TYPE, HALL_CAPACITY
                    FROM HALL
                    WHERE HALL_ID = :HALL_ID";

                cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);

                conn.Open();
                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtHallType.Text = reader["HALL_TYPE"].ToString();
                        txtHallCapacity.Text = reader["HALL_CAPACITY"].ToString();
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate("ShowtimeInsert");
            if (!Page.IsValid)
                return;

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                {
                    conn.Open();
                    using (OracleTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            int showId;

                            using (OracleCommand cmdShow = conn.CreateCommand())
                            {
                                cmdShow.Transaction = trans;
                                cmdShow.BindByName = true;
                                cmdShow.CommandText = @"
                                    INSERT INTO ""SHOW"" (SHOW_ID, SHOW_DATE, SHOW_TIME, SHOW_TYPE)
                                    VALUES (
                                        (SELECT NVL(MAX(SHOW_ID),0)+1 FROM ""SHOW""),
                                        :SHOW_DATE,
                                        :SHOW_TIME,
                                        :SHOW_TYPE
                                    )
                                    RETURNING SHOW_ID INTO :NEW_SHOW_ID";

                                cmdShow.Parameters.Add(":SHOW_DATE", OracleDbType.Date).Value = Convert.ToDateTime(txtShowDate.Text);
                                cmdShow.Parameters.Add(":SHOW_TIME", OracleDbType.Varchar2).Value = txtShowTime.Text.Trim();
                                cmdShow.Parameters.Add(":SHOW_TYPE", OracleDbType.Varchar2).Value = ddlShowType.SelectedValue;

                                OracleParameter outParam = new OracleParameter(":NEW_SHOW_ID", OracleDbType.Int32)
                                {
                                    Direction = ParameterDirection.Output
                                };
                                cmdShow.Parameters.Add(outParam);

                                cmdShow.ExecuteNonQuery();
                                showId = Convert.ToInt32(outParam.Value.ToString());
                            }

                            using (OracleCommand cmdHallShow = conn.CreateCommand())
                            {
                                cmdHallShow.Transaction = trans;
                                cmdHallShow.BindByName = true;
                                cmdHallShow.CommandText = @"
                                    INSERT INTO HALL_SHOW
                                    (
                                        CUSTOMER_ID,
                                        THEATRE_ID,
                                        HALL_ID,
                                        SHOW_ID,
                                        MOVIE_ID
                                    )
                                    VALUES
                                    (
                                        :CUSTOMER_ID,
                                        :THEATRE_ID,
                                        :HALL_ID,
                                        :SHOW_ID,
                                        :MOVIE_ID
                                    )";

                                cmdHallShow.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlCustomer.SelectedValue);
                                cmdHallShow.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);
                                cmdHallShow.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);
                                cmdHallShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
                                cmdHallShow.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlMovie.SelectedValue);

                                cmdHallShow.ExecuteNonQuery();
                            }

                            trans.Commit();
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }

                BindGrid();
                ClearForm();
                ShowSuccess("Showtime saved successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Page.Validate("ShowtimeEdit");
            if (!Page.IsValid)
                return;

            if (string.IsNullOrWhiteSpace(hfSelectedShowId.Value))
            {
                ShowError("No showtime selected for update.");
                return;
            }

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                {
                    conn.Open();
                    using (OracleTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            using (OracleCommand cmdShow = conn.CreateCommand())
                            {
                                cmdShow.Transaction = trans;
                                cmdShow.BindByName = true;
                                cmdShow.CommandText = @"
                                    UPDATE ""SHOW""
                                    SET SHOW_DATE = :SHOW_DATE,
                                        SHOW_TIME = :SHOW_TIME,
                                        SHOW_TYPE = :SHOW_TYPE
                                    WHERE SHOW_ID = :SHOW_ID";

                                cmdShow.Parameters.Add(":SHOW_DATE", OracleDbType.Date).Value = Convert.ToDateTime(txtShowDate.Text);
                                cmdShow.Parameters.Add(":SHOW_TIME", OracleDbType.Varchar2).Value = txtShowTime.Text.Trim();
                                cmdShow.Parameters.Add(":SHOW_TYPE", OracleDbType.Varchar2).Value = ddlShowType.SelectedValue;
                                cmdShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfSelectedShowId.Value);

                                cmdShow.ExecuteNonQuery();
                            }

                            using (OracleCommand cmdHallShow = conn.CreateCommand())
                            {
                                cmdHallShow.Transaction = trans;
                                cmdHallShow.BindByName = true;
                                cmdHallShow.CommandText = @"
                                    UPDATE HALL_SHOW
                                    SET CUSTOMER_ID = :NEW_CUSTOMER_ID,
                                        THEATRE_ID = :NEW_THEATRE_ID,
                                        HALL_ID = :NEW_HALL_ID,
                                        MOVIE_ID = :NEW_MOVIE_ID
                                    WHERE CUSTOMER_ID = :OLD_CUSTOMER_ID
                                      AND THEATRE_ID = :OLD_THEATRE_ID
                                      AND HALL_ID = :OLD_HALL_ID
                                      AND SHOW_ID = :OLD_SHOW_ID
                                      AND MOVIE_ID = :OLD_MOVIE_ID";

                                cmdHallShow.Parameters.Add(":NEW_CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlCustomer.SelectedValue);
                                cmdHallShow.Parameters.Add(":NEW_THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);
                                cmdHallShow.Parameters.Add(":NEW_HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);
                                cmdHallShow.Parameters.Add(":NEW_MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlMovie.SelectedValue);

                                cmdHallShow.Parameters.Add(":OLD_CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfOldCustomerId.Value);
                                cmdHallShow.Parameters.Add(":OLD_THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfOldTheatreId.Value);
                                cmdHallShow.Parameters.Add(":OLD_HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfOldHallId.Value);
                                cmdHallShow.Parameters.Add(":OLD_SHOW_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfOldShowId.Value);
                                cmdHallShow.Parameters.Add(":OLD_MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(hfOldMovieId.Value);

                                cmdHallShow.ExecuteNonQuery();
                            }

                            trans.Commit();
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }

                BindGrid();
                ClearForm();
                ShowSuccess("Showtime updated successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0;
            BindGrid();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            ddlFilterTheatre.SelectedIndex = 0;
            ddlFilterMovie.SelectedIndex = 0;
            ddlFilterHall.SelectedIndex = 0;
            ddlFilterShowType.SelectedIndex = 0;
            txtFilterDate.Text = string.Empty;

            GridView1.PageIndex = 0;
            BindGrid();
        }

        private void ClearForm()
        {
            if (ddlCustomer.Items.Count > 0) ddlCustomer.SelectedIndex = 0;
            if (ddlTheatre.Items.Count > 0) ddlTheatre.SelectedIndex = 0;
            if (ddlMovie.Items.Count > 0) ddlMovie.SelectedIndex = 0;

            LoadHallDropdownAll();
            if (ddlHall.Items.Count > 0) ddlHall.SelectedIndex = 0;

            if (ddlShowType.Items.Count > 0) ddlShowType.SelectedIndex = 0;

            txtTheatreCityHall.Text = string.Empty;
            txtTheatreLocation.Text = string.Empty;
            txtHallType.Text = string.Empty;
            txtHallCapacity.Text = string.Empty;
            txtShowDate.Text = string.Empty;
            txtShowTime.Text = string.Empty;

            hfSelectedShowId.Value = string.Empty;
            hfOldShowId.Value = string.Empty;
            hfOldCustomerId.Value = string.Empty;
            hfOldTheatreId.Value = string.Empty;
            hfOldHallId.Value = string.Empty;
            hfOldMovieId.Value = string.Empty;

            btnSave.Visible = true;
            btnUpdate.Visible = false;

            errorAlert.Text = string.Empty;
            errorAlert.Visible = false;
            errorAlert.CssClass = "d-none";
        }

        private void BindGrid()
        {
            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;

                StringBuilder sql = new StringBuilder();
                sql.Append(@"
                    SELECT
                        C.CUSTOMER_ID,
                        T.THEATRE_ID,
                        H.HALL_ID,
                        S.SHOW_ID,
                        M.MOVIE_ID,
                        C.CUSTOMER_NAME,
                        T.THEATRE_NAME,
                        T.THEATRE_CITY_HALL,
                        T.THEATRE_LOCATION,
                        H.HALL_NAME,
                        H.HALL_TYPE,
                        H.HALL_CAPACITY,
                        M.TITLE,
                        S.SHOW_DATE,
                        S.SHOW_TIME,
                        S.SHOW_TYPE
                    FROM HALL_SHOW HS
                    JOIN CUSTOMER C ON HS.CUSTOMER_ID = C.CUSTOMER_ID
                    JOIN THEATRE T ON HS.THEATRE_ID = T.THEATRE_ID
                    JOIN HALL H ON HS.HALL_ID = H.HALL_ID
                    JOIN ""SHOW"" S ON HS.SHOW_ID = S.SHOW_ID
                    JOIN MOVIE M ON HS.MOVIE_ID = M.MOVIE_ID
                    WHERE 1=1 ");

                if (!string.IsNullOrWhiteSpace(ddlFilterTheatre.SelectedValue))
                {
                    sql.Append(" AND HS.THEATRE_ID = :FILTER_THEATRE_ID ");
                    cmd.Parameters.Add(":FILTER_THEATRE_ID", OracleDbType.Int32).Value =
                        Convert.ToInt32(ddlFilterTheatre.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterMovie.SelectedValue))
                {
                    sql.Append(" AND HS.MOVIE_ID = :FILTER_MOVIE_ID ");
                    cmd.Parameters.Add(":FILTER_MOVIE_ID", OracleDbType.Int32).Value =
                        Convert.ToInt32(ddlFilterMovie.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterHall.SelectedValue))
                {
                    sql.Append(" AND HS.HALL_ID = :FILTER_HALL_ID ");
                    cmd.Parameters.Add(":FILTER_HALL_ID", OracleDbType.Int32).Value =
                        Convert.ToInt32(ddlFilterHall.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterShowType.SelectedValue))
                {
                    sql.Append(" AND S.SHOW_TYPE = :FILTER_SHOW_TYPE ");
                    cmd.Parameters.Add(":FILTER_SHOW_TYPE", OracleDbType.Varchar2).Value =
                        ddlFilterShowType.SelectedValue;
                }

                if (!string.IsNullOrWhiteSpace(txtFilterDate.Text))
                {
                    sql.Append(" AND TRUNC(S.SHOW_DATE) = :FILTER_SHOW_DATE ");
                    cmd.Parameters.Add(":FILTER_SHOW_DATE", OracleDbType.Date).Value =
                        Convert.ToDateTime(txtFilterDate.Text);
                }

                sql.Append($" ORDER BY {SortExpression} {SortDirection}");
                cmd.CommandText = sql.ToString();

                using (OracleDataAdapter da = new OracleDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
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

            BindGrid();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditShowtime" && e.CommandName != "DeleteShowtime")
                return;

            string[] keys = e.CommandArgument.ToString().Split('|');
            if (keys.Length != 5)
            {
                ShowError("Invalid record selection.");
                return;
            }

            int showId = Convert.ToInt32(keys[0]);
            int customerId = Convert.ToInt32(keys[1]);
            int theatreId = Convert.ToInt32(keys[2]);
            int hallId = Convert.ToInt32(keys[3]);
            int movieId = Convert.ToInt32(keys[4]);

            if (e.CommandName == "EditShowtime")
            {
                LoadRecordIntoForm(showId, customerId, theatreId, hallId, movieId);
            }
            else
            {
                DeleteShowtime(showId, customerId, theatreId, hallId, movieId);
            }
        }

        private void LoadRecordIntoForm(int showId, int customerId, int theatreId, int hallId, int movieId)
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.BindByName = true;
                    cmd.CommandText = @"
                        SELECT
                            HS.CUSTOMER_ID,
                            HS.THEATRE_ID,
                            HS.HALL_ID,
                            HS.MOVIE_ID,
                            S.SHOW_ID,
                            S.SHOW_DATE,
                            S.SHOW_TIME,
                            S.SHOW_TYPE
                        FROM HALL_SHOW HS
                        JOIN ""SHOW"" S ON HS.SHOW_ID = S.SHOW_ID
                        WHERE HS.CUSTOMER_ID = :CUSTOMER_ID
                          AND HS.THEATRE_ID = :THEATRE_ID
                          AND HS.HALL_ID = :HALL_ID
                          AND HS.SHOW_ID = :SHOW_ID
                          AND HS.MOVIE_ID = :MOVIE_ID";

                    cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = customerId;
                    cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;
                    cmd.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = hallId;
                    cmd.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
                    cmd.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = movieId;

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            ddlCustomer.SelectedValue = reader["CUSTOMER_ID"].ToString();
                            ddlTheatre.SelectedValue = reader["THEATRE_ID"].ToString();
                            ddlTheatre_SelectedIndexChanged(null, null);

                            if (ddlHall.Items.FindByValue(reader["HALL_ID"].ToString()) != null)
                                ddlHall.SelectedValue = reader["HALL_ID"].ToString();

                            ddlHall_SelectedIndexChanged(null, null);

                            ddlMovie.SelectedValue = reader["MOVIE_ID"].ToString();
                            txtShowDate.Text = Convert.ToDateTime(reader["SHOW_DATE"]).ToString("yyyy-MM-dd");
                            txtShowTime.Text = reader["SHOW_TIME"].ToString();
                            ddlShowType.SelectedValue = reader["SHOW_TYPE"].ToString();

                            hfSelectedShowId.Value = showId.ToString();
                            hfOldShowId.Value = showId.ToString();
                            hfOldCustomerId.Value = customerId.ToString();
                            hfOldTheatreId.Value = theatreId.ToString();
                            hfOldHallId.Value = hallId.ToString();
                            hfOldMovieId.Value = movieId.ToString();

                            btnSave.Visible = false;
                            btnUpdate.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        //private void DeleteShowtime(int showId, int customerId, int theatreId, int hallId, int movieId)
        //{
        //    try
        //    {
        //        using (OracleConnection conn = new OracleConnection(_connectionString))
        //        {
        //            conn.Open();
        //            using (OracleTransaction trans = conn.BeginTransaction())
        //            {
        //                try
        //                {
        //                    using (OracleCommand cmdDeleteHallShow = conn.CreateCommand())
        //                    {
        //                        cmdDeleteHallShow.Transaction = trans;
        //                        cmdDeleteHallShow.BindByName = true;
        //                        cmdDeleteHallShow.CommandText = @"
        //                            DELETE FROM HALL_SHOW
        //                            WHERE CUSTOMER_ID = :CUSTOMER_ID
        //                              AND THEATRE_ID = :THEATRE_ID
        //                              AND HALL_ID = :HALL_ID
        //                              AND SHOW_ID = :SHOW_ID
        //                              AND MOVIE_ID = :MOVIE_ID";

        //                        cmdDeleteHallShow.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = customerId;
        //                        cmdDeleteHallShow.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = theatreId;
        //                        cmdDeleteHallShow.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = hallId;
        //                        cmdDeleteHallShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
        //                        cmdDeleteHallShow.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = movieId;

        //                        cmdDeleteHallShow.ExecuteNonQuery();
        //                    }

        //                    using (OracleCommand cmdDeleteShow = conn.CreateCommand())
        //                    {
        //                        cmdDeleteShow.Transaction = trans;
        //                        cmdDeleteShow.BindByName = true;
        //                        cmdDeleteShow.CommandText = @"DELETE FROM ""SHOW"" WHERE SHOW_ID = :SHOW_ID";
        //                        cmdDeleteShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
        //                        cmdDeleteShow.ExecuteNonQuery();
        //                    }

        //                    trans.Commit();
        //                }
        //                catch
        //                {
        //                    trans.Rollback();
        //                    throw;
        //                }
        //            }
        //        }

        //        BindGrid();
        //        ClearForm();
        //        ShowSuccess("Showtime deleted successfully.");
        //    }
        //    catch (Exception ex)
        //    {
        //        ShowError("Error: " + ex.Message);
        //    }
        //}
        private void DeleteShowtime(int showId, int customerId, int theatreId, int hallId, int movieId)
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                {
                    conn.Open();

                    using (OracleTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            // 1. Collect all related ticket IDs first
                            DataTable ticketTable = new DataTable();

                            using (OracleCommand cmdGetTickets = conn.CreateCommand())
                            {
                                cmdGetTickets.Transaction = trans;
                                cmdGetTickets.BindByName = true;
                                cmdGetTickets.CommandText = @"
                            SELECT TICKET_ID
                            FROM SHOW_TICKET
                            WHERE SHOW_ID = :SHOW_ID";

                                cmdGetTickets.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;

                                using (OracleDataAdapter da = new OracleDataAdapter(cmdGetTickets))
                                {
                                    da.Fill(ticketTable);
                                }
                            }

                            // 2. Delete all bridge rows from SHOW_TICKET first
                            using (OracleCommand cmdDeleteShowTicket = conn.CreateCommand())
                            {
                                cmdDeleteShowTicket.Transaction = trans;
                                cmdDeleteShowTicket.BindByName = true;
                                cmdDeleteShowTicket.CommandText = @"
                            DELETE FROM SHOW_TICKET
                            WHERE SHOW_ID = :SHOW_ID";

                                cmdDeleteShowTicket.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
                                cmdDeleteShowTicket.ExecuteNonQuery();
                            }

                            // 3. Delete related tickets after SHOW_TICKET rows are gone
                            foreach (DataRow row in ticketTable.Rows)
                            {
                                int ticketId = Convert.ToInt32(row["TICKET_ID"]);

                                using (OracleCommand cmdDeleteTicket = conn.CreateCommand())
                                {
                                    cmdDeleteTicket.Transaction = trans;
                                    cmdDeleteTicket.BindByName = true;
                                    cmdDeleteTicket.CommandText = @"
                                DELETE FROM TICKET
                                WHERE TICKET_ID = :TICKET_ID";

                                    cmdDeleteTicket.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;
                                    cmdDeleteTicket.ExecuteNonQuery();
                                }
                            }

                            // 4. Delete all related rows from HALL_SHOW for this SHOW_ID
                            using (OracleCommand cmdDeleteHallShow = conn.CreateCommand())
                            {
                                cmdDeleteHallShow.Transaction = trans;
                                cmdDeleteHallShow.BindByName = true;
                                cmdDeleteHallShow.CommandText = @"
                            DELETE FROM HALL_SHOW
                            WHERE SHOW_ID = :SHOW_ID";

                                cmdDeleteHallShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
                                cmdDeleteHallShow.ExecuteNonQuery();
                            }

                            // 5. Finally delete the SHOW row
                            using (OracleCommand cmdDeleteShow = conn.CreateCommand())
                            {
                                cmdDeleteShow.Transaction = trans;
                                cmdDeleteShow.BindByName = true;
                                cmdDeleteShow.CommandText = @"
                            DELETE FROM ""SHOW""
                            WHERE SHOW_ID = :SHOW_ID";

                                cmdDeleteShow.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = showId;
                                cmdDeleteShow.ExecuteNonQuery();
                            }

                            trans.Commit();
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }

                BindGrid();
                ClearForm();
                ShowSuccess("Showtime and all linked records deleted successfully.");
            }
            catch (OracleException ex)
            {
                ShowError("Oracle error deleting showtime: " + ex.Message);
            }
            catch (Exception ex)
            {
                ShowError("Unexpected error deleting showtime: " + ex.Message);
            }
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

            ShowtimeInsertSummary.Visible = btnSave.Visible && shouldShowErrors;
            ShowtimeEditSummary.Visible = btnUpdate.Visible && shouldShowErrors;
        }

        private bool DidValidationRun()
        {
            if (!IsPostBack)
                return false;

            Control sourceControl = FindPostBackControl();
            if (sourceControl is IButtonControl buttonControl)
                return buttonControl.CausesValidation;

            return false;
        }

        private Control FindPostBackControl()
        {
            string eventTarget = Request.Params["__EVENTTARGET"];
            if (!string.IsNullOrEmpty(eventTarget))
                return FindControlByUniqueId(eventTarget);

            foreach (string key in Request.Form)
            {
                Control candidate = FindControlByUniqueId(key);
                if (candidate is IButtonControl)
                    return candidate;
            }

            return null;
        }

        private Control FindControlByUniqueId(string uniqueId)
        {
            if (string.IsNullOrEmpty(uniqueId))
                return null;

            string path = uniqueId.Replace('$', ':');
            return Page.FindControl(path);
        }
    }
}