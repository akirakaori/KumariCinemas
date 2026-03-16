# Analytics Charts Testing Guide

## Pre-Testing Checklist

- [ ] Solution builds successfully (✅ Confirmed)
- [ ] Oracle database connection is working
- [ ] Tables have data: MOVIE, TICKET, SHOW_TICKET, HALL_SHOW
- [ ] Web.config has correct OracleConnection string
- [ ] Chart.js library loads from CDN (internet connection needed)

## Testing Steps

### Step 1: Launch Application
1. Open Visual Studio
2. Build solution (Ctrl+Shift+B)
3. Run application (F5 or Ctrl+F5)
4. Navigate to Home.aspx

**Expected Result**: Page loads, summary cards show values

### Step 2: Verify Chart Data is Loading
1. Open Browser DevTools (F12)
2. Go to Console tab
3. Check for JavaScript errors
4. Type in console: `console.log(moviePopularityData)`
5. Should output JSON with labels and data arrays

```javascript
// Expected output:
{labels: Array(3), data: Array(3)}
```

**Expected Result**: Variables defined with data arrays populated

### Step 3: Verify Charts Render
1. Scroll down to Analytics section
2. Look for 4 chart cards below summary cards
3. Each chart should display:
   - Chart title with icon
   - Subtitle
   - Rendered chart visualization

**Expected Result**: 4 Charts visible with data

### Step 4: Test Bar Chart (Movie Popularity)
- **Location**: Top-left analytics card
- **Behavior**: 
  - Hover over bars → shows movie name and ticket count
  - Bars ordered by highest tickets first
  - Y-axis shows numeric values
- **Data Source**: MOVIE title vs ticket count

**Test Data Example**:
- If movies exist: Interstellar (150), Avatar (120), The Matrix (95)

### Step 5: Test Pie Chart (Genre Distribution)
- **Location**: Top-right analytics card
- **Behavior**:
  - Click on legend items to toggle visibility
  - Hover over slices → shows percentage and count
  - Different colors for each genre
- **Data Source**: Unique genres from MOVIE table

**Test Data Example**:
- If genres exist: Action (25%), Drama (20%), Comedy (15%)

### Step 6: Test Line Chart (Daily Bookings)
- **Location**: Bottom-left analytics card (wider)
- **Behavior**:
  - Shows trend over 30 days
  - X-axis = dates (YYYY-MM-DD format)
  - Y-axis = number of bookings
  - Line fills area below with light color
  - Hover over points → shows exact date and count
- **Data Source**: Daily count from TICKET table (last 30 days)

**Test Data Example**:
- Shows dates from 30 days ago to today
- If no recent bookings: may show empty or flat line

### Step 7: Test Doughnut Chart (Ticket Status)
- **Location**: Bottom-right analytics card
- **Behavior**:
  - Shows ticket distribution by status
  - Hover over sections → shows status and count
  - Legend at bottom shows all statuses
  - Doughnut hole in center
- **Data Source**: COUNT of each status in TICKET table

**Test Data Example**:
- Booked (85%), Cancelled (10%), Pending (5%)

### Step 8: Test Responsiveness
1. Open DevTools (F12)
2. Click Device Emulation icon (or Ctrl+Shift+M)
3. Test different viewport sizes:
   - **Desktop (1200px+)**: 2-column layout for charts
   - **Tablet (768px)**: 1 column, responsive stacking
   - **Mobile (375px)**: Full width single column

**Expected Result**: Charts scale and stack appropriately

### Step 9: Test Page Refresh
1. Press F5 to refresh page
2. Charts should disappear briefly (loading)
3. Data reloads and charts reappear
4. All values should remain consistent

**Expected Result**: Data persists, no errors on refresh

### Step 10: Test Error Conditions

#### No Data Scenario
If any query returns no results:
1. Chart won't initialize (checked in JS)
2. No console errors
3. Other charts still load normally

**How to trigger**: Delete data from one table and refresh

#### Database Connection Error
If Oracle is unavailable:
1. C# catch blocks handle errors
2. Debug output shows error message
3. JavaScript variables undefined
4. Charts don't initialize

**How to trigger**: Stop Oracle service and refresh

## Browser Compatibility Testing

Test in these browsers:
- [x] Chrome (Latest)
- [x] Firefox (Latest)
- [x] Safari (Latest)
- [x] Edge (Latest)

## Performance Testing

### Page Load Time
- Open Network tab in DevTools
- Measure time to interactive (TTI)
- Chart.js CDN load: ~100-200ms
- SQL queries: ~500ms-2s (depends on data size)

**Expected**: Page interactive within 3-4 seconds

### Chart Rendering Time
- After data loads, charts appear almost instantly
- Observable transition: ~500ms

### Memory Usage
- 4 Chart.js instances
- Estimated: ~5-10MB additional memory

## Data Validation Testing

### Verify Correct SQL Queries

Run these directly in SQL Developer:

```sql
-- Movie Popularity
SELECT M.TITLE, COUNT(ST.TICKET_ID) AS TOTAL
FROM MOVIE M
JOIN HALL_SHOW HS ON M.MOVIE_ID = HS.MOVIE_ID
JOIN SHOW_TICKET ST ON HS.SHOW_ID = ST.SHOW_ID
GROUP BY M.TITLE
ORDER BY TOTAL DESC;

-- Genre Distribution
SELECT GENRE, COUNT(*) AS TOTAL
FROM MOVIE
GROUP BY GENRE;

-- Daily Bookings
SELECT TRUNC(BOOKING_DATE) AS BOOKING_DATE, COUNT(*) AS TOTAL
FROM TICKET
WHERE BOOKING_DATE >= SYSDATE - 30
GROUP BY TRUNC(BOOKING_DATE)
ORDER BY BOOKING_DATE ASC;

-- Ticket Status
SELECT STATUS, COUNT(*) AS TOTAL
FROM TICKET
GROUP BY STATUS;
```

Compare manual results with charts displayed.

## Console Output Inspection

Open Browser DevTools Console and verify:

```javascript
// Should be defined after page load
typeof moviePopularityData === 'object'    // true
typeof genreDistributionData === 'object'  // true
typeof dailyBookingsData === 'object'      // true
typeof ticketStatusData === 'object'       // true

// Arrays should have matching lengths
moviePopularityData.labels.length === moviePopularityData.data.length
genreDistributionData.labels.length === genreDistributionData.data.length
// etc.

// No undefined variables or NaN values
```

## Debugging Tips

### If Charts Don't Appear

1. **Check JavaScript Console** (F12 → Console):
   - Look for errors
   - Check if variables are defined
   - Verify Chart.js library loaded

2. **Check Network Tab** (F12 → Network):
   - Verify chart.js CDN loaded (4.4.0)
   - Check for failed requests
   - Look for 404 errors

3. **Check Debug Output** (Visual Studio Output window):
   - Look for SQL query errors
   - Check connection string issues
   - Review exception messages

4. **Verify Database Data**:
   - Run SQL queries directly
   - Ensure TICKET, MOVIE tables have records
   - Check foreign key relationships

### Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Charts blank | No data in DB | Insert test data into tables |
| Charts undefined | Chart.js not loaded | Check CDN connection, F12→Network |
| JavaScript error | JSON syntax issue | Check Debug Output for query errors |
| Labels missing | NULL values in DB | Update table data, remove NULLs |
| Showing 0 records | WHERE clause too strict | Check date range filters |
| Charts not responsive | CSS issue | Check Bootstrap grid classes |

## Test Report Template

```
===== ANALYTICS CHARTS TEST REPORT =====

Date: _______________
Tester: ______________
Browser: ____________
OS: ________________

FUNCTIONALITY TESTS
[  ] Movie Popularity Chart displays
[  ] Genre Distribution Chart displays
[  ] Daily Bookings Chart displays
[  ] Ticket Status Chart displays
[  ] Hover tooltips work
[  ] Legend interactions work
[  ] All values are correct

RESPONSIVENESS TESTS
[  ] Desktop layout (1200px+) correct
[  ] Tablet layout (768px) correct
[  ] Mobile layout (375px) correct
[  ] Charts scale proportionally

PERFORMANCE TESTS
[  ] Page loads within 4 seconds
[  ] Charts render smoothly
[  ] No memory leaks
[  ] No console errors

DATA VALIDATION TESTS
[  ] SQL queries return expected results
[  ] JSON conversion is correct
[  ] Numbers match manual count
[  ] Dates are properly formatted

BROWSER COMPATIBILITY
[  ] Chrome - PASS/FAIL
[  ] Firefox - PASS/FAIL
[  ] Safari - PASS/FAIL
[  ] Edge - PASS/FAIL

ISSUES FOUND:
(List any bugs or issues)

OVERALL STATUS: _________ (PASS/FAIL)

Comments:
_________________________
_________________________
```

## Success Criteria

✅ **All Charts Render**: 4 different chart types visible
✅ **Data is Accurate**: Values match database counts
✅ **No Errors**: Browser console clean, no exceptions
✅ **Responsive**: Works on desktop, tablet, mobile
✅ **Performance**: Page loads quickly, charts render smoothly
✅ **Interactive**: Hover, click, zoom features work
✅ **Error Handling**: Graceful fallback if data unavailable

## Sign-Off

When all tests pass:
1. Run final build: Ctrl+Shift+B ✅
2. Test one more time on fresh browser session
3. Check for any warnings in Output window
4. Document any customizations made
5. Ready for deployment

---

**Testing Date**: _______________
**Tested By**: _______________
**Approved By**: _______________
