using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KumariCinemas
{
    public partial class Show : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Event handlers are now wired up via FormView events in ASPX
        }

        #region Show Time Management

        /// <summary>
        /// Handle InsertButton click to combine time dropdowns
        /// </summary>
        protected void InsertButton_Click(object sender, EventArgs e)
        {
            // Get the time dropdown controls from FormView
            DropDownList ddlHour = FormView1.FindControl("ddlHour") as DropDownList;
            DropDownList ddlMinute = FormView1.FindControl("ddlMinute") as DropDownList;
            DropDownList ddlAMPM = FormView1.FindControl("ddlAMPM") as DropDownList;
            HiddenField hiddenTime = FormView1.FindControl("SHOW_TIMETextBox") as HiddenField;

            if (ddlHour != null && ddlMinute != null && ddlAMPM != null && hiddenTime != null)
            {
                // Combine the time components into HH:MM AM/PM format
                string showTime = $"{ddlHour.SelectedValue}:{ddlMinute.SelectedValue} {ddlAMPM.SelectedValue}";
                hiddenTime.Value = showTime;
            }
        }

        /// <summary>
        /// Server-side validation before insert
        /// </summary>
        protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            // Combine time dropdowns into single value
            CombineTimeValues(e.Values);

            // Validate show data
            DateTime? showDate = ParseDate(e.Values["SHOW_DATE"]);
            string showTime = e.Values["SHOW_TIME"]?.ToString();
            string showType = e.Values["SHOW_TYPE"]?.ToString();

            if (!ValidateShowData(showDate, showTime, showType, out string errorMessage))
            {
                e.Cancel = true;
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError",
                    $"alert('Validation Error: {errorMessage}');", true);
            }
        }

        /// <summary>
        /// Server-side validation before update
        /// </summary>
        protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            // Validate show data
            DateTime? showDate = ParseDate(e.NewValues["SHOW_DATE"]);
            string showTime = e.NewValues["SHOW_TIME"]?.ToString();
            string showType = e.NewValues["SHOW_TYPE"]?.ToString();

            if (!ValidateShowData(showDate, showTime, showType, out string errorMessage))
            {
                e.Cancel = true;
                ClientScript.RegisterStartupScript(this.GetType(), "ValidationError",
                    $"alert('Validation Error: {errorMessage}');", true);
            }
        }

        /// <summary>
        /// Combine time dropdown values into single string
        /// </summary>
        private void CombineTimeValues(System.Collections.Specialized.IOrderedDictionary values)
        {
            DropDownList ddlHour = FormView1.FindControl("ddlHour") as DropDownList;
            DropDownList ddlMinute = FormView1.FindControl("ddlMinute") as DropDownList;
            DropDownList ddlAMPM = FormView1.FindControl("ddlAMPM") as DropDownList;

            if (ddlHour != null && ddlMinute != null && ddlAMPM != null)
            {
                string showTime = $"{ddlHour.SelectedValue}:{ddlMinute.SelectedValue} {ddlAMPM.SelectedValue}";
                values["SHOW_TIME"] = showTime;
            }
        }

        /// <summary>
        /// Safely parse a date value that may come as string or DateTime from form binding
        /// </summary>
        private DateTime? ParseDate(object value)
        {
            if (value == null)
                return null;
            if (value is DateTime dt)
                return dt;
            if (DateTime.TryParse(value.ToString(), out DateTime parsed))
                return parsed;
            return null;
        }

        /// <summary>
        /// Comprehensive server-side validation for show data
        /// </summary>
        private bool ValidateShowData(DateTime? showDate, string showTime, string showType, out string errorMessage)
        {
            errorMessage = string.Empty;

            // Validate Show Date
            if (!showDate.HasValue)
            {
                errorMessage = "Show date is required.";
                return false;
            }

            // Check if date is not in the past
            if (showDate.Value.Date < DateTime.Now.Date)
            {
                errorMessage = "Show date cannot be in the past. Please select today or a future date.";
                return false;
            }

            // Validate Show Time
            if (string.IsNullOrWhiteSpace(showTime))
            {
                errorMessage = "Show time is required.";
                return false;
            }

            // Validate Show Type
            if (string.IsNullOrWhiteSpace(showType))
            {
                errorMessage = "Show type is required.";
                return false;
            }

            return true;
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
