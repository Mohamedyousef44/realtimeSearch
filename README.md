# 🔎 Real Time Search Rails App

This Ruby on Rails application logs user search queries, analyzes top searches, and displays recent ones based on IP and session ID.

---

## 📦 Requirements

- **Ruby**: 3.2.x (check with `ruby -v`)
- **Rails**: 7.x (check with `rails -v`)
- **MYSql** (or SQLite3 for development)

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

### 2. Install Dependencies

```bash
bundle install


### 3. Prepare your ENV file
overide the .env-example with your database creds

### 4. Setup the Database

```bash
rails db:create
rails db:migrate

### 5. Run the server

```bash
rails s


