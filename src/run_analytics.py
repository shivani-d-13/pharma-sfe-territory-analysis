import duckdb
from pathlib import Path

# Project paths

PROJECT_ROOT = Path(__file__).resolve().parents[1]

PROCESSED_DATA = PROJECT_ROOT / "data" / "processed"
SQL_DIR = PROJECT_ROOT / "sql"

DB_PATH = PROJECT_ROOT / "data" / "pharma_analytics.duckdb"


# CSV files to load

TABLES = {
    "dim_product": "dim_product.csv",
    "dim_date": "dim_date.csv",
    "dim_territory": "dim_territory.csv",
    "dim_hcp": "dim_hcp.csv",
    "dim_rep": "dim_rep.csv",
    "fact_calls": "fact_calls.csv",
    "fact_territory_sales": "fact_territory_sales.csv",
}


# Connect to DuckDB

con = duckdb.connect(str(DB_PATH))

print("DuckDB connected successfully.")
print()


# Load CSVs into DuckDB tables

for table_name, filename in TABLES.items():

    csv_path = PROCESSED_DATA / filename

    if not csv_path.exists():
        raise FileNotFoundError(
            f"Missing required file: {csv_path}"
        )

    con.execute(f"""
        CREATE OR REPLACE TABLE {table_name} AS
        SELECT *
        FROM read_csv_auto('{csv_path.as_posix()}')
    """)

    row_count = con.execute(
        f"SELECT COUNT(*) FROM {table_name}"
    ).fetchone()[0]

    print(f"{table_name:<25} {row_count:>10,} rows")


# Verify tables

print()
print("Loaded tables:")

tables = con.execute("SHOW TABLES").fetchall()

for table in tables:
    print(f"- {table[0]}")


# Run SQL analytics and export results

OUTPUT_DIR = PROCESSED_DATA / "analytics"
OUTPUT_DIR.mkdir(exist_ok=True)

SQL_OUTPUTS = {
    "territory_performance.sql": "territory_performance.csv",
    "territory_opportunity.sql": "territory_opportunities.csv",
    "hcp_coverage.sql": "hcp_coverage.csv",
    "sales_force_effectiveness.sql": "rep_performance.csv",
    "product_portfolio.sql": "product_portfolio.csv",
    "opportunity_scoring.sql": "opportunity_scoring.csv",
}

print()
print("Running SQL analytics and exporting results:")

for sql_file, output_file in SQL_OUTPUTS.items():

    sql_path = SQL_DIR / sql_file

    if not sql_path.exists():
        raise FileNotFoundError(
            f"Missing SQL file: {sql_path}"
        )

    query = sql_path.read_text().strip().rstrip(";")

    output_path = OUTPUT_DIR / output_file

    con.execute(f"""
        COPY (
            {query}
        )
        TO '{output_path.as_posix()}'
        (HEADER, DELIMITER ',');
    """)

    row_count = con.execute(
        f"""
        SELECT COUNT(*)
        FROM read_csv_auto('{output_path.as_posix()}')
        """
    ).fetchone()[0]

    print(f"- {output_file:<35} {row_count:>6} rows")


# Close connection

con.close()

print()