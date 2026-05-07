# Sales Database

A PostgreSQL database for retail sales analytics, designed to be consumed by Qlik Sense dashboards.

---

## Quick Start

**1. Copy the environment file and fill in your values:**

```bash
cp .env.example .env
```

```env
DB_PORT=5433
DB_NAME=sales_hans
DB_USER=postgres
DB_PASSWORD=your_password
```

**2. Start the database:**

```bash
docker compose up -d
```

**3. Verify it's running:**

```bash
docker ps
```

> On first run, Docker automatically executes `genesis.sql` (schema + tables) and `seeder.sql` (seed data) in order.

**To stop:**

```bash
docker compose down
```

**To reset all data:**

```bash
docker compose down -v
docker compose up -d
```

---

## Stack

| Layer | Technology |
|---|---|
| Database | PostgreSQL 15 (Alpine) |
| Container | Docker / Docker Compose |
| BI Tool | Qlik Sense |
| Schema | `hans` |

---

## Database Overview

The schema lives under the `hans` namespace and models a multi-branch retail operation.

```
countries
  └── states
        └── branches   # physical store locations

categories
  └── products         # SKU, barcode, base price

branches + products → sales   (header: date, total, payment method)
                    → sale_details  (line items: qty, unit price, subtotal)
```

### Tables

| Table | Description |
|---|---|
| `countries` | Country reference data |
| `states` | States/provinces linked to a country |
| `branches` | Physical store locations linked to a state |
| `categories` | Product category groupings |
| `products` | Product catalog with SKU, barcode, and base price |
| `sales` | Sale transactions per branch (cash or card) |
| `sale_details` | Line items per sale with quantity, unit price, and subtotal |

### Payment Methods

Sales support two payment methods: `CARD` and `CASH`.

---

## Connecting to the Database

```
Host:     localhost
Port:     5433  (or your DB_PORT)
Database: hans_db  (or your DB_NAME)
User:     hans_user  (or your DB_USER)
Schema:   hans
```
