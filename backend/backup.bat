@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims==." %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set today=!datetime:~0,8!


if not exist "backup" (
    mkdir backup
)

echo Backing up PostgreSQL database...

docker exec -t postgres_db pg_dump -U stock_db -d stockdb > "backup\backup_!today!.sql"

if %errorlevel% equ 0 (
    echo ✅ Done! File saved as backup\backup_!today!.sql
) else (
    echo ❌ Backup failed. Please check docker or pg_dump connection.
)

pause
