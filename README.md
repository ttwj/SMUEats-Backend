# smueats_backend
## Server end for SMUEats.

## Database

This project uses PostgreSQL as the database. I use 9.5; earlier versions may not work (main concern is the jsonb type).

To set up the database":    

    nikos@littlebox-loki:~$ sudo -u postgres -i
    [sudo] password for nikos:          
    postgres@littlebox-loki:~$ createuser -P smueats_django
    Enter password for new role: <found in smueats_backend.settings.DATABASES['default']['PASSWORD']>
    Enter it again: 
    postgres@littlebox-loki:~$ psql
    psql (9.5.5)
    Type "help" for help.
    
    postgres=# CREATE DATABASE smueats;
    CREATE DATABASE
    postgres=# \q
    postgres@littlebox-loki:~$


