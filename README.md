# MyChemicals

Web application for managing agricultural chemical inventory, storage, stock movements, and product usage across farm activities.

## About

MyChemicals is a Rails application designed to help agricultural properties manage chemical products throughout their lifecycle.

The application covers inventory management, storage, stock movements, agricultural activities, employees, and access control, providing a centralized workflow for managing chemical products within farms and their storage facilities.

The project started as a collaborative application developed during a Le Wagon coding bootcamp and has since evolved into an independently maintained and continuously developed project.

## Features

- **Farm Management**
  - Create and manage agricultural properties
  - Manage employees and access to farms
  - Control access based on user roles and farm membership

- **Storage Management**
  - Manage chemical storage facilities within farms
  - Organize chemical products by storage location
  - Track stock movements associated with each storage

- **Chemical Inventory**
  - Register chemical products
  - Search and filter products
  - Track product quantities and stock movements
  - Manage inventory across different storage locations

- **Stock Movements**
  - Register product entries and withdrawals
  - Manage stock movements through carts
  - Support approval workflows for stock operations
  - Track pending and recorded movements

- **Agricultural Activities**
  - Register agricultural activities
  - Associate chemical products with activities
  - Record quantities used
  - Assign responsible employees
  - Generate activity history reports

- **Authentication & Authorization**
  - User authentication
  - Role-based access control
  - Farm-level authorization
  - Employee access management

- **Reports**
  - Generate PDF reports for agricultural activities
  - Generate reports for stock movements

## Project History

MyChemicals was originally created as a collaborative project during the Le Wagon coding bootcamp.

The original development team consisted of:

- Bernardo Carvalho
- Henrique
- Lucas
- Jordano
- Clara

After the bootcamp ended, Bernardo Carvalho continued the project independently.

For nearly two years, he has been the sole maintainer and active developer of MyChemicals, continuing to evolve the application, implement new features, fix bugs, improve the codebase, and maintain its test suite.

## My Contribution

After the original collaborative development during the bootcamp, I continued MyChemicals independently as its sole maintainer.

Since then, I have been responsible for the ongoing development and maintenance of the application, including:

- Designing and implementing new features
- Maintaining and evolving the existing Rails codebase
- Implementing and improving authorization rules
- Developing inventory and stock management workflows
- Fixing bugs and improving existing functionality
- Expanding automated test coverage
- Maintaining domain rules related to chemicals, storage, carts, and stock movements
- Improving application reliability and maintainability

The **Activities module** was also designed and implemented by me. This module integrates agricultural activities with chemical usage and responsible employees, including activity history and PDF reporting.

## Tech Stack

### Backend

- Ruby 3.1.2
- Ruby on Rails 7.1
- PostgreSQL

### Frontend

- HTML
- CSS
- JavaScript
- Bootstrap 5
- Hotwire
- Stimulus
- Turbo

### Authentication & Authorization

- Devise
- Pundit

### Search & Data

- PgSearch
- Ransack

### Reports

- Prawn

### Testing

- RSpec
- Factory Bot
- Capybara
- Selenium

## Application Architecture

The application follows Rails' MVC architecture and uses domain models to represent the main entities of the system.

Some of the core relationships include:

```text
User
 ├── Farms
 │    ├── Storages
 │    │    └── Carts
 │    │         └── Cart Chemicals
 │    │              └── Chemicals
 │    │
 │    └── Activities
 │         ├── Activity Chemicals
 │         │    └── Chemicals
 │         └── Responsibles
 │
 └── Employees
