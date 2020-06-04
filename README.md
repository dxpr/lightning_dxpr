## This is a Drupal 8 Distribution that sets you up with DXPR's layout builder module and low-code framework theme, integrated with Acquia Lightning's excellent workflow and media capabilities.

Lightning DXPR is a sub-profile of Acquia Lightning that installs our DXPR Theme and DXPR Builder products, giving you our state-of-the-art marketing Drupal tools integrated with Acquia's Lightning features. More info about Lightning:   

- https://github.com/acquia/lightning-project
- https://github.com/acquia/lightning


## Composer Installation

See instructions here: https://github.com/dxpr/lightning_dxpr_project

## Non-interactive Profile installation

1. `mysql -u MYSQL_USERNAME -p -e "create database EXAMPLE_DATABASE_NAME;"`
2. `drush site-install lightning_dxpr lightning_dxpr_demo_select.demo_select=dxpr_basic_demo --db-url=mysql://MYSQL_USERNAME:MYSQL_PASSWORD@localhost:3306/EXAMPLE_DATABASE_NAME --account-pass=admin -y -v`

## Demo Sites Included

By default the installation profile will install "Basic Demo" content and configuration.

### To install without demo content:

Replace `demo_select=dxpr_basic_demo` with `demo_select=none` in command 5.

### To install the Logistics Demo:

Replace `demo_select=dxpr_basic_demo` with `demo_select=dxpr_logistics_demo` in command 5.


