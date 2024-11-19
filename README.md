# FinReach

FinReach is a web platform designed to bridge the gap between individuals business(MSMEs) and financial service providers (FSPs) such as banks and insurance companies. The platform allows FSPs to request access to individuals' financial data to offer personalized financial solutions, enabling users to manage their business-related financial activities, expenses, and income more efficiently.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [Routes Overview](#routes-overview)
- [License](#license)

## Features

- **User Registration and Authentication:** Supports separate registration and login processes for individuals and FSPs, managed by Devise.
- **Data Access Requests:** FSPs can request data access from individual users. Admins can approve or reject these requests.
- **Financial Dashboard:** Users can view their income, expenses, and generate business reports.
- **Admin Features:** Administrators can manage data access requests and impersonate users for troubleshooting purposes.
- **PDF Generation:** Users can download a report of their financial activities as a PDF document.

## Installation

To set up FinReach on your local environment:

1. **Clone the Repository**
   ```sh
   git clone https://github.com/username/finreach.git
   cd finreach
   ```

2. **Install Dependencies**
   Install Ruby and Rails dependencies:
   ```sh
   bundle install
   ```

3. **Setup Database**
   Setup PostgreSQL and run database migrations:
   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Install JavaScript Packages**
   Install JavaScript dependencies using Yarn or npm:
   ```sh
   yarn install
   ```

5. **Run the Server**
   Start the Rails server:
   ```sh
   rails server
   ```

   The application will be available at [http://localhost:3000](http://localhost:3000).

## Usage

- **Access the Homepage** to get an overview of the platform.
- **Sign Up or Log In** as an individual user or as an FSP.
- **Request Data Access** from individuals as an FSP.
- **Admin Login** to manage data requests and oversee platform activities.

## Technologies Used

- **Ruby on Rails:** The primary framework for backend development.
- **PostgreSQL:** Database management system.
- **Devise:** User authentication system for handling login, registration, and permissions.
- **Bootstrap:** Frontend framework for responsive UI.
- **Sidekiq:** Background job processing for tasks such as sending emails.
- **Madmin:** For admin functionalities and user impersonation.

## Routes Overview

- **Root Path:**
  - Individual Users: `/dashboard`
  - FSP Users: `/fsp_dashboard`
- **User Registration and Login**:
  - Individual Users: `/users/sign_up`, `/users/sign_in`
  - FSP Users: `/fsp/sign_up`, `/fsp/sign_in`
- **Admin Panel**: `/admin/data_access_requests`
- **Request Data Access (FSP)**: `/fsp_dashboard/request_data_access/:id`
- **PDF Download**: `/dashboard/download_pdf`

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

