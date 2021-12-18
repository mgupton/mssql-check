#
# mssql-check.ps1
#
#
# Created By: Michael Gupton
# Created: 2021-12-18
#
# Description:
#
# This script loops over every MSSQL instance on the local machine
# and it runs every *.sql script in the current directory
# against every instance.
#
# Output:
#
# The output from the script is CSV data.
#
# Dependencies:
#
# sqlcmd.exe CLI tool built into MS SQL Server.
#
# Usage:
#
# .\mssql-check.ps1 *> mssql-check.csv
#
function main {
    $instances = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

    $checks = Get-ChildItem -Path ".\*.sql"

    foreach ($instance in $instances) {
         foreach ($check in $checks) {
            Write-Host $instance
            Write-Host $check.Name

            if ($instance -ne "MSSQLSERVER") {
                & sqlcmd -S "(local)\${instance}" -i $check.Name -s "," -h-1
            }
            else {
                & sqlcmd -S "(local)" -i $check.Name -s "," -h-1
            }
        }
    }
}


main
