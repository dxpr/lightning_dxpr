# lightning_dxpr

## Profile installation

1. `composer clearcache`
2. `composer create-project dxpr/lightning-dxpr-project:dev-master <directory_name>`
3. `cd <directory-name>/docroot`
4. `mysql -u root -p -e "drop database tmp;create database tmp;"`
5. `drush site-install lightning_dxpr --db-url=mysql://root@localhost:3306/tmp --account-pass=admin -y -v`
