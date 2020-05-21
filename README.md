# lightning_dxpr

## Non-interactive Profile installation

1. `composer clearcache`
2. `composer create-project dxpr/lightning-dxpr-project:8.x-dev <directory_name>`
3. `cd <directory-name>/docroot`
4. `mysql -u root -p -e "drop database tmp;create database tmp;"`
5. `drush site-install lightning_dxpr --db-url=mysql://root@localhost:3306/tmp --account-pass=admin -y -v`

# Demo Sites Included

By default the installation profile will install "Test Demo" content and configuration.

## To install no demo content use:

`drush site-install lightning_dxpr --db-url=mysql://dxpr@localhost:3306/tmp --account-pass=admin lightning_dxpr_demo_select.demo_select=none -y -v`

## To install the Logistics Demo or the Basic Demo or Showcase Demo:

`lightning_dxpr_demo_select.demo_select=logistics_demo`

`lightning_dxpr_demo_select.demo_select=basic_demo`

`lightning_dxpr_demo_select.demo_select=showcase_demo`

