using System;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;

namespace KumariCinemas
{
    public partial class Customer : Page
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["OracleConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeFormView(FormViewMode.Insert);
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            ToggleValidationSummaries();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCustomer")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                LoadCustomerIntoForm(id);
            }

            else if (e.CommandName == "DeleteCustomer")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                DeleteCustomer(id);
            }
        }

        private void LoadCustomerIntoForm(int customerId)
        {
            FormView formView = ResolveFormView();
            if (formView == null)
            {
                return;
            }

            using (OracleConnection conn = new OracleConnection(_connectionString))
            using (OracleCommand cmd = conn.CreateCommand())
            {
                cmd.BindByName = true;

                cmd.CommandText = @"SELECT CUSTOMER_NAME,
                                   CONTACT_NUMBER,
                                   EMAIL,
                                   ADDRESS
                            FROM CUSTOMER
                            WHERE CUSTOMER_ID = :id";

                cmd.Parameters.Add(":id", OracleDbType.Int32).Value = customerId;

                conn.Open();

                using (OracleDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        formView.ChangeMode(FormViewMode.Edit);
                        InitializeFormView(FormViewMode.Edit);

                        SetTextBoxValue("txtNameEdit", reader["CUSTOMER_NAME"].ToString());
                        SetTextBoxValue("txtEmailEdit", reader["EMAIL"].ToString());
                        SetTextBoxValue("txtPhoneEdit", reader["CONTACT_NUMBER"].ToString());
                        SetTextBoxValue("txtAddressEdit", reader["ADDRESS"].ToString());

                        ViewState["EditID"] = customerId;
                    }
                }
            }
        }

        protected void UpdateCustomer(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            if (ViewState["EditID"] == null)
                return;

            int id = Convert.ToInt32(ViewState["EditID"]);

            string name = GetTextBoxValue("txtNameEdit");
            string email = GetTextBoxValue("txtEmailEdit");
            string phone = GetTextBoxValue("txtPhoneEdit");
            string address = GetTextBoxValue("txtAddressEdit");

            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.BindByName = true;

                    cmd.CommandText = @"UPDATE CUSTOMER
                            SET CUSTOMER_NAME=:name,
                                CONTACT_NUMBER=:phone,
                                EMAIL=:email,
                                ADDRESS=:address
                            WHERE CUSTOMER_ID=:id";

                    cmd.Parameters.Add(":name", OracleDbType.Varchar2).Value = name;
                    cmd.Parameters.Add(":phone", OracleDbType.Varchar2).Value = phone;
                    cmd.Parameters.Add(":email", OracleDbType.Varchar2).Value = email;
                    cmd.Parameters.Add(":address", OracleDbType.Varchar2).Value = address;
                    cmd.Parameters.Add(":id", OracleDbType.Int32).Value = id;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (OracleException ex)
            {
                ShowStatus($"Failed to update customer: {ex.Message}", true);
                return;
            }

            ViewState["EditID"] = null;

            InitializeFormView(FormViewMode.Insert);

            LoadCustomers();

            ShowStatus("Customer updated successfully.", false);
        }

        protected void CancelEdit(object sender, EventArgs e)
        {
            ViewState.Remove("EditID");
            InitializeFormView(FormViewMode.Insert);
            ShowStatus(string.Empty, false);
        }

        private void DeleteCustomer(int customerId)
        {
            try
            {
                using (OracleConnection conn = new OracleConnection(_connectionString))
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.BindByName = true;
                    cmd.CommandText = "DELETE FROM CUSTOMER WHERE CUSTOMER_ID = :id";
                    cmd.Parameters.Add(":id", OracleDbType.Int32).Value = customerId;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                InitializeFormView(FormViewMode.Insert);
                LoadCustomers();
                ShowStatus("Customer deleted successfully.", false);
            }
            catch (OracleException ex) when (ex.Number == 2292)
            {
                ShowStatus("Unable to delete this customer because related records exist.", true);
            }
            catch (OracleException ex)
            {
                ShowStatus($"Failed to delete customer: {ex.Message}", true);
            }
        }

        private void LoadCustomers()
        {
            GridView gridView = ResolveGridView();
            gridView?.DataBind();
        }

        private void InitializeFormView(FormViewMode mode)
        {
            FormView formView = ResolveFormView();
            if (formView == null)
            {
                return;
            }

            if (formView.CurrentMode != mode)
            {
                formView.ChangeMode(mode);
            }

            formView.DataBind();

            if (mode == FormViewMode.Insert)
            {
                ViewState.Remove("EditID");
                ClearFormInputs();
            }
        }

        private void ClearFormInputs()
        {
            SetTextBoxValue("txtName", string.Empty);
            SetTextBoxValue("txtEmail", string.Empty);
            SetTextBoxValue("txtPhone", string.Empty);
            SetTextBoxValue("txtAddress", string.Empty);
            SetTextBoxValue("txtNameEdit", string.Empty);
            SetTextBoxValue("txtEmailEdit", string.Empty);
            SetTextBoxValue("txtPhoneEdit", string.Empty);
            SetTextBoxValue("txtAddressEdit", string.Empty);
        }

        private void SetTextBoxValue(string textBoxId, string value)
        {
            FormView formView = ResolveFormView();
            if (formView?.FindControl(textBoxId) is TextBox textBox)
            {
                textBox.Text = value;
            }
        }

        private string GetTextBoxValue(string textBoxId)
        {
            FormView formView = ResolveFormView();
            if (formView?.FindControl(textBoxId) is TextBox textBox)
            {
                return textBox.Text.Trim();
            }

            return string.Empty;
        }

        private void ShowStatus(string message, bool isError)
        {
            Label statusLabel = ResolveStatusLabel();
            if (statusLabel == null)
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(message))
            {
                statusLabel.Text = string.Empty;
                statusLabel.CssClass = "d-none";
                statusLabel.Visible = false;
                return;
            }

            statusLabel.Text = message;
            statusLabel.CssClass = isError ? "alert alert-danger" : "alert alert-success";
            statusLabel.Visible = true;
        }

        private FormView ResolveFormView()
        {
            return FindControlInMainContent<FormView>("FormView1");
        }

        private GridView ResolveGridView()
        {
            return FindControlInMainContent<GridView>("GridView1");
        }

        private Label ResolveStatusLabel()
        {
            return FindControlInMainContent<Label>("errorAlert");
        }

        private T FindControlInMainContent<T>(string controlId) where T : Control
        {
            ContentPlaceHolder placeholder = Master?.FindControl("MainContent") as ContentPlaceHolder;
            Control searchRoot = placeholder ?? (Control)this;
            return searchRoot.FindControl(controlId) as T;
        }

        private void ToggleValidationSummaries()
        {
            bool validationResultKnown = DidValidationRun();
            bool shouldShowErrors = validationResultKnown && !Page.IsValid;

            FormView formView = ResolveFormView();
            if (formView == null)
            {
                return;
            }

            SetValidationSummaryVisibility("CustomerInsertSummary", shouldShowErrors && formView.CurrentMode == FormViewMode.Insert);
            SetValidationSummaryVisibility("CustomerEditSummary", shouldShowErrors && formView.CurrentMode == FormViewMode.Edit);
        }

        private bool DidValidationRun()
        {
            if (!IsPostBack)
            {
                return false;
            }

            Control sourceControl = FindPostBackControl();
            if (sourceControl is IButtonControl buttonControl)
            {
                return buttonControl.CausesValidation;
            }

            return false;
        }

        private Control FindPostBackControl()
        {
            string target = Request.Params["__EVENTTARGET"];
            if (!string.IsNullOrEmpty(target))
            {
                return FindControlByUniqueId(target);
            }

            foreach (string key in Request.Form)
            {
                Control candidate = FindControlByUniqueId(key);
                if (candidate is IButtonControl)
                {
                    return candidate;
                }
            }

            return null;
        }

        private Control FindControlByUniqueId(string uniqueId)
        {
            if (string.IsNullOrEmpty(uniqueId))
            {
                return null;
            }

            string controlPath = uniqueId.Replace('$', ':');
            return Page.FindControl(controlPath);
        }

        private void SetValidationSummaryVisibility(string summaryId, bool visible)
        {
            ValidationSummary summary = FindControlInMainContent<ValidationSummary>(summaryId);
            if (summary != null)
            {
                summary.Visible = visible;
            }
        }
    }
}
