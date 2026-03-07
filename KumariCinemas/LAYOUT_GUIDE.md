# Kumari Cinemas - Global Layout Implementation Guide

## Overview
A professional emerald green-themed layout system has been created for your Kumari Cinemas Ticket Booking Management System.

## Files Created

### 1. Site.Master
- **Location:** `KumariCinemas\Site.Master`
- **Purpose:** Master page containing shared header, navigation bar, and footer
- **Features:**
  - Professional header with logo and admin info
  - Emerald green navigation bar with dropdown for Reports
  - Footer with copyright and links
  - Bootstrap 5 responsive layout
  - Font Awesome icons

### 2. Site.Master.cs & Site.Master.designer.cs
- **Location:** `KumariCinemas\Site.Master.cs` and `KumariCinemas\Site.Master.designer.cs`
- **Purpose:** Code-behind files for the master page

### 3. Home.aspx
- **Location:** `KumariCinemas\Home.aspx`
- **Purpose:** Dashboard homepage using the master page
- **Features:**
  - Welcome banner with system description
  - 4 dashboard summary cards (Customers, Movies, Theatres, Tickets)
  - Recent System Activity panel
  - Quick Report Links panel
  - All data connected to Oracle database

### 4. Home.aspx.cs & Home.aspx.designer.cs
- **Location:** `KumariCinemas\Home.aspx.cs` and `KumariCinemas\Home.aspx.designer.cs`
- **Purpose:** Code-behind for dashboard with database queries

### 5. Content\Site.css
- **Location:** `KumariCinemas\Content\Site.css`
- **Purpose:** Custom CSS with emerald green theme
- **Features:**
  - Emerald green color scheme (#10b981)
  - Modern card designs
  - Hover effects and animations
  - Responsive design
  - Professional shadows and spacing

## Navigation Structure

The navigation bar includes links to all pages:

1. **Home** → Home.aspx
2. **Customer** → Customer.aspx
3. **Movie** → Movie.aspx
4. **Theatre** → Theatre.aspx
5. **Hall** → Hall.aspx
6. **Show** → Show.aspx
7. **Ticket** → Ticket.aspx
8. **Reports** (Dropdown)
   - Customer Ticket Report → CustomerTicket.aspx
   - Theatre Movie Report → TheatreMovie.aspx
   - Top Theatre Occupancy Report → TopTheatreOccupancy.aspx

## How to Apply Master Page to Existing Pages

To convert your existing pages (Customer.aspx, Movie.aspx, etc.) to use the master page:

### BEFORE (Current Structure):
```aspx
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Management</title>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Your page content here -->
    </form>
</body>
</html>
```

### AFTER (Using Master Page):
```aspx
<%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Any page-specific CSS or scripts -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-4 py-4">
        <div class="card shadow-sm rounded border-0">
            <div class="card-header bg-white border-0 py-3">
                <h4 class="card-title mb-0">Customer Management</h4>
                <p class="card-subtitle text-muted small mb-0 mt-1">Manage customer information and details</p>
            </div>
            <div class="card-body">
                <!-- Your existing GridView, FormView, and SqlDataSource controls -->
            </div>
        </div>
    </div>
</asp:Content>
```

### Key Changes:
1. Replace `<%@ Page ...%>` directive with master page reference
2. Remove `<html>`, `<head>`, `<body>`, and `<form>` tags
3. Wrap content in `<asp:Content>` tags
4. Use Bootstrap classes for styling

## Example: Converting Customer.aspx

Here's exactly how to convert Customer.aspx:

1. Change the first line from:
   ```aspx
   <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>
   ```
   To:
   ```aspx
   <%@ Page Title="Customer Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="KumariCinemas.Customer" %>
   ```

2. Remove everything BEFORE your SqlDataSource and controls

3. Add content placeholders:
   ```aspx
   <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
       <div class="container-fluid px-4 py-4">
           <!-- Your existing content -->
       </div>
   </asp:Content>
   ```

4. Remove `</form>`, `</body>`, `</html>` at the end

5. Close with `</asp:Content>`

## Color Theme

The emerald green theme uses these primary colors:

- **Primary Emerald:** #10b981
- **Dark Emerald:** #059669
- **Light Emerald:** #d1fae5
- **Lighter Emerald:** #ecfdf5

These are applied to:
- Navigation bar background
- Active navigation links
- Buttons and call-to-action elements
- Card borders and accents
- Icon backgrounds
- Hover effects

## Bootstrap Classes Used

Common Bootstrap 5 classes you can use:

### Layout:
- `container-fluid` - Full width container
- `row` - Grid row
- `col-md-6`, `col-lg-4` - Responsive columns
- `g-4` - Gap between grid items

### Cards:
- `card` - Card container
- `card-header`, `card-body`, `card-footer` - Card sections
- `shadow-sm` - Subtle shadow
- `rounded` - Rounded corners
- `border-0` - Remove border

### Spacing:
- `px-4` - Horizontal padding
- `py-3` - Vertical padding
- `mb-4` - Margin bottom
- `mt-3` - Margin top

### Text:
- `text-muted` - Gray text
- `text-center` - Center align
- `text-end` - Right align

## Database Integration

The Home.aspx dashboard automatically queries these counts from your Oracle database:

1. **Total Customers** - `SELECT COUNT(*) FROM CUSTOMER`
2. **Total Movies** - `SELECT COUNT(*) FROM MOVIE`
3. **Total Theatres** - `SELECT COUNT(*) FROM THEATRE`
4. **Total Tickets** - `SELECT COUNT(*) FROM TICKET`

Make sure these tables exist in your database for the dashboard to work properly.

## Testing the Layout

1. Run your project in Visual Studio
2. The default page is now Home.aspx
3. Navigate through the menu to test all links
4. Verify the emerald green theme is applied
5. Check responsiveness by resizing the browser

## Customization Tips

### To Change Colors:
Edit `Content\Site.css` and modify the `:root` color variables:
```css
:root {
    --emerald-primary: #10b981;  /* Change this */
    --emerald-dark: #059669;      /* And this */
}
```

### To Add More Navigation Items:
Edit `Site.Master` and add to the `<ul class="navbar-nav">` section:
```html
<li class="nav-item">
    <a class="nav-link" href="YourPage.aspx">
        <i class="fas fa-icon me-1"></i> Your Link
    </a>
</li>
```

### To Customize the Dashboard:
Edit `Home.aspx` and modify the cards, activity items, or report links.

## File Structure

```
KumariCinemas/
├── Site.Master                 (Master page layout)
├── Site.Master.cs              (Master page code-behind)
├── Site.Master.designer.cs     (Auto-generated)
├── Home.aspx                   (Dashboard homepage)
├── Home.aspx.cs                (Dashboard code-behind)
├── Home.aspx.designer.cs       (Auto-generated)
├── Content/
│   └── Site.css                (Custom emerald theme CSS)
├── Customer.aspx               (Convert to use master page)
├── Movie.aspx                  (Convert to use master page)
├── Theatre.aspx                (Convert to use master page)
└── ... (other pages)
```

## Next Steps

1. Convert all existing pages to use Site.Master
2. Test navigation between all pages
3. Verify database connections work
4. Customize colors if needed
5. Add any page-specific styling in individual pages

## Support

For Font Awesome icons, visit: https://fontawesome.com/icons
For Bootstrap documentation, visit: https://getbootstrap.com/docs/5.3/

---
© 2026 Kumari Cinemas. All rights reserved.
