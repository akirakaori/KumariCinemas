# Analytics Dashboard Layout

## Home.aspx Dashboard Structure

```
┌─────────────────────────────────────────────────────────────────────┐
│                        HOME DASHBOARD                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  WELCOME BANNER / HERO SECTION                                      │
│  "Welcome back" with description and action buttons                  │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  │  CUSTOMERS  │  │   MOVIES    │  │  THEATRES   │  │  TICKETS    │
│  │      250    │  │      45     │  │      12     │  │    1,850    │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘
│                        SUMMARY CARDS                                 │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                       ANALYTICS & INSIGHTS                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────┐  ┌──────────────────────────────┐
│  │  Movie Popularity (Bar)      │  │  Genre Distribution (Pie)    │
│  │  [Interstellar: 150]         │  │  [Action: 25%]               │
│  │  [Avatar: 120]               │  │  [Drama: 20%]                │
│  │  [The Matrix: 95]            │  │  [Comedy: 15%]               │
│  │  [Inception: 80]             │  │  [Horror: 12%]               │
│  └──────────────────────────────┘  └──────────────────────────────┘
│  50% width (col-lg-6)             50% width (col-lg-6)            │
│                                                                      │
│  ┌─────────────────────────────────────┐  ┌──────────────────────┐
│  │  Daily Ticket Bookings (Line)       │  │  Ticket Status       │
│  │  [Chart showing 30-day trend]       │  │  (Doughnut)          │
│  │  Peak: 250 bookings on Day 15       │  │  [Booked: 85%]       │
│  │  Trend: Steady growth               │  │  [Cancelled: 10%]    │
│  │                                      │  │  [Pending: 5%]       │
│  └─────────────────────────────────────┘  └──────────────────────┘
│  67% width (col-lg-8)                    33% width (col-lg-4)     │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────┐  ┌─────────────────────────────────┐
│  │  Recent Activity         │  │  Quick Report Links             │
│  │  [Database driven list]  │  │  [Customer Ticket Report]       │
│  │  [Last 5 bookings]       │  │  [Theatre Movie Report]         │
│  └──────────────────────────┘  └─────────────────────────────────┘
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Page Load (IsPostBack=false)                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                      │
   ┌────▼──────────────┐              ┌──────▼──────────────┐
   │  LoadDashboard    │              │   LoadChartData      │
   │  Stats()          │              │                      │
   └────┬──────────────┘              └──────┬──────────────┘
        │                                     │
        ├─LoadCustomerCount()            ┌────┼─────────────────────┐
        ├─LoadMovieCount()               │    │                     │
        ├─LoadTheatreCount()             │    │                     │
        └─LoadTicketCount()          ┌───▼─┴──▼───┬───────────┬────┴───┐
                                     │             │           │        │
                            ┌────────▼─┐  ┌────────▼─┐ ┌──────▼──┐ ┌───▼──────┐
                            │ Get Movie │  │ Get Genre│ │ Get Daily│ │Get Ticket│
                            │ Popularity│  │Distrib. │ │ Bookings │ │ Status   │
                            └────┬──────┘  └────┬────┘ └────┬─────┘ └────┬─────┘
                                 │              │          │           │
                            ┌────▼──────────────▼──────────▼───────────▼──┐
                            │      Oracle Database Queries                 │
                            │  (MOVIE, TICKET, SHOW_TICKET, HALL_SHOW)   │
                            └────┬────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │   Convert to JSON       │
                    │   via ConvertToChartJson│
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │  Register Startup       │
                    │  Script (JavaScript     │
                    │  Variables)             │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │  Page Rendered in       │
                    │  Browser               │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │  DOM Ready Event        │
                    │  Fires                  │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼──────────────┐
                    │  initializeCharts()       │
                    │  Called                   │
                    └────────────┬──────────────┘
                                 │
        ┌────────────────┬────────┴──────────┬──────────────┐
        │                │                   │              │
   ┌────▼─────┐  ┌──────▼────┐  ┌───────────▼──┐  ┌────────▼────┐
   │ Movie Pop│  │  Genre    │  │  Daily       │  │  Ticket     │
   │ Bar Chart│  │  Pie Chart│  │  Line Chart  │  │  Doughnut   │
   └──────────┘  └───────────┘  └──────────────┘  └─────────────┘
        │               │              │              │
        └───────────────┴──────────────┴──────────────┘
                       │
                    ┌──▼───┐
                    │ Ready │
                    │ View  │
                    └───────┘
```

## Chart Types Used

```
1. MOVIE POPULARITY - Bar Chart (Horizontal)
   ═══════════════════════════════════════════
   Movie A   ████████████████ 150
   Movie B   ███████████ 120
   Movie C   ████████ 95
   Movie D   ███████ 80
   
   Type: Bar (horizontal orientation)
   Data Source: MOVIE + HALL_SHOW + SHOW_TICKET
   Aggregation: COUNT tickets per movie
   Order: Descending by ticket count

2. GENRE DISTRIBUTION - Pie Chart
   ═════════════════════════════════════
        ┌──────┐
      ╱ │Action├─ 25%
    ╱   └──────┘
   │    ┌──────┐
   │    │Drama├─ 20%
   │    └──────┘
    \    ┌──────┐
     \   │Comedy├─ 15%
      \  └──────┘
        ┌──────┐
        │Horror├─ 12%
        └──────┘
        
   Type: Pie
   Data Source: MOVIE
   Aggregation: COUNT movies per genre
   Order: Descending by count

3. DAILY BOOKINGS - Line Chart (30 days)
   ═════════════════════════════════════════
   250 │         ╱──╲
   200 │        ╱    ╲    ╱─╲
   150 │   ╱──╲╱      ╲──╱   ╲────
   100 │  ╱              
    50 │ ╱                     
     0 └─────────────────────────
       Day 1    Day 15   Day 30
       
   Type: Line (with fill)
   Data Source: TICKET
   Aggregation: COUNT bookings per day
   Filter: Last 30 days (SYSDATE - 30)
   Order: Ascending by date

4. TICKET STATUS - Doughnut Chart
   ═════════════════════════════════════
        ┌──────────┐
      ╱            ╲
    ╱  Booked 85%   ╲
   │                 │
   │  ◯             │
   │                 │
    ╲ Cancelled 10% ╱
     ╲  Pending 5% ╱
        └──────────┘
        
   Type: Doughnut
   Data Source: TICKET
   Aggregation: COUNT tickets per status
   Order: Descending by count
```

## Responsive Grid Layout

```
Desktop (lg screens) - 1200px+
┌─────────────────────────────────────────┐
│      Movie Popularity (50%)  Genre (50%) │
├─────────────────────────────────────────┤
│      Daily Bookings (67%)    Status (33%)│
└─────────────────────────────────────────┘

Tablet (md screens) - 768px+
┌──────────────────────┐
│ Movie Popularity(50%)│
│ Genre Dist.(50%)     │
├──────────────────────┤
│ Daily Bookings(100%) │
│ Status (100%)        │
└──────────────────────┘

Mobile (sm screens) - <768px
┌──────────────┐
│Movie Popularity
├──────────────┤
│Genre Dist.   │
├──────────────┤
│Daily Bookings│
├──────────────┤
│Status        │
└──────────────┘
```

## Color Palette

```
Primary Emerald    #10B981  ████
Light Emerald      #D1F4E0  ████
Red                #EF4444  ████
Yellow             #F59E0B  ████
Blue               #3B82F6  ████
Purple             #A855F7  ████
Pink               #EC4899  ████
Orange             #F97316  ████
Teal               #06B6D4  ████
Indigo             #4F46E5  ████
```

## Browser Console Log Output (When Working)

```javascript
// After page load, these variables are available:
moviePopularityData = {
  "labels": ["Interstellar", "Avatar", "The Matrix"],
  "data": [150, 120, 95]
}

genreDistributionData = {
  "labels": ["Action", "Drama", "Comedy"],
  "data": [25, 20, 15]
}

dailyBookingsData = {
  "labels": ["2024-01-01", "2024-01-02", ...],
  "data": [45, 52, 48, ...]
}

ticketStatusData = {
  "labels": ["Booked", "Cancelled", "Pending"],
  "data": [1570, 185, 95]
}

// Charts initialized and rendered on page
```
