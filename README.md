# MacOS PostgreSQL local installation scripts

This script enable to install PostgreSQL in the local directory.

This script can be run without an administrative account, so its useful for quickly setup local database for development purpose.

## Requirement
- bash
- unzip
- curl

## Notes
- PostgreSQL binaries (version 12.2) sourced from https://sbp.enterprisedb.com/getfile.jsp?fileid=12475
- Tested on macOS Catalina, high chance the script also work with older of newer version of macOS.
- Possibly to adjust the script to work in other nix system, by changing the source binaries.