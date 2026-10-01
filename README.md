# Pharma Sales Force Effectiveness & Territory Optimization

An end-to-end commercial analytics and business intelligence project analyzing pharmaceutical product demand, sales-force activity, HCP coverage, territory performance, and commercial opportunity.

The project combines an observed pharmaceutical sales dataset with a transparent synthetic commercial layer to simulate a realistic sales-force effectiveness use case.

---

## Tableau Public Dashboard

Explore the interactive dashboards on Tableau Public:

**[View the Interactive Tableau Dashboard](https://public.tableau.com/views/Pharmacy-Sales-Force-Effectiveness-and-Territory-Analysis/TerritoryPerformanceOpportunity2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

The workbook contains three dashboards:

- Executive Overview
- Territory Performance & Opportunity
- HCP Coverage & Opportunity

---

## Project Overview

Pharmaceutical companies need to understand not only how products are selling, but also whether their sales force is focusing effort on the right territories and healthcare professionals (HCPs).

This project was built to answer questions such as:

- Which territories generate the most sales?
- How does territory performance compare with modeled commercial potential?
- Where might sales-force effort be under-aligned with opportunity?
- What proportion of HCPs are being covered by the field force?
- Which HCPs have high modeled potential but limited field activity?
- How efficiently is the sales force generating sales relative to calls?
- How is the product portfolio distributed across therapeutic areas?

The final solution is implemented as a commercial analytics pipeline using Python, DuckDB, SQL, and Tableau Public.

---

## Business Problem

The goal is to create a sales-force effectiveness framework that connects:

**Product Demand → Territories → HCPs → Sales Representatives → Field Activity → Opportunity**

The project focuses on three major analytical areas:

### 1. Territory Performance

Understand sales performance across modeled territories and compare it with modeled market potential.

### 2. HCP Coverage

Measure how effectively the sales force is reaching HCPs and identify HCPs with no recorded calls.

### 3. Sales-Force Opportunity

Prioritize HCPs and territories where modeled commercial potential and field-force coverage indicate possible whitespace.

---

## Data Disclaimer

This project intentionally uses a **hybrid observed + modeled data architecture**.

### Observed Data

The pharmaceutical product sales data comes from the public dataset:

**Pharma Sales Data by Milan Zdravkovic**

The source dataset contains daily sales measurements for eight pharmaceutical product codes from January 2014 to October 2019.

### Modeled Data

The original dataset does not contain sales-force, territory, HCP, representative, or call information.

Therefore, the following components were modeled synthetically for this project:

- Territories
- Territory market potential
- HCPs
- HCP specialties
- HCP tiers
- HCP potential scores
- Sales representatives
- Sales calls
- Call outcomes
- Territory-level sales allocation
- HCP opportunity scores

These modeled entities are **not real-world observations** and are not intended to represent actual pharmaceutical companies, physicians, territories, or prescribing behavior.

The synthetic commercial layer was designed to demonstrate how a sales-force effectiveness analytics workflow could be structured when field-force data is available.

---

## Tech Stack

- Python
  - Pandas
  - NumPy
  - Matplotlib
- DuckDB
- SQL
- Tableau Public
- Jupyter Notebook
- Git / GitHub

### Pipeline

    Public Pharmaceutical Sales Data
                    |
                    v
              Python / Pandas
                    |
                    v
         Data Preparation & Modeling
                    |
                    +-- Product Dimension
                    +-- Date Dimension
                    +-- Territory Dimension
                    +-- HCP Dimension
                    +-- Rep Dimension
                    +-- Territory Sales
                    +-- Sales Calls
                    |
                    v
                 DuckDB
                    |
                    v
             SQL Analytics Layer
                    |
                    +-- Territory Performance
                    +-- Territory Opportunity
                    +-- HCP Coverage
                    +-- Sales Force Effectiveness
                    +-- Product Portfolio
                    +-- HCP Opportunity Scoring
                    |
                    v
                CSV Outputs
                    |
                    v
               Tableau Public
                    |
                    v
            Interactive Dashboards

---

## Data Model

The project follows a simplified star-schema style architecture.

### Dimension Tables

| Table | Description |
|---|---|
| `dim_product` | Pharmaceutical product codes and therapeutic areas |
| `dim_date` | Calendar attributes for the observed sales period |
| `dim_territory` | Modeled territories, regions, and market potential |
| `dim_hcp` | Modeled HCPs, specialties, tiers, and potential scores |
| `dim_rep` | Modeled sales representatives assigned to territories |

### Fact Tables

| Table | Description |
|---|---|
| `fact_territory_sales` | Modeled territory-level product sales |
| `fact_calls` | Modeled sales-force calls to HCPs |

---

## Source Pharmaceutical Sales Data

The source dataset contains:

- **2,106 dates**
- **8 pharmaceutical products**
- **16,848 date-product observations after reshaping**
- Date range: **2014-01-02 to 2019-10-08**

Product codes:

- `M01AB`
- `M01AE`
- `N02BA`
- `N02BE`
- `N05B`
- `N05C`
- `R03`
- `R06`

The original data was transformed from a wide format into a long analytical format with:

- `date`
- `product_code`
- `sales`

The `sales` field represents a sales-volume/measurement value from the source dataset and is **not treated as revenue**.

---

## Product Portfolio

The products were mapped to broad therapeutic areas:

| Product Code | Therapeutic Area |
|---|---|
| M01AB | Musculoskeletal |
| M01AE | Musculoskeletal |
| N02BA | Analgesics |
| N02BE | Analgesics |
| N05B | Nervous System |
| N05C | Nervous System |
| R03 | Respiratory |
| R06 | Respiratory |

In the observed source data, `N02BE` represents the largest share of the overall sales measure.

---

## Synthetic Commercial Layer

### Territories

The project contains:

- **20 modeled territories**
- 4 modeled regions:
  - North
  - South
  - East
  - West

Each territory receives a synthetic `market_potential` score between 30 and 100.

This score is a **commercial opportunity proxy**, not actual geographic market size.

### HCPs

The project contains:

- **500 modeled HCPs**

Each HCP has:

- HCP ID
- Territory
- Specialty
- HCP tier
- Potential score

HCP tiers:

- A
- B
- C

The tiers represent synthetic commercial segmentation and are **not clinical rankings**.

Specialties were assigned to align logically with the modeled therapeutic areas.

### Sales Representatives

The project contains:

- **20 modeled sales representatives**
- One representative assigned to each modeled territory.

### Sales Calls

The project contains:

- **40,000 modeled sales calls**

Each call contains:

- Date
- Representative
- Territory
- HCP
- Call outcome

Call outcomes include:

- Successful
- Follow-up Required
- No Contact

Call assignment was designed so that higher-tier and higher-potential HCPs have a greater probability of receiving field activity.

The model also intentionally allows some HCPs to remain uncovered so that coverage and whitespace analysis is meaningful.

---

## Territory Sales Modeling

The original pharmaceutical sales data does not contain geographic or territory-level information.

Therefore, observed product sales were allocated across the 20 modeled territories using territory market-potential weights.

A controlled random variation factor was then applied to avoid every territory following exactly the same proportional sales pattern.

The resulting table contains approximately **337K modeled territory-product-date records** with:

- `date`
- `territory_id`
- `product_code`
- `sales`

This is a modeled commercial layer and should not be interpreted as actual geographic sales.

---

## Analytical SQL Layer

Six SQL analyses are generated through DuckDB.

### 1. Territory Performance

File: `01_territory_performance.sql`

Measures:

- Total sales
- Average sales
- Products sold
- Active days
- Market potential

### 2. Territory Opportunity

File: `02_territory_opportunity.sql`

Creates relative indices for:

- Sales
- Market potential
- Realization
- Opportunity gap

The opportunity analysis compares territories relative to the modeled network rather than directly comparing raw sales values with market-potential scores, since those measures are on different scales.

### 3. HCP Coverage

File: `03_hcp_coverage.sql`

Measures:

- Total calls
- Successful calls
- Coverage flag
- Coverage status
- HCP potential
- HCP tier

An HCP is considered covered if they received at least one recorded call.

### 4. Sales Force Effectiveness

File: `04_sales_force_effectiveness.sql`

Measures:

- Total calls per representative
- HCPs covered
- Territory sales
- Total HCP potential in territory
- Calls per HCP
- Sales per call

### 5. Product Portfolio

File: `05_product_portfolio.sql`

Measures:

- Product sales
- Product sales share
- Therapeutic-area contribution

### 6. HCP Opportunity Scoring

File: `06_opportunity_scoring.sql`

Creates a transparent rule-based opportunity score using:

- HCP potential
- HCP tier
- Coverage status

The score is a **project-defined synthetic prioritization metric** and is not a machine-learning model.

The weighting is:

| Component | Weight |
|---|---:|
| Potential Score | 60% |
| HCP Tier | 20% |
| Uncovered Status | 20% |

The resulting score is intended to demonstrate how a field-force prioritization framework could be constructed.

---

## Key Project Metrics

The final Tableau model currently shows:

| Metric | Value |
|---|---:|
| Total Modeled Sales | 127,615 |
| Active Territories | 20 |
| HCP Coverage | 82.2% |
| Sales per Call | 3.19 |
| Modeled HCPs | 500 |
| Modeled Sales Calls | 40,000 |
| Modeled Sales Representatives | 20 |

The sales figure is a modeled territory-level sales measure, not pharmaceutical revenue.

---

## Tableau Dashboards

The Tableau workbook contains three dashboards.

### 1. Executive Overview

Provides a high-level view of:

- Total sales
- Active territories
- HCP coverage
- Sales per call
- Sales by territory
- Product contribution
- Territory opportunity

This dashboard is designed for an executive/commercial overview.

### 2. Territory Performance & Opportunity

Focuses on territory-level analysis.

Includes:

- Territory sales ranking
- Sales index
- Potential index
- Opportunity gap
- Territory-level performance comparison

The goal is to identify territories where modeled commercial potential and sales performance may not be aligned.

### 3. HCP Coverage & Opportunity

Provides an HCP-level field-force action view.

Includes:

- HCP coverage
- HCP opportunity score
- Territory
- Specialty
- HCP tier
- Potential score
- Total calls
- Coverage status

HCPs can be examined based on their modeled potential and field-force coverage.

---

## Repository Structure

    pharma-sfe-territory-optimization/
    |
    +-- data/
    |   +-- raw/
    |   |   +-- pharma_sales/
    |   |       +-- salesdaily.csv
    |   |
    |   +-- processed/
    |       +-- analytics/
    |       +-- dim_product.csv
    |       +-- dim_date.csv
    |       +-- dim_territory.csv
    |       +-- dim_hcp.csv
    |       +-- dim_rep.csv
    |       +-- fact_calls.csv
    |       +-- fact_territory_sales.csv
    |
    +-- notebooks/
    |   +-- 01_data_exploration.ipynb
    |
    +-- sql/
    |   +-- 01_territory_performance.sql
    |   +-- 02_territory_opportunity.sql
    |   +-- 03_hcp_coverage.sql
    |   +-- 04_sales_force_effectiveness.sql
    |   +-- 05_product_portfolio.sql
    |   +-- 06_opportunity_scoring.sql
    |
    +-- src/
    |   +-- run_analytics.py
    |
    +-- tableau/
    |
    +-- screenshots/
    |
    +-- requirements.txt
    +-- .gitignore
    +-- README.md

The local DuckDB database is intentionally excluded from version control through `.gitignore`.

---

## How to Run the Project

### 1. Clone the repository

    git clone <YOUR_GITHUB_REPOSITORY_URL>
    cd pharma-sfe-territory-optimization

### 2. Install dependencies

    pip install -r requirements.txt

### 3. Run the notebook

Open:

`notebooks/01_data_exploration.ipynb`

The notebook performs the data exploration, preparation, and generation of the modeled commercial datasets.

### 4. Run the SQL analytics pipeline

    python src/run_analytics.py

This:

1. Loads the processed datasets into DuckDB.
2. Executes the SQL analysis files.
3. Exports the analytical results to `data/processed/analytics/`.

---

## Methodological Notes & Limitations

This project is intended as a portfolio demonstration of commercial analytics and BI techniques.

### Synthetic Commercial Data

Territories, HCPs, sales representatives, calls, market potential, and opportunity scores are modeled rather than observed.

### No Real Geographic Information

The territory names are representative modeled territories and should not be interpreted as actual pharmaceutical sales territories.

### No Real HCP Information

HCP IDs, specialties, tiers, and potential scores are synthetic.

### No Revenue Modeling

The source dataset provides sales measurements rather than financial revenue. The project therefore uses the term **sales measure/volume** rather than revenue.

### No Causal Inference

The analysis identifies patterns and potential whitespace. It does not establish that additional calls would necessarily cause additional sales.

### Opportunity Score Is Rule-Based

The HCP opportunity score uses explicitly defined weights and is not trained using machine learning.

### Historical Source Period

The observed sales data ends on 2019-10-08, so the project does not represent current pharmaceutical market conditions.

---

## What This Project Demonstrates

This project demonstrates an end-to-end analytics workflow covering:

- Data cleaning
- Data transformation
- Dimensional modeling
- Synthetic commercial data modeling
- Python / Pandas
- NumPy
- DuckDB
- SQL analytics
- KPI development
- Sales-force effectiveness analysis
- HCP coverage analysis
- Territory opportunity analysis
- Rule-based opportunity scoring
- Tableau dashboard development
- Business-oriented data storytelling
- Git / GitHub project organization

---

## Future Extensions

Potential extensions could include:

- Time-series sales-force activity analysis
- Call-frequency optimization
- Territory rebalancing
- Product-level HCP targeting
- More sophisticated opportunity scoring
- Scenario analysis for additional field-force capacity

These extensions are outside the scope of the current project.

---

## Data Source

**Pharma Sales Data by Milan Zdravkovic**

The source dataset is used as the observed pharmaceutical product-sales layer. All sales-force, territory, HCP, representative, call, and opportunity components were modeled separately for this project.