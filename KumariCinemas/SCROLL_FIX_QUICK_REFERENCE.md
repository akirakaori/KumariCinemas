# Quick Copy-Paste Code Snippets for GridView Scroll Fix

Use these code snippets to quickly apply the scroll fix to your other CRUD pages.

---

## 1. Page Directive Update (.aspx file - Line 1)

**Find the existing Page directive and add `MaintainScrollPositionOnPostBack="true"`**

### For Movie.aspx:
```aspx
<%@ Page Title="Movie Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Movie.aspx.cs" Inherits="KumariCinemas.Movie" MaintainScrollPositionOnPostBack="true" %>
```

### For Theatre.aspx:
```aspx
<%@ Page Title="Theatre Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Theatre.aspx.cs" Inherits="KumariCinemas.Theatre" MaintainScrollPositionOnPostBack="true" %>
```

### For Hall.aspx:
```aspx
<%@ Page Title="Hall Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hall.aspx.cs" Inherits="KumariCinemas.Hall" MaintainScrollPositionOnPostBack="true" %>
```

### For Show.aspx:
```aspx
<%@ Page Title="Show Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Show.aspx.cs" Inherits="KumariCinemas.Show" MaintainScrollPositionOnPostBack="true" %>
```

### For Ticket.aspx:
```aspx
<%@ Page Title="Ticket Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ticket.aspx.cs" Inherits="KumariCinemas.Ticket" MaintainScrollPositionOnPostBack="true" %>
```

---

## 2. GridView Container ID (.aspx file)

**Find your GridView wrapper div and add `id="gridSection"`**

**Before:**
```aspx
<div class="crud-card">
    <div class="crud-card-header">
```

**After:**
```aspx
<div class="crud-card" id="gridSection">
    <div class="crud-card-header">
```

---

## 3. GridView Event Handlers (.aspx file)

**Add these 6 event handler attributes to your GridView control:**

```aspx
OnPageIndexChanging="GridView1_PageIndexChanging"
OnSorting="GridView1_Sorting"
OnRowEditing="GridView1_RowEditing"
OnRowUpdating="GridView1_RowUpdating"
OnRowCancelingEdit="GridView1_RowCancelingEdit"
OnRowDeleting="GridView1_RowDeleting"
```

**Example - Complete GridView tag:**
```aspx
<asp:GridView ID="GridView1" runat="server" 
    AllowPaging="True" 
    AllowSorting="True" 
    AutoGenerateColumns="False" 
    DataKeyNames="MOVIE_ID" 
    DataSourceID="SqlDataSource1"
    CssClass="gridview"
    GridLines="None"
    PagerStyle-CssClass="gridview-pager"
    OnPageIndexChanging="GridView1_PageIndexChanging"
    OnSorting="GridView1_Sorting"
    OnRowEditing="GridView1_RowEditing"
    OnRowUpdating="GridView1_RowUpdating"
    OnRowCancelingEdit="GridView1_RowCancelingEdit"
    OnRowDeleting="GridView1_RowDeleting">
```

---

## 4. Code-Behind Event Handlers (.aspx.cs file)

**Copy this entire region block and paste it after the `Page_Load` method in your code-behind file:**

```csharp
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
```

**Your code-behind file should look like this:**

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KumariCinemas
{
    public partial class Movie : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Your existing Page_Load code
        }

        #region GridView Scroll Position Fix - Event Handlers
        // [PASTE THE ENTIRE REGION BLOCK HERE]
        #endregion
    }
}
```

---

## Checklist for Each Page

Use this checklist when updating each page:

### Movie.aspx
- [ ] Update Page directive with `MaintainScrollPositionOnPostBack="true"`
- [ ] Add `id="gridSection"` to GridView container div
- [ ] Add 6 event handler attributes to GridView
- [ ] Copy event handler code to Movie.aspx.cs
- [ ] Build and test

### Theatre.aspx
- [ ] Update Page directive with `MaintainScrollPositionOnPostBack="true"`
- [ ] Add `id="gridSection"` to GridView container div
- [ ] Add 6 event handler attributes to GridView
- [ ] Copy event handler code to Theatre.aspx.cs
- [ ] Build and test

### Hall.aspx
- [ ] Update Page directive with `MaintainScrollPositionOnPostBack="true"`
- [ ] Add `id="gridSection"` to GridView container div
- [ ] Add 6 event handler attributes to GridView
- [ ] Copy event handler code to Hall.aspx.cs
- [ ] Build and test

### Show.aspx
- [ ] Update Page directive with `MaintainScrollPositionOnPostBack="true"`
- [ ] Add `id="gridSection"` to GridView container div
- [ ] Add 6 event handler attributes to GridView
- [ ] Copy event handler code to Show.aspx.cs
- [ ] Build and test

### Ticket.aspx
- [ ] Update Page directive with `MaintainScrollPositionOnPostBack="true"`
- [ ] Add `id="gridSection"` to GridView container div
- [ ] Add 6 event handler attributes to GridView
- [ ] Copy event handler code to Ticket.aspx.cs
- [ ] Build and test

---

## Quick Testing Script

After updating each page, run this quick test:

1. **Navigate to the page** (e.g., Movie.aspx)
2. **Scroll down** to the GridView
3. **Click page 2** → Should scroll to GridView ✓
4. **Click a column header to sort** → Should scroll to GridView ✓
5. **Click Edit on a row** → Should scroll to GridView ✓
6. **Click Update** → Should scroll to GridView ✓
7. **Click Cancel** → Should scroll to GridView ✓
8. **Click Delete** → Should scroll to GridView ✓

---

## Common Issues & Solutions

### Issue: Build errors after adding event handlers
**Solution:** Make sure you've added the event handler code to the .aspx.cs file

### Issue: Page still scrolls to top
**Solution:** 
1. Verify `id="gridSection"` is on the correct div
2. Check that all 6 event handlers are added to GridView
3. Verify the code-behind has all event handler methods

### Issue: JavaScript console error "Cannot read property 'scrollIntoView'"
**Solution:** The element with `id="gridSection"` doesn't exist. Double-check the ID in the .aspx file.

---

## Time Estimate

**Per page:** 3-5 minutes
- 1 minute: Update Page directive
- 1 minute: Add container ID and GridView event handlers  
- 2 minutes: Copy-paste code-behind event handlers
- 1 minute: Build and quick test

**Total for all 5 remaining pages:** 15-25 minutes

---

**Tip:** Update one page at a time, build and test before moving to the next page. This way you can catch any issues early.
