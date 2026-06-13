# Kumari Cinemas

Kumari Cinemas is an ASP.NET Web Forms based ticket booking and cinema management portal designed to streamline day-to-day operations for a movie theatre business. The application provides an admin-focused dashboard for managing customers, movies, theatres, showtimes, tickets, and operational reports backed by an Oracle database.

## Overview

This project demonstrates a traditional enterprise web application built on the Microsoft stack with server-side Web Forms, reusable master pages, Oracle data access, and a responsive Bootstrap-based interface. It combines operational management screens with reporting views to support decision-making around bookings, occupancy, and ticket performance.

## Key Features

- Dashboard with live summary cards for customers, movies, theatres, and tickets.
- Analytics views for movie popularity, genre distribution, daily bookings, and ticket status.
- Customer management and customer ticket reporting.
- Movie, theatre, hall, show, showtime, and ticket management modules.
- Theatre-movie and top theatre occupancy reports.
- Oracle database integration using ODP.NET Managed Driver.
- Shared master layout for consistent navigation and administration workflows.
- Responsive UI built with Bootstrap 5 and Font Awesome icons.

## Tech Stack

- ASP.NET Web Forms
- C#
- .NET Framework 4.7.2
- Oracle Database
- Oracle Managed Data Access (ODP.NET)
- Bootstrap 5
- Chart.js
- Font Awesome

## Project Structure

- `Home.aspx` - dashboard and analytics landing page.
- `Customer.aspx` - customer management.
- `Movie.aspx` - movie management.
- `Theatre.aspx`, `Hall.aspx`, `TheatreCityHall.aspx` - theatre and hall related administration.
- `Show.aspx`, `Showtime.aspx` - show scheduling.
- `Ticket.aspx` - ticket management.
- `CustomerTicket.aspx`, `TheatreMovie.aspx`, `TopTheatreOccupancy.aspx` - reporting pages.
- `Site.Master` - shared layout, navigation, and page shell.
- `Web.config` - application configuration and Oracle connection settings.

## Prerequisites

Before running the project, make sure you have:

- Visual Studio 2019 or later with ASP.NET and web development workload.
- .NET Framework 4.7.2 Developer Pack.
- Oracle Database available locally or on a reachable server.
- Oracle client connectivity configured for the target database.
- NuGet package restore enabled.

## Getting Started

1. Open the solution in Visual Studio.
2. Restore NuGet packages if prompted.
3. Update the Oracle connection string in `Web.config` to match your environment.
4. Build the project.
5. Run the application using IIS Express or your configured web server.

## Database Configuration

The application uses an Oracle connection string defined in `Web.config`. Update the `OracleConnection` entry with your database host, port, service identifier or SID, username, and password before deploying or running locally.

## Notes for Reviewers

- The application uses a shared master page to keep navigation consistent across all modules.
- Dashboard metrics and reports are intended to provide a clear operational overview for cinema administration.
- The current implementation is structured for a business management workflow rather than end-user self-service booking.

## Future Enhancements

- Role-based authentication and authorization.
- Booking workflow improvements for customer-facing ticket reservations.
- Export options for reports in PDF or Excel format.
- Audit logging and richer operational analytics.

## License

No license has been specified for this repository.