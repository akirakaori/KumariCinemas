# GridView Header White Text Fix

## Problem
GridView table headers had emerald/bottle green background, but column titles appeared in **black text** instead of white, making them hard to read. Only the "Action" column header appeared white.

## Root Cause
ASP.NET GridView with `AllowSorting="True"` renders header cells (`<th>`) containing **`<a>` link elements** for sortable columns. The CSS rule:

```css
table.gridview a {
    color: var(--emerald-primary);  /* This was making header links emerald/dark, not white! */
}
```

This rule was applying to ALL links in the GridView, including header links, overriding the white text color.

## Solution Applied
Updated `KumariCinemas\Content\Site.css` to add **specific selectors** for header links vs. data cell links:

### Changes Made (Lines 568-617)

```css
/* Header cells - white text on emerald background */
table.gridview th {
    background: linear-gradient(135deg, var(--emerald-primary), var(--emerald-dark));
    color: #FFFFFF !important;
    font-weight: 700 !important;
    text-align: left;
    padding: 1rem;
    text-transform: uppercase;
    font-size: 0.85rem;
    letter-spacing: 0.5px;
    border: none;
}

/* GridView Header Links (for sortable columns) - WHITE TEXT */
table.gridview th a {
    color: #FFFFFF !important;
    text-decoration: none;
    font-weight: 700 !important;
}

table.gridview th a:hover {
    color: #FFFFFF !important;
    text-decoration: underline;
}

/* GridView Links in Data Cells (Edit/Delete buttons) - EMERALD TEXT */
table.gridview td a {
    color: var(--emerald-primary);
    text-decoration: none;
    font-weight: 500;
    margin-right: 0.75rem;
}

table.gridview td a:hover {
    color: var(--emerald-dark);
    text-decoration: underline;
}
```

## Key Changes

1. **Separated link styling** by location:
   - `table.gridview th a` → White text for header links (sortable columns)
   - `table.gridview td a` → Emerald text for data cell links (Edit/Delete buttons)

2. **Added `!important` flags** to ensure Bootstrap or ASP.NET inline styles don't override

3. **Applied to ALL header cells**, whether they contain:
   - Plain text (non-sortable columns like "Actions")
   - Links (sortable columns like "Customer Name", "Email", etc.)

## Result

✅ **ALL GridView header titles now appear in white (#FFFFFF)**
✅ Emerald/bottle green background color maintained
✅ Header text is bold (font-weight: 700)
✅ Edit/Delete links in data rows remain emerald colored
✅ Works with ASP.NET GridView sorting functionality
✅ Compatible with Bootstrap tables

## Pages Affected

This fix automatically applies to all GridView tables using `CssClass="gridview"`:

- Customer.aspx
- Movie.aspx
- Theatre.aspx
- Hall.aspx
- Show.aspx
- Ticket.aspx
- TopTheatreOccupancy.aspx
- CustomerTicket.aspx
- TheatreMovie.aspx

## Technical Details

### ASP.NET GridView Rendering with Sorting

When `AllowSorting="True"`:
```html
<table class="gridview">
  <thead>
    <tr>
      <th><a href="...">Customer Name</a></th>  <!-- Was emerald, now WHITE -->
      <th><a href="...">Email</a></th>           <!-- Was emerald, now WHITE -->
      <th>Actions</th>                           <!-- Was already white -->
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>John Doe</td>
      <td>john@email.com</td>
      <td><a href="...">Edit</a> <a href="...">Delete</a></td>  <!-- Stays emerald -->
    </tr>
  </tbody>
</table>
```

### CSS Specificity
- `table.gridview th a` has higher specificity than `table.gridview a`
- This ensures header links get white color, data links get emerald color

## Testing Checklist

✅ Open any page with GridView (e.g., Customer.aspx)
✅ Verify ALL column headers show white text
✅ Verify sortable column headers (with links) are white
✅ Verify non-sortable headers (like "Actions") are white
✅ Verify Edit/Delete links in data rows are still emerald colored
✅ Hover over sortable headers to see underline effect
✅ Test on all CRUD pages

## Status
**✅ COMPLETE** - All GridView header titles now display in white with proper contrast on emerald background.

---
**Date Fixed:** Today
**Modified File:** `KumariCinemas\Content\Site.css` (lines 568-617)
