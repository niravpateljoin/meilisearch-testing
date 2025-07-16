# Meilisearch Testing

This is a Symfony 7.3 + PHP 8.4 demo project that:

* Loads fixtures into a MariaDB database
* Indexes entities into Meilisearch
* Uses Docker Compose and a Makefile for simple setup

---

## ⚙️ Prerequisites

Make sure you have:

* **Docker** and **Docker Compose** installed
* **Composer** installed on your host

---

## 🐳 Getting Started

### 1️⃣ Clone the repository

```bash
git clone https://github.com/niravpateljoin/meilisearch-testing.git
cd meilisearch-testing
```

### 2️⃣ Configure your environment

Copy and update the `.env.local` file with your database credentials and other config:

```
DATABASE_URL="mysql://meilisearch_user:secretpassword@127.0.0.1:3308/meilisearch_testing?charset=utf8mb4"
DB_USER=meilisearch_user
DB_PASSWORD=secretpassword
```

---

## 🎯 Usage

### 🧰 Initialize the entire setup

Use the `make init` target to do everything automatically:

```bash
make init
```

That will:

* Bring up containers (`make up`)
* Wait for the database to be ready (`make wait-db`)
* Run `composer install` inside your host environment
* Create the database (`make migrate`)
* Load the fixtures (`make run-fixture`)

### 🧰 Import into Meilisearch

Once the data is loaded into your database, you can import into Meilisearch:

```bash
make meili-import
```

### 🧰 Tear down containers

When you’re done, stop all containers:

```bash
make down
```

---

## 🧑‍💻 Tech Stack

* PHP 8.4
* Symfony 7.3
* Doctrine DBAL 4.x
* MariaDB 10.11
* Meilisearch v1.14

---

## 💡 Notes

This setup is intended as a local development/test environment. Adjust credentials and scripts for production!

**Happy Coding! 🎉**
