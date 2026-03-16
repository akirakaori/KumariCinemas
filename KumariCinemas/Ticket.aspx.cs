using System;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class Ticket : Page
    {
        private readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        private string SortExpression
        {
            get { return ViewState["SortExpression"] == null ? "BOOKING_DATE" : ViewState["SortExpression"].ToString(); }
            set { ViewState["SortExpression"] = value; }
        }

        private string SortDirection
        {
            get { return ViewState["SortDirection"] == null ? "DESC" : ViewState["SortDirection"].ToString(); }
            set { ViewState["SortDirection"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFormDropdowns();
                LoadFilterDropdowns();
                BindGrid();
                ClearForm();
            }
        }

        private void LoadFormDropdowns()
        {
            LoadDropdown(ddlCustomer,
                "SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME",
                "CUSTOMER_NAME", "CUSTOMER_ID", "Select Customer");

            LoadDropdown(ddlMovie,
                "SELECT MOVIE_ID, TITLE FROM MOVIE ORDER BY TITLE",
                "TITLE", "MOVIE_ID", "Select Movie");

            LoadDropdown(ddlTheatre,
                "SELECT THEATRE_ID, THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME FROM THEATRE ORDER BY THEATRE_NAME, THEATRE_CITY_HALL",
                "DISPLAY_NAME", "THEATRE_ID", "Select Theatre Branch");

            LoadDropdown(ddlHall,
                "SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME",
                "HALL_NAME", "HALL_ID", "Select Hall");

            LoadShows();
        }

        private void LoadFilterDropdowns()
        {
            LoadDropdown(ddlFilterCustomer,
                "SELECT CUSTOMER_ID, CUSTOMER_NAME FROM CUSTOMER ORDER BY CUSTOMER_NAME",
                "CUSTOMER_NAME", "CUSTOMER_ID", "All Customers");

            LoadDropdown(ddlFilterMovie,
                "SELECT MOVIE_ID, TITLE FROM MOVIE ORDER BY TITLE",
                "TITLE", "MOVIE_ID", "All Movies");

            LoadDropdown(ddlFilterTheatre,
                "SELECT THEATRE_ID, THEATRE_NAME || ' - ' || THEATRE_CITY_HALL AS DISPLAY_NAME FROM THEATRE ORDER BY THEATRE_NAME, THEATRE_CITY_HALL",
                "DISPLAY_NAME", "THEATRE_ID", "All Theatre Branches");

            LoadDropdown(ddlFilterHall,
                "SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME",
                "HALL_NAME", "HALL_ID", "All Halls");
        }

        private void LoadDropdown(DropDownList ddl, string query, string textField, string valueField, string firstText)
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

            ddl.Items.Insert(0, new ListItem(firstText, ""));
        }

        private void LoadShows()
        {
            ddlShow.Items.Clear();

            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
                    SELECT SHOW_ID,
                           TO_CHAR(SHOW_DATE, 'YYYY-MM-DD') || ' - ' || SHOW_TIME || ' - ' || SHOW_TYPE AS DISPLAY_SHOW
                    FROM ""SHOW""
                    ORDER BY SHOW_DATE DESC, SHOW_TIME DESC";

                conn.Open();
                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    ddlShow.DataSource = reader;
                    ddlShow.DataTextField = "DISPLAY_SHOW";
                    ddlShow.DataValueField = "SHOW_ID";
                    ddlShow.DataBind();
                }
            }

            ddlShow.Items.Insert(0, new ListItem("Select Show", ""));
        }

        protected void ddlTheatre_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlHall.Items.Clear();

            if (string.IsNullOrWhiteSpace(ddlTheatre.SelectedValue))
            {
                ddlHall.Items.Insert(0, new ListItem("Select Hall", ""));
                return;
            }

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

                cmd.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);

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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate("TicketInsert");
            if (!Page.IsValid) return;

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                {
                    conn.Open();

                    using (OracleTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            int ticketId;

                            using (OracleCommand cmdTicket = conn.CreateCommand())
                            {
                                cmdTicket.Transaction = trans;
                                cmdTicket.BindByName = true;
                                cmdTicket.CommandText = @"
                                    INSERT INTO TICKET
                                    (
                                        TICKET_ID,
                                        TICKET_PRICE,
                                        BOOKING_DATE,
                                        STATUS,
                                        SEAT_NUMBER
                                    )
                                    VALUES
                                    (
                                        (SELECT NVL(MAX(TICKET_ID),0)+1 FROM TICKET),
                                        :TICKET_PRICE,
                                        :BOOKING_DATE,
                                        :STATUS,
                                        :SEAT_NUMBER
                                    )
                                    RETURNING TICKET_ID INTO :NEW_TICKET_ID";

                                cmdTicket.Parameters.Add(":TICKET_PRICE", OracleDbType.Decimal).Value = Convert.ToDecimal(txtTicketPrice.Text);
                                cmdTicket.Parameters.Add(":BOOKING_DATE", OracleDbType.Date).Value = Convert.ToDateTime(txtBookingDate.Text);
                                cmdTicket.Parameters.Add(":STATUS", OracleDbType.Varchar2).Value = ddlStatus.SelectedValue;
                                cmdTicket.Parameters.Add(":SEAT_NUMBER", OracleDbType.Varchar2).Value = txtSeatNumber.Text.Trim();

                                OracleParameter outParam = new OracleParameter(":NEW_TICKET_ID", OracleDbType.Int32)
                                {
                                    Direction = ParameterDirection.Output
                                };
                                cmdTicket.Parameters.Add(outParam);

                                cmdTicket.ExecuteNonQuery();
                                ticketId = Convert.ToInt32(outParam.Value.ToString());
                            }

                            using (OracleCommand cmdShowTicket = conn.CreateCommand())
                            {
                                cmdShowTicket.Transaction = trans;
                                cmdShowTicket.BindByName = true;
                                cmdShowTicket.CommandText = @"
                                    INSERT INTO SHOW_TICKET
                                    (
                                        CUSTOMER_ID,
                                        MOVIE_ID,
                                        THEATRE_ID,
                                        HALL_ID,
                                        SHOW_ID,
                                        TICKET_ID
                                    )
                                    VALUES
                                    (
                                        :CUSTOMER_ID,
                                        :MOVIE_ID,
                                        :THEATRE_ID,
                                        :HALL_ID,
                                        :SHOW_ID,
                                        :TICKET_ID
                                    )";

                                cmdShowTicket.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlCustomer.SelectedValue);
                                cmdShowTicket.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlMovie.SelectedValue);
                                cmdShowTicket.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);
                                cmdShowTicket.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);
                                cmdShowTicket.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlShow.SelectedValue);
                                cmdShowTicket.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;

                                cmdShowTicket.ExecuteNonQuery();
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
                ShowSuccess("Ticket saved successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Error saving ticket: " + ex.Message);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Page.Validate("TicketEdit");
            if (!Page.IsValid) return;

            if (string.IsNullOrWhiteSpace(hfSelectedTicketId.Value))
            {
                ShowError("No ticket selected for update.");
                return;
            }

            int ticketId = Convert.ToInt32(hfSelectedTicketId.Value);

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                {
                    conn.Open();

                    using (OracleTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            using (OracleCommand cmdTicket = conn.CreateCommand())
                            {
                                cmdTicket.Transaction = trans;
                                cmdTicket.BindByName = true;
                                cmdTicket.CommandText = @"
                                    UPDATE TICKET
                                    SET TICKET_PRICE = :TICKET_PRICE,
                                        BOOKING_DATE = :BOOKING_DATE,
                                        STATUS = :STATUS,
                                        SEAT_NUMBER = :SEAT_NUMBER
                                    WHERE TICKET_ID = :TICKET_ID";

                                cmdTicket.Parameters.Add(":TICKET_PRICE", OracleDbType.Decimal).Value = Convert.ToDecimal(txtTicketPrice.Text);
                                cmdTicket.Parameters.Add(":BOOKING_DATE", OracleDbType.Date).Value = Convert.ToDateTime(txtBookingDate.Text);
                                cmdTicket.Parameters.Add(":STATUS", OracleDbType.Varchar2).Value = ddlStatus.SelectedValue;
                                cmdTicket.Parameters.Add(":SEAT_NUMBER", OracleDbType.Varchar2).Value = txtSeatNumber.Text.Trim();
                                cmdTicket.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;

                                cmdTicket.ExecuteNonQuery();
                            }

                            using (OracleCommand cmdShowTicket = conn.CreateCommand())
                            {
                                cmdShowTicket.Transaction = trans;
                                cmdShowTicket.BindByName = true;
                                cmdShowTicket.CommandText = @"
                                    UPDATE SHOW_TICKET
                                    SET CUSTOMER_ID = :CUSTOMER_ID,
                                        MOVIE_ID = :MOVIE_ID,
                                        THEATRE_ID = :THEATRE_ID,
                                        HALL_ID = :HALL_ID,
                                        SHOW_ID = :SHOW_ID
                                    WHERE TICKET_ID = :TICKET_ID";

                                cmdShowTicket.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlCustomer.SelectedValue);
                                cmdShowTicket.Parameters.Add(":MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlMovie.SelectedValue);
                                cmdShowTicket.Parameters.Add(":THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlTheatre.SelectedValue);
                                cmdShowTicket.Parameters.Add(":HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlHall.SelectedValue);
                                cmdShowTicket.Parameters.Add(":SHOW_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlShow.SelectedValue);
                                cmdShowTicket.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;

                                cmdShowTicket.ExecuteNonQuery();
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
                ShowSuccess("Ticket updated successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Error updating ticket: " + ex.Message);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            if (ddlCustomer.Items.Count > 0) ddlCustomer.SelectedIndex = 0;
            if (ddlMovie.Items.Count > 0) ddlMovie.SelectedIndex = 0;
            if (ddlTheatre.Items.Count > 0) ddlTheatre.SelectedIndex = 0;

            LoadDropdown(ddlHall,
                "SELECT HALL_ID, HALL_NAME FROM HALL ORDER BY HALL_NAME",
                "HALL_NAME", "HALL_ID", "Select Hall");

            LoadShows();

            txtSeatNumber.Text = string.Empty;
            txtTicketPrice.Text = string.Empty;
            txtBookingDate.Text = string.Empty;
            if (ddlStatus.Items.Count > 0) ddlStatus.SelectedIndex = 0;

            hfSelectedTicketId.Value = string.Empty;
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
                    SELECT DISTINCT
                        T.TICKET_ID,
                        C.CUSTOMER_NAME,
                        M.TITLE,
                        TH.THEATRE_NAME,
                        H.HALL_NAME,
                        S.SHOW_DATE,
                        S.SHOW_TIME,
                        T.SEAT_NUMBER,
                        T.BOOKING_DATE,
                        T.TICKET_PRICE,
                        T.STATUS
                    FROM TICKET T
                    JOIN SHOW_TICKET ST ON T.TICKET_ID = ST.TICKET_ID
                    JOIN CUSTOMER C ON ST.CUSTOMER_ID = C.CUSTOMER_ID
                    JOIN ""SHOW"" S ON ST.SHOW_ID = S.SHOW_ID
                    JOIN HALL_SHOW HS ON S.SHOW_ID = HS.SHOW_ID
                    JOIN MOVIE M ON HS.MOVIE_ID = M.MOVIE_ID
                    JOIN THEATRE TH ON HS.THEATRE_ID = TH.THEATRE_ID
                    JOIN HALL H ON HS.HALL_ID = H.HALL_ID
                    WHERE 1 = 1 ");

                if (!string.IsNullOrWhiteSpace(ddlFilterCustomer.SelectedValue))
                {
                    sql.Append(" AND C.CUSTOMER_ID = :FILTER_CUSTOMER_ID ");
                    cmd.Parameters.Add(":FILTER_CUSTOMER_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterCustomer.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterMovie.SelectedValue))
                {
                    sql.Append(" AND M.MOVIE_ID = :FILTER_MOVIE_ID ");
                    cmd.Parameters.Add(":FILTER_MOVIE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterMovie.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterTheatre.SelectedValue))
                {
                    sql.Append(" AND TH.THEATRE_ID = :FILTER_THEATRE_ID ");
                    cmd.Parameters.Add(":FILTER_THEATRE_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterTheatre.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterHall.SelectedValue))
                {
                    sql.Append(" AND H.HALL_ID = :FILTER_HALL_ID ");
                    cmd.Parameters.Add(":FILTER_HALL_ID", OracleDbType.Int32).Value = Convert.ToInt32(ddlFilterHall.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(ddlFilterStatus.SelectedValue))
                {
                    sql.Append(" AND UPPER(T.STATUS) = UPPER(:FILTER_STATUS) ");
                    cmd.Parameters.Add(":FILTER_STATUS", OracleDbType.Varchar2).Value = ddlFilterStatus.SelectedValue;
                }

                if (!string.IsNullOrWhiteSpace(txtFilterShowDate.Text))
                {
                    sql.Append(" AND TRUNC(S.SHOW_DATE) = :FILTER_SHOW_DATE ");
                    cmd.Parameters.Add(":FILTER_SHOW_DATE", OracleDbType.Date).Value = Convert.ToDateTime(txtFilterShowDate.Text);
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

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0;
            BindGrid();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            ddlFilterCustomer.SelectedIndex = 0;
            ddlFilterMovie.SelectedIndex = 0;
            ddlFilterTheatre.SelectedIndex = 0;
            ddlFilterHall.SelectedIndex = 0;
            ddlFilterStatus.SelectedIndex = 0;
            txtFilterShowDate.Text = string.Empty;

            GridView1.PageIndex = 0;
            BindGrid();
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
            if (e.CommandName == "DeleteTicket")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int ticketId))
                    DeleteTicket(ticketId);
            }
            else if (e.CommandName == "EditTicket")
            {
                if (int.TryParse(e.CommandArgument.ToString(), out int ticketId))
                    LoadTicketIntoForm(ticketId);
            }
        }

        private void LoadTicketIntoForm(int ticketId)
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.BindByName = true;
                    cmd.CommandText = @"
                        SELECT
                            T.TICKET_ID,
                            T.TICKET_PRICE,
                            T.BOOKING_DATE,
                            T.STATUS,
                            T.SEAT_NUMBER,
                            ST.CUSTOMER_ID,
                            ST.MOVIE_ID,
                            ST.THEATRE_ID,
                            ST.HALL_ID,
                            ST.SHOW_ID
                        FROM TICKET T
                        JOIN SHOW_TICKET ST ON T.TICKET_ID = ST.TICKET_ID
                        WHERE T.TICKET_ID = :TICKET_ID";

                    cmd.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            ddlCustomer.SelectedValue = reader["CUSTOMER_ID"].ToString();
                            ddlMovie.SelectedValue = reader["MOVIE_ID"].ToString();
                            ddlTheatre.SelectedValue = reader["THEATRE_ID"].ToString();
                            ddlTheatre_SelectedIndexChanged(null, null);

                            if (ddlHall.Items.FindByValue(reader["HALL_ID"].ToString()) != null)
                                ddlHall.SelectedValue = reader["HALL_ID"].ToString();

                            if (ddlShow.Items.FindByValue(reader["SHOW_ID"].ToString()) != null)
                                ddlShow.SelectedValue = reader["SHOW_ID"].ToString();

                            txtSeatNumber.Text = reader["SEAT_NUMBER"].ToString();
                            txtTicketPrice.Text = reader["TICKET_PRICE"].ToString();
                            txtBookingDate.Text = Convert.ToDateTime(reader["BOOKING_DATE"]).ToString("yyyy-MM-dd");
                            ddlStatus.SelectedValue = reader["STATUS"].ToString();

                            hfSelectedTicketId.Value = ticketId.ToString();
                            btnSave.Visible = false;
                            btnUpdate.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading ticket: " + ex.Message);
            }
        }

        private void DeleteTicket(int ticketId)
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
                            using (OracleCommand cmdDeleteShowTicket = conn.CreateCommand())
                            {
                                cmdDeleteShowTicket.Transaction = trans;
                                cmdDeleteShowTicket.BindByName = true;
                                cmdDeleteShowTicket.CommandText = @"
                                    DELETE FROM SHOW_TICKET
                                    WHERE TICKET_ID = :TICKET_ID";

                                cmdDeleteShowTicket.Parameters.Add(":TICKET_ID", OracleDbType.Int32).Value = ticketId;
                                cmdDeleteShowTicket.ExecuteNonQuery();
                            }

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
                ShowSuccess("Ticket and linked records deleted successfully.");
            }
            catch (OracleException ex)
            {
                ShowError("Error deleting ticket: " + ex.Message);
            }
            catch (Exception ex)
            {
                ShowError("Unexpected error: " + ex.Message);
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
    }
}