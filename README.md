## This is a Drupal 8 Distribution that sets you up with DXPR's layout builder module and low-code framework theme, integrated with Acquia Lightning's excellent workflow and media capabilities.

Lightning DXPR is a sub-profile of Acquia Lightning that installs our DXPR Theme and DXPR Builder products, giving you our state-of-the-art marketing Drupal tools integrated with Acquia's Lightning features. More info about Lightning:   

- https://github.com/acquia/lightning-project
- https://github.com/acquia/lightning


## Authentication

- To access `dxpr/dxpr_builder` packages, you need to to have an active subscription at DXPR.com. You can find your token here: https://app.sooperthemes.com/download/all#composer. This token is unique to your DXPR.com account and should be kept secret, like a password. *@todo change url to dxpr.com after site launch*

- Make sure composer is at version 1.10 or higher

- Configure the access token:

```bash
$ composer config --global bearer.packages.dxpr.com <access_token>
```

## Non-interactive Profile installation

1. `composer clearcache`
2. `composer create-project dxpr/lightning-dxpr-project:1.x-dev EXAMPLE_DIRECTORY`
3. `cd EXAMPLE_DIRECTORY/docroot`
4. `mysql -u MYSQL_USERNAME -p -e "create database EXAMPLE_DATABASE_NAME;"`
5. `drush site-install lightning_dxpr lightning_dxpr_demo_select.demo_select=dxpr_basic_demo --db-url=mysql://MYSQL_USERNAME@localhost:3306/EXAMPLE_DATABASE_NAME --account-pass=admin -y -v`

# Demo Sites Included

By default the installation profile will install "Basic Demo" content and configuration.

## To install without demo content:

Replace `demo_select=dxpr_basic_demo` with `demo_select=none` in command 5.

## To install the Logistics Demo:

Replace `demo_select=dxpr_basic_demo` with `demo_select=dxpr_logistics_demo` in command 5.


