# --- config ---
$PG      = "C:\Program Files\PostgreSQL\17\bin\psql.exe"
$DBUSER  = "postgres"
$DBHOST  = "127.0.0.1"   # <- renamed; do NOT use $Host
$DBPORT  = 5433
$DBNAME  = "servicesdb"

# Optionally avoid password prompts for this session:
# $env:PGPASSWORD = "YourStrongPassword!"

Write-Host ""

# Run every .sql in db/schema in filename order
Get-ChildItem -Path (Join-Path $PSScriptRoot "schema") -Filter "*.sql" |
  Sort-Object Name |
  ForEach-Object {
    Write-Host "Running $($_.Name) ..."
    & $PG -U $DBUSER -h $DBHOST -p $DBPORT -d $DBNAME -v ON_ERROR_STOP=1 -f $_.FullName
  }

Write-Host "Done."