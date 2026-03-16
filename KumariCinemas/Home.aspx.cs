using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web.UI;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class Home : System.Web.UI.Page
    {
        private readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
                LoadChartData();
            }
        }

        private void LoadDashboardStats()
        {
            LoadCustomerCount();
            LoadMovieCount();
            LoadTheatreCount();
            LoadTicketCount();
        }

        private void LoadChartData()
        {
            try
            {
                string moviePopularityJson = GetMoviePopularityData();
                string genreDistributionJson = GetGenreDistributionData();
                string dailyBookingsJson = GetDailyBookingsData();
                string ticketStatusJson = GetTicketStatusData();

                ScriptManager.RegisterStartupScript(this, GetType(), "chartData",
                    $@"
                    var moviePopularityData = {moviePopularityJson};
                    var genreDistributionData = {genreDistributionJson};
                    var dailyBookingsData = {dailyBookingsJson};
                    var ticketStatusData = {ticketStatusJson};
                    ", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading chart data: {ex.Message}");
            }
        }

        private string GetMoviePopularityData()
        {
            var labels = new List<string>();
            var data = new List<int>();

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT M.TITLE, COUNT(ST.TICKET_ID) AS TOTAL
                        FROM MOVIE M
                        JOIN HALL_SHOW HS ON M.MOVIE_ID = HS.MOVIE_ID
                        JOIN SHOW_TICKET ST ON HS.SHOW_ID = ST.SHOW_ID
                        GROUP BY M.TITLE
                        ORDER BY TOTAL DESC";

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            labels.Add(reader["TITLE"].ToString());
                            data.Add(Convert.ToInt32(reader["TOTAL"]));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetMoviePopularityData: {ex.Message}");
            }

            return ConvertToChartJson(labels, data);
        }

        private string GetGenreDistributionData()
        {
            var labels = new List<string>();
            var data = new List<int>();

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT GENRE, COUNT(*) AS TOTAL
                        FROM MOVIE
                        GROUP BY GENRE
                        ORDER BY TOTAL DESC";

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            labels.Add(reader["GENRE"].ToString());
                            data.Add(Convert.ToInt32(reader["TOTAL"]));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetGenreDistributionData: {ex.Message}");
            }

            return ConvertToChartJson(labels, data);
        }

        private string GetDailyBookingsData()
        {
            var labels = new List<string>();
            var data = new List<int>();

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT TRUNC(BOOKING_DATE) AS BOOKING_DATE, COUNT(*) AS TOTAL
                        FROM TICKET
                        WHERE BOOKING_DATE >= SYSDATE - 30
                        GROUP BY TRUNC(BOOKING_DATE)
                        ORDER BY BOOKING_DATE ASC";

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DateTime date = Convert.ToDateTime(reader["BOOKING_DATE"]);
                            labels.Add(date.ToString("yyyy-MM-dd"));
                            data.Add(Convert.ToInt32(reader["TOTAL"]));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetDailyBookingsData: {ex.Message}");
            }

            return ConvertToChartJson(labels, data);
        }

        private string GetTicketStatusData()
        {
            var labels = new List<string>();
            var data = new List<int>();

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                        SELECT STATUS, COUNT(*) AS TOTAL
                        FROM TICKET
                        GROUP BY STATUS
                        ORDER BY TOTAL DESC";

                    conn.Open();
                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            labels.Add(reader["STATUS"].ToString());
                            data.Add(Convert.ToInt32(reader["TOTAL"]));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetTicketStatusData: {ex.Message}");
            }

            return ConvertToChartJson(labels, data);
        }

        private string ConvertToChartJson(List<string> labels, List<int> data)
        {
            var sb = new StringBuilder();
            sb.Append("{");
            sb.Append("\"labels\":[");
            for (int i = 0; i < labels.Count; i++)
            {
                sb.Append($"\"{EscapeJson(labels[i])}\"");
                if (i < labels.Count - 1) sb.Append(",");
            }
            sb.Append("],");
            sb.Append("\"data\":[");
            for (int i = 0; i < data.Count; i++)
            {
                sb.Append(data[i]);
                if (i < data.Count - 1) sb.Append(",");
            }
            sb.Append("]");
            sb.Append("}");
            return sb.ToString();
        }

        private string EscapeJson(string text)
        {
            if (string.IsNullOrEmpty(text)) return "";
            return text.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "\\r");
        }

        private void LoadCustomerCount()
        {
            try
            {
                DataView dvCustomers = (DataView)SqlDataSourceCustomers.Select(DataSourceSelectArguments.Empty);
                if (dvCustomers != null && dvCustomers.Count > 0)
                {
                    object totalValue = dvCustomers[0]["TOTAL"];
                    int customerCount = Convert.ToInt32(totalValue);
                    lblTotalCustomers.Text = customerCount.ToString("N0");
                }
                else
                {
                    lblTotalCustomers.Text = "0";
                }
            }
            catch (Exception ex)
            {
                lblTotalCustomers.Text = "0";
                System.Diagnostics.Debug.WriteLine($"Error loading customer count: {ex.Message}");
            }
        }

        private void LoadMovieCount()
        {
            try
            {
                DataView dvMovies = (DataView)SqlDataSourceMovies.Select(DataSourceSelectArguments.Empty);
                if (dvMovies != null && dvMovies.Count > 0)
                {
                    object totalValue = dvMovies[0]["TOTAL"];
                    int movieCount = Convert.ToInt32(totalValue);
                    lblTotalMovies.Text = movieCount.ToString("N0");
                }
                else
                {
                    lblTotalMovies.Text = "0";
                }
            }
            catch (Exception ex)
            {
                lblTotalMovies.Text = "0";
                System.Diagnostics.Debug.WriteLine($"Error loading movie count: {ex.Message}");
            }
        }

        private void LoadTheatreCount()
        {
            try
            {
                DataView dvTheatres = (DataView)SqlDataSourceTheatres.Select(DataSourceSelectArguments.Empty);
                if (dvTheatres != null && dvTheatres.Count > 0)
                {
                    object totalValue = dvTheatres[0]["TOTAL"];
                    int theatreCount = Convert.ToInt32(totalValue);
                    lblTotalTheatres.Text = theatreCount.ToString("N0");
                }
                else
                {
                    lblTotalTheatres.Text = "0";
                }
            }
            catch (Exception ex)
            {
                lblTotalTheatres.Text = "0";
                System.Diagnostics.Debug.WriteLine($"Error loading theatre count: {ex.Message}");
            }
        }

        private void LoadTicketCount()
        {
            try
            {
                DataView dvTickets = (DataView)SqlDataSourceTickets.Select(DataSourceSelectArguments.Empty);
                if (dvTickets != null && dvTickets.Count > 0)
                {
                    object totalValue = dvTickets[0]["TOTAL"];
                    int ticketCount = Convert.ToInt32(totalValue);
                    lblTotalTickets.Text = ticketCount.ToString("N0");
                }
                else
                {
                    lblTotalTickets.Text = "0";
                }
            }
            catch (Exception ex)
            {
                lblTotalTickets.Text = "0";
                System.Diagnostics.Debug.WriteLine($"Error loading ticket count: {ex.Message}");
            }
        }
    }
}



