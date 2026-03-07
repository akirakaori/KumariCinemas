# 🎬 Kumari Cinemas - Quick Start Guide

## ⚡ Quick Reference

### 📁 New Files Created
1. **Site.Master** - Global layout (header, nav, footer)
2. **Home.aspx** - Dashboard with live stats
3. **Content/Site.css** - Emerald green theme
4. **Customer_MasterPageExample.aspx** - Conversion example
5. **LAYOUT_GUIDE.md** - Full documentation
6. **README_LAYOUT.md** - Summary guide

### 🎨 Theme Color
**Emerald Green:** `#10b981`

### 🚀 Run Your Project
1. Press **F5** in Visual Studio
2. Home.aspx opens as dashboard
3. Navigate using top menu
4. All pages accessible

### 🔧 Convert a Page to Master Page

**Before:**
```aspx
<%@ Page Language="C#" ... %>
<html>
<body>
    <form runat="server">
        <!-- content -->
    </form>
</body>
</html>
```

**After:**
```aspx
<%@ Page Title="Page Title" MasterPageFile="~/Site.Master" ... %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        <div class="card shadow-sm rounded border-0">
            <div class="card-body">
                <!-- content -->
            </div>
        </div>
    </div>
</asp:Content>
```

### 📊 Dashboard Features
✅ Live customer count
✅ Live movie count
✅ Live theatre count
✅ Live ticket count
✅ Recent activity feed
✅ Quick report links
✅ Welcome banner

### 🗺️ Navigation
- Home
- Customer
- Movie
- Theatre
- Hall
- Show
- Ticket
- Reports (dropdown)
  - Customer Ticket
  - Theatre Movie
  - Top Theatre Occupancy

### 🎯 Common Bootstrap Classes
```html
<!-- Container -->
<div class="container-fluid px-4 py-4">

<!-- Card -->
<div class="card shadow-sm rounded border-0">
    <div class="card-header bg-white border-0 py-3">
        <h5>Title</h5>
    </div>
    <div class="card-body">
        Content
    </div>
</div>

<!-- Button -->
<button class="btn btn-emerald">Click Me</button>

<!-- Grid -->
<div class="row g-4">
    <div class="col-md-6">Column 1</div>
    <div class="col-md-6">Column 2</div>
</div>
```

### 🎨 Custom CSS Classes
- `.btn-emerald` - Emerald green button
- `.btn-outline-emerald` - Outline button
- `.text-emerald` - Emerald text color
- `.bg-emerald` - Emerald background
- `.stat-card` - Dashboard stat card
- `.report-link-card` - Report link style

### 📝 Example: Customer Page Conversion
See: `Customer_MasterPageExample.aspx`

### 🔍 Troubleshooting

**Problem:** Dashboard cards show "0"
**Solution:** Ensure Oracle database tables exist (CUSTOMER, MOVIE, THEATRE, TICKET)

**Problem:** Navigation not working
**Solution:** Check page file names match links in Site.Master

**Problem:** Styles not showing
**Solution:** Ensure Content/Site.css exists and is referenced in Site.Master

### 📚 Documentation
- **Full Guide:** LAYOUT_GUIDE.md
- **Summary:** README_LAYOUT.md
- **This Guide:** QUICK_START.md

### ✅ Status
- ✅ Build successful
- ✅ Master page created
- ✅ Dashboard implemented
- ✅ Theme applied
- ✅ Navigation working
- ✅ Database connected

### 🎓 Perfect for Academic Projects!

---

**Need Help?** Check LAYOUT_GUIDE.md for detailed instructions.
