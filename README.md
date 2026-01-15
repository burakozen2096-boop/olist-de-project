# Olist Analytics Engineering Project

This repository showcases an **end-to-end Analytics Engineering workflow** built on the public **Olist e-commerce dataset**, using **PostgreSQL, dbt, and Docker**.

The project focuses on **clean data modeling, testable transformations, and analytical validation**, designed as a **portfolio-ready analytics engineering case**.

---

## Project Scope

**What this project demonstrates:**
- Reproducible raw data ingestion
- Layered dbt transformations (staging → intermediate → marts)
- Well-defined fact & dimension modeling
- Automated data quality testing
- SQL-based analytical validation
- Clear documentation and lineage visibility

---

## Tech Stack

- PostgreSQL (Dockerized)
- dbt Core
- Docker & Docker Compose
- SQL

---

## Repository Structure (Simplified)

```bash
.
├── docker-compose.yml
├── sql/                # Raw schema & CSV loaders
├── dbt/olist_dbt/
│   ├── models/
│   │   ├── raw/        # dbt sources
│   │   ├── staging/    # casting & cleanup
│   │   ├── intermediate/
│   │   └── marts/      # facts & dimensions
│   ├── analyses/       # analytical validation queries
│   └── tests/
```

## Data Layers

### Raw
- CSVs loaded via COPY
- All columns stored as TEXT
- Immutable and auditable
- CSV files are not committed to Git

### Staging
- Type casting
- Column renaming
- One-to-one with raw tables
- No joins or aggregations

### Intermediate
- Structural transformations that don’t belong in staging or marts
(e.g. geolocation de-duplication by zip prefix)

### Marts

#### Dimensions
- dim_customers
- dim_products
- dim_sellers
- dim_date
- dim_geography

### Facts
- fct_orders (1 row per order)
- fct_order_items (1 row per order item)
- Grain is explicitly defined to avoid double counting.

## Data Quality & Testing

Automated dbt tests cover:
- not_null
- unique
- primary key integrity
- fact & dimension grain enforcement

Run models and tests:

dbt build

## Analytical Validation (SQL Analyses)

To validate correctness beyond schema tests, the project includes SQL analyses such as:
- Orphan record checks
- Revenue reconciliation
- Delivery delay vs review score
- Payment type distribution
- Top categories by revenue

Run an analysis:

dbt show --select 02_top_categories_by_revenue

These analyses act as business-level sanity checks.

## dbt Docs & Lineage

Generate documentation:

```bash
dbt docs generate
```

Serve docs locally:

```bash
dbt docs serve
```

This provides:
- Model & column documentation
- Full lineage graph (raw → staging → marts → analyses)

![dbt lineage graph](lineage.png)

## How to Run Locally

```bash
docker compose up -d
conda activate dsproj
dbt build
dbt docs serve
```