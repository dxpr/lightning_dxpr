b482b74

# Drupal Lightning DXPR 

Lightning DXPR is a Drupal 9 installation profile that empowers your entire organization to build and maintain your digital experience effectively. 

While installing Lightning DXPR you can choose betwoon 3 website configurations:

#### No Demo Content

Start with a blank sheet.

#### Basic Demo

Contains 2 demo pages and a few menu links and files. This will help you get to know Lightning DXPR a little better. After you're done warming up you can delete the few demo content items that are included.

#### Logistics Demo

This is a fully fledged turn-key website for an imaginary logistics company. You can use this demo site as training ground, or to show others. It contains pages, images, webforms, and showcases what DXPR Builder and DXPR Theme can do for you.

## Composer Project Installation

See instructions here: https://github.com/dxpr/lightning_dxpr_project

## Drupal Installation

You can install DXPR Lightning in your browser using the Drupal installation wizard. Alternatively you can install our profile non-interactively with you Drush.

### Non-interactive Drupal Installation

Run the following commands in your terminal, replacing the capitalized strings:

```
$ cd EXAMPLE_DIRECTORY/docroot
$ mysql -u USERNAME -p -e"create database DB_NAME;"

# optionally if you have a DXPR Builder Enterprise subscription:
$ composer require dxpr/dxpr_builder_e

$ ../vendor/drush/drush/drush site-install lightning_dxpr lightning_dxpr_demo_select.demo_select=dxpr_basic_demo --db-url=mysql://USERNAME:PASSWORD@localhost:3306/DB_NAME --account-pass=admin -y -v
```

In the last command the demo_select parameter has three options:

1. dxpr_basic_demo
2. dxpr_logistics_demo
3. dxpr_qa_demo

The third option will install the same QA demo site we use on try.dxpr.com. You can only choose this option if you have access to the DXPR Builder Enterprise module.


## Lightning DXPR Features, differences with plain Drupal core

Visit our product page for more details:

@todo make product page

## Based on Acquia Lightning

For more information about Acquia Lightning check out these links:

* https://www.drupal.org/project/lightning
* https://www.acquia.com/products-services/acquia-lightning


