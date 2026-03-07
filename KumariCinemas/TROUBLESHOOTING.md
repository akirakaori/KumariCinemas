# Common Issues and Solutions

## Issue: Parser Error - ContentPlaceHolderID Required

### Error Message:
```
Parser Error Message: The required attribute 'ContentPlaceHolderID' is not found on 'Content' control.
```

### Cause:
Incorrect syntax for the `<asp:Content>` control.

### ❌ WRONG:
```aspx
<asp:Content ID="Content1" ContentPlaceHolder ID="head" runat="server">
```

### ✅ CORRECT:
```aspx
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
```

### Key Difference:
- Use `ContentPlaceHolderID` (single attribute)
- NOT `ContentPlaceHolder ID` (two separate attributes)

---

## Issue: Dashboard Shows "0" for All Counts

### Possible Causes:
1. Database tables don't exist
2. Connection string is incorrect
3. Oracle service not running

### Solution:
1. Verify tables exist: `CUSTOMER`, `MOVIE`, `THEATRE`, `TICKET`
2. Check Web.config connection string
3. Ensure Oracle database is running

---

## Issue: CSS Not Loading

### Possible Causes:
1. `Content/Site.css` file missing
2. Path incorrect in Site.Master

### Solution:
1. Verify file exists at: `KumariCinemas/Content/Site.css`
2. Check Site.Master has: `<link href="~/Content/Site.css" rel="stylesheet" />`

---

## Issue: Navigation Links Not Working

### Possible Causes:
1. Page files don't exist
2. Incorrect file names in Site.Master

### Solution:
1. Verify all page files exist
2. Check exact file names match navigation links
3. Case-sensitive on some servers

---

## Issue: Master Page Not Applied

### Possible Causes:
1. Missing `MasterPageFile` attribute
2. Incorrect path to master page

### Solution:
Ensure page directive has:
```aspx
<%@ Page MasterPageFile="~/Site.Master" ... %>
```

---

## Quick Reference: Correct Content Syntax

```aspx
<%@ Page Title="Your Title" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="YourPage.aspx.cs" 
    Inherits="KumariCinemas.YourPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Optional: Page-specific CSS/JS -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Your page content -->
</asp:Content>
```

---

## Build Errors

### If you get compilation errors:
1. Clean Solution (Build → Clean Solution)
2. Rebuild Solution (Build → Rebuild Solution)
3. Check Error List window for details

### If changes don't appear:
1. Hard refresh browser (Ctrl + F5)
2. Clear browser cache
3. Restart IIS Express

---

## Still Having Issues?

1. Check all files exist
2. Verify Oracle connection
3. Review Error List in Visual Studio
4. Check Output window for details
5. Ensure .NET Framework 4.7.2 is installed

---

**Remember:** Always use `ContentPlaceHolderID` (one word) not `ContentPlaceHolder ID` (two words)!
