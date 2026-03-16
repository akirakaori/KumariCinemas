using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class CustomerTicket : System.Web.UI.Page
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
            get { return ViewState["SortDirection"] == null ? "DESC" : ViewState["SortDirection"].ToString(); }
            set { ViewState["SortDirection"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlResults.Visible = false;
                txtEmail.Text = string.Empty;
            }
        }

        protected void ddlCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Text = string.Empty;
            txtEmail.Text = string.Empty;

            // Customer select गर्दा email मात्र आउँछ, report hidden रहन्छ
            pnlResults.Visible = false;
            GridView1.DataSource = null;
            GridView1.DataBind();

            if (string.IsNullOrWhiteSpace(ddlCustomer.SelectedValue))
            {
                return;
            }

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.BindByName = true;
                    cmd.CommandText = @"SELECT EMAIL
                                        FROM CUSTOMER
                                        WHERE CUSTOMER_ID = :CUSTOMER_ID";

                    cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value =
                        Convert.ToInt32(ddlCustomer.SelectedValue);

                    conn.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        txtEmail.Text = result.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading customer email: " + ex.Message;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            lblMessage.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlCustomer.SelectedValue))
            {
                lblMessage.Text = "Please select a customer.";
                pnlResults.Visible = false;
                GridView1.DataSource = null;
                GridView1.DataBind();
                txtEmail.Text = string.Empty;
                return;
            }

            GridView1.PageIndex = 0;
            pnlResults.Visible = true;
            BindReport();
        }

        private void BindReport()
        {
            if (string.IsNullOrWhiteSpace(ddlCustomer.SelectedValue))
            {
                pnlResults.Visible = false;
                GridView1.DataSource = null;
                GridView1.DataBind();
                return;
            }

            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;
                cmd.CommandText = $@"
                    SELECT DISTINCT
                        C.CUSTOMER_NAME,
                        C.EMAIL,
                        T.TICKET_ID,
                        M.TITLE,
                        S.SHOW_DATE,
                        S.SHOW_TIME,
                        T.SEAT_NUMBER,
                        T.TICKET_PRICE,
                        T.STATUS
                    FROM CUSTOMER C
                    JOIN SHOW_TICKET ST ON C.CUSTOMER_ID = ST.CUSTOMER_ID
                    JOIN TICKET T ON ST.TICKET_ID = T.TICKET_ID
                    JOIN MOVIE M ON ST.MOVIE_ID = M.MOVIE_ID
                    JOIN ""SHOW"" S ON ST.SHOW_ID = S.SHOW_ID
                    WHERE C.CUSTOMER_ID = :CUSTOMER_ID
                      AND T.BOOKING_DATE >= ADD_MONTHS(SYSDATE, -6)
                    ORDER BY {SortExpression} {SortDirection}";

                cmd.Parameters.Add(":CUSTOMER_ID", OracleDbType.Int32).Value =
                    Convert.ToInt32(ddlCustomer.SelectedValue);

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
            BindReport();
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

            BindReport();
        }
    }
}