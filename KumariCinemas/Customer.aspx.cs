using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KumariCinemas
{
    public partial class Customer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

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
