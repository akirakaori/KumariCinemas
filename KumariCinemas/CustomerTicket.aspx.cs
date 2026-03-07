using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System;

namespace KumariCinemas
{
    public partial class CustomerTicket : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            if (string.IsNullOrWhiteSpace(ddlCustomer.SelectedValue))
            {
                lblMessage.Text = "Please select a customer.";
                GridView1.DataSource = null;
                GridView1.DataBind();
                return;
            }

            GridView1.DataBind();
        }
    }
}