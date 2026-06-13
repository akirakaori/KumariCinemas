# Kumari Cinemas

Kumari Cinemas is an ASP.NET Web Forms based ticket booking and cinema management portal designed to streamline day-to-day operations for a movie theatre business. The application provides an admin-focused dashboard for managing customers, movies, theatres, showtimes, tickets, and operational reports backed by an Oracle database.

---

## Overview

This project demonstrates a traditional enterprise web application built on the Microsoft stack with server-side Web Forms, reusable master pages, Oracle data access, and a responsive Bootstrap-based interface. It combines operational management screens with reporting views to support decision-making around bookings, occupancy, and ticket performance.

---

## Key Features

* Dashboard with live summary cards for customers, movies, theatres, and tickets.
* Analytics views for movie popularity, genre distribution, daily bookings, and ticket status.
* Customer management and customer ticket reporting.
* Movie, theatre, hall, show, showtime, and ticket management modules.
* Theatre-movie and top theatre occupancy reports.
* Oracle database integration using ODP.NET Managed Driver.
* Shared master layout for consistent navigation and administration workflows.
* Responsive UI built with Bootstrap 5 and Font Awesome icons.

---

## Tech Stack

* ASP.NET Web Forms
* C#
* .NET Framework 4.7.2
* Oracle Database
* Oracle Managed Data Access (ODP.NET)
* Bootstrap 5
* Chart.js
* Font Awesome

---

## Architecture

The application follows a layered ASP.NET Web Forms architecture where presentation pages handle user interaction, business logic is implemented in the application layer, and Oracle Database serves as the persistent storage layer.

```text
User Interface (ASP.NET Web Forms)
                ↓
      Business Logic (C#)
                ↓
      Oracle Data Access
                ↓
         Oracle Database
```

---

## Administration Workflow

1. Manage customer records
2. Add and maintain movie information
3. Configure theatres and halls
4. Create movie shows and showtimes
5. Manage ticket information
6. Monitor booking activity
7. Generate operational reports
8. Analyse theatre occupancy and movie performance

---

## Technical Highlights

### Enterprise ASP.NET Development

Built using ASP.NET Web Forms and C# following enterprise application development practices.

### Oracle Database Integration

Implemented Oracle database connectivity using ODP.NET Managed Driver for reliable data management and reporting.

### Cinema Operations Management

Designed modules for managing movies, theatres, halls, shows, showtimes, customers, and ticket operations.

### Administrative Analytics

Developed reporting dashboards for occupancy tracking, booking trends, ticket monitoring, and movie performance analysis.

### Modular Design

Structured application modules around distinct business functions to improve maintainability and scalability.

### Responsive User Interface

Implemented Bootstrap-based layouts and reusable master pages for consistent user experience across all administrative screens.

---

## Project Structure

* `Home.aspx` - Dashboard and analytics landing page.
* `Customer.aspx` - Customer management.
* `Movie.aspx` - Movie management.
* `Theatre.aspx`, `Hall.aspx`, `TheatreCityHall.aspx` - Theatre and hall administration.
* `Show.aspx`, `Showtime.aspx` - Show scheduling and management.
* `Ticket.aspx` - Ticket management.
* `CustomerTicket.aspx`, `TheatreMovie.aspx`, `TopTheatreOccupancy.aspx` - Reporting pages.
* `Site.Master` - Shared layout, navigation, and page shell.
* `Web.config` - Application configuration and Oracle connection settings.

---

## Prerequisites

Before running the project, make sure you have:

* Visual Studio 2019 or later with ASP.NET and web development workload.
* .NET Framework 4.7.2 Developer Pack.
* Oracle Database available locally or on a reachable server.
* Oracle client connectivity configured for the target database.
* NuGet package restore enabled.

---

## Getting Started

1. Open the solution in Visual Studio.
2. Restore NuGet packages if prompted.
3. Update the Oracle connection string in `Web.config` to match your environment.
4. Build the project.
5. Run the application using IIS Express or your configured web server.

---

## Database Configuration

The application uses an Oracle connection string defined in `Web.config`.

Update the `OracleConnection` entry with your:

* Database host
* Port
* Service identifier or SID
* Username
* Password

before deploying or running locally.

---

## Notes for Reviewers

* The application uses a shared master page to keep navigation consistent across all modules.
* Dashboard metrics and reports provide a clear operational overview for cinema administration.
* The current implementation is structured for a business management workflow rather than end-user self-service booking.
* Oracle database integration supports centralized management of cinema operations and reporting.

---

## Future Enhancements

* Role-based authentication and authorization.
* Customer-facing online booking workflows.
* Export reports to PDF and Excel.
* Audit logging and activity tracking.
* Enhanced operational analytics and reporting.
* Real-time dashboard updates.
* Advanced search and filtering capabilities.
* Email notifications and booking confirmations.

---

## Project Highlights

* Enterprise ASP.NET Web Forms Application
* Oracle Database Integration with ODP.NET
* Administrative Dashboard and Reporting
* Cinema, Theatre, Hall, and Showtime Management
* Ticket Lifecycle Management
* Operational Analytics and Occupancy Reporting
* Modular Business-Oriented Design
* Responsive Bootstrap-Based Interface

---

## License

This project is developed for educational and professional purposes.

---

Built using ASP.NET Web Forms, C#, Oracle Database, Bootstrap, and ODP.NET following enterprise software engineering practices.
