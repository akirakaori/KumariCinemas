using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KumariCinemas
{
    public partial class TopTheatreOccupancy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            if (string.IsNullOrWhiteSpace(ddlMovie.SelectedValue))
            {
                lblMessage.Text = "Please select a movie.";
                GridView1.DataSource = null;
                GridView1.DataBind();
                return;
            }

            GridView1.DataBind();
        }
    }
}