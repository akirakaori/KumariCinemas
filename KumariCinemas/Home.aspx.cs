using System;
using System.Data;
using System.Web.UI;

namespace KumariCinemas
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
            }
        }

        private void LoadDashboardStats()
        {
            LoadCustomerCount();
            LoadMovieCount();
            LoadTheatreCount();
            LoadTicketCount();
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



