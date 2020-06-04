# lightning_dxpr

## Non-interactive Profile installation

1. `composer clearcache`
2. `composer create-project dxpr/lightning-dxpr-project:1.x-dev EXAMPLE_DIRECTORY`
3. `cd <directory-name>/EXAMPLE_DIRECTORY`
4. `mysql -u MYSQL_USERNAME -p -e "create database EXAMPLE_DATABASE_NAME;"`
5. `drush site-install lightning_dxpr lightning_dxpr_demo_select.demo_select=dxpr_basic_demo --db-url=mysql://MYSQL_USERNAME@localhost:3306/EXAMPLE_DATABASE_NAME --account-pass=admin -y -v`

# Demo Sites Included

By default the installation profile will install "Basic Demo" content and configuration.

## To install without demo content:

Replace `demo_select=dxpr_basic_demo` with `demo_select=none` in command 5.

## To install the Logistics Demo:

Replace `demo_select=dxpr_basic_demo` with `demo_select=dxpr_logistics_demo` in command 5.


