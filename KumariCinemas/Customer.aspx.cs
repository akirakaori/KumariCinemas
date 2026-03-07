using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace KumariCinemas
{
    public partial class Customer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Event handlers are now wired up via FormView events in ASPX
        }

        #region Server-Side Validation

        /// <summary>
        /// Server-side validation before insert
        /// </summary>
        protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            // Get values from form
            string customerName = e.Values["CUSTOMER_NAME"]?.ToString();
            string email = e.Values["EMAIL"]?.ToString();
            string contactNumber = e.Values["CONTACT_NUMBER"]?.ToString();
            string address = e.Values["ADDRESS"]?.ToString();

            // Perform server-side validation
            if (!ValidateCustomerData(customerName, email, contactNumber, address, out string errorMessage))
            {
                e.Cancel = true;
                // Display error message to user
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError", 
                    $"alert('Validation Error: {errorMessage}');", true);
            }
        }

        /// <summary>
        /// Server-side validation before update
        /// </summary>
        protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            // Get values from form
            string customerName = e.NewValues["CUSTOMER_NAME"]?.ToString();
            string email = e.NewValues["EMAIL"]?.ToString();
            string contactNumber = e.NewValues["CONTACT_NUMBER"]?.ToString();
            string address = e.NewValues["ADDRESS"]?.ToString();

            // Perform server-side validation
            if (!ValidateCustomerData(customerName, email, contactNumber, address, out string errorMessage))
            {
                e.Cancel = true;
                // Display error message to user
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError", 
                    $"alert('Validation Error: {errorMessage}');", true);
            }
        }

        /// <summary>
        /// Comprehensive server-side validation method
        /// </summary>
        private bool ValidateCustomerData(string name, string email, string phone, string address, out string errorMessage)
        {
            errorMessage = string.Empty;

            // Validate Name
            if (string.IsNullOrWhiteSpace(name))
            {
                errorMessage = "Customer name is required.";
                return false;
            }
            if (name.Length < 2 || name.Length > 100)
            {
                errorMessage = "Customer name must be between 2 and 100 characters.";
                return false;
            }
            if (!Regex.IsMatch(name, @"^[a-zA-Z\s]+$"))
            {
                errorMessage = "Customer name must contain only letters and spaces.";
                return false;
            }

            // Validate Email
            if (string.IsNullOrWhiteSpace(email))
            {
                errorMessage = "Email address is required.";
                return false;
            }
            if (!Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))
            {
                errorMessage = "Invalid email format. Please enter a valid email address.";
                return false;
            }

            // Validate Phone Number
            if (string.IsNullOrWhiteSpace(phone))
            {
                errorMessage = "Phone number is required.";
                return false;
            }
            if (!Regex.IsMatch(phone, @"^(\+94[0-9]{9}|[0-9]{10})$"))
            {
                errorMessage = "Invalid phone number format. Use 10 digits or +94XXXXXXXXX format.";
                return false;
            }

            // Validate Address
            if (string.IsNullOrWhiteSpace(address))
            {
                errorMessage = "Address is required.";
                return false;
            }
            if (address.Length < 5)
            {
                errorMessage = "Address must be at least 5 characters long.";
                return false;
            }

            // Additional security: Prevent SQL injection attempts
            if (ContainsSQLInjectionPatterns(name) || ContainsSQLInjectionPatterns(email) || 
                ContainsSQLInjectionPatterns(phone) || ContainsSQLInjectionPatterns(address))
            {
                errorMessage = "Invalid characters detected. Please remove special SQL characters.";
                return false;
            }

            return true;
        }

        /// <summary>
        /// Check for common SQL injection patterns
        /// </summary>
        private bool ContainsSQLInjectionPatterns(string input)
        {
            if (string.IsNullOrEmpty(input)) return false;

            string[] sqlKeywords = { "--", ";--", "';", "/*", "*/", "xp_", "sp_", "exec(", "execute(", "select ", "insert ", "update ", "delete ", "drop ", "create ", "alter " };

            string lowerInput = input.ToLower();
            foreach (string keyword in sqlKeywords)
            {
                if (lowerInput.Contains(keyword))
                    return true;
            }
            return false;
        }

        #endregion

        #region GridView Scroll Position Fix - Event Handlers

        /// <summary>
        /// Scrolls to GridView section after postback
        /// </summary>
        private void ScrollToGridView()
        {
            string script = @"
                <script type='text/javascript'>
                    window.addEventListener('load', function() {
                        var gridSection = document.getElementById('gridSection');
                        if (gridSection) {
                            // Smooth scroll to GridView section
                            gridSection.scrollIntoView({ behavior: 'smooth', block: 'start' });

                            // Alternative: Offset scroll (if you want some space above)
                            // var offset = 100;
                            // window.scrollTo({
                            //     top: gridSection.offsetTop - offset,
                            //     behavior: 'smooth'
                            // });
                        }
                    });
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "ScrollToGrid", script, false);
        }

        // Pagination event - scroll to GridView
        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ScrollToGridView();
        }

        // Sorting event - scroll to GridView
        protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
        {
            ScrollToGridView();
        }

        // Row editing event - scroll to GridView
        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            ScrollToGridView();
        }

        // Row updating event - scroll to GridView
        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            ScrollToGridView();
        }

        // Cancel edit event - scroll to GridView
        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            ScrollToGridView();
        }

        // Delete event - scroll to GridView
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            ScrollToGridView();
        }

        #endregion
    }
}
