<?php

/**
 * @file
 * Enables modules and site configuration for the Lightning DXPR profile.
 */



/**
 * Implements hook_install_tasks().
 */
function lightning_dxpr_install_tasks(&$install_state) {

  $tasks = [
    'lightning_dxpr_module_install' => [
      'display_name' => t('Install additional modules'),
      'type' => 'batch',
    ],
  ];

  return $tasks;
}

/**
 * Installs the CMS modules in a batch.
 *
 * @param array $install_state
 *   The install state.
 *
 * @return array
 *   A batch array to execute.
 */
function lightning_dxpr_module_install(array &$install_state) {

  $batch = [];
  if (count($install_state['lightning_dxpr_additional_modules']) > 0) {

    $modules = $install_state['lightning_dxpr_additional_modules'];
    array_unshift($modules, 'lightning_dxpr_core');

    // Default content module installs content by implementing
    // hook_modules_installed(). Since CMS modules have no dependency on Default
    // content we need to make sure the module is installed before them.
    // We also install admin_toolbar here because we don't want a dependency on that
    if ($install_state['lightning_dxpr_demo_content']) {
      array_unshift($modules, 'default_content', 'better_normalizers');
    }

    $operations = [];
    foreach ($modules as $module) {
      $operations[] = ['lightning_dxpr_install_module_batch', [$module]];
    }

    // Uninstall Default content and Better normalizers modules as they only
    // needed on installation process.
    if ($install_state['lightning_dxpr_demo_content']) {
      $operations[] = ['lightning_dxpr_cleanup_batch', []];
    }

    $batch = [
      'operations' => $operations,
      'title' => t('Installing additional modules'),
      'error_message' => t('The installation has encountered an error.'),
    ];
  }

  return $batch;
}

/**
 * Implements callback_batch_operation().
 *
 * Performs batch installation of modules.
 */
function lightning_dxpr_install_module_batch($module, &$context) {
  // CMS Modules are not available yet.
  Drupal::service('module_installer')->install([$module], TRUE);

  // We're doing this here because during hook_install it fails due to demo content loading
  // after installation (when default_content module steps in).
  if (strpos($module, '_demo') > 0) {
    $module_path = drupal_get_path('module', $module);
    if ($path = file_get_contents($module_path . '/front-path.txt')) {
      if ($nid = Drupal::database()->query("SELECT nid FROM {node} WHERE uuid = '" . $path . "'")->fetchField()) {
        Drupal::configFactory()->getEditable('system.site')->set('page.front', '/node/' . $nid)->save(TRUE);
      }
      else {
        $front_page = Drupal::entityTypeManager()->getStorage('node')->loadByProperties(['uuid' => $path]);
        if ($front_page) {
          Drupal::configFactory()->getEditable('system.site')->set('page.front', $path)->save(TRUE);
        }
        else {
          Drupal::configFactory()->getEditable('system.site')->set('page.front', '/')->save(TRUE);
        }
      }
    }
  }

  $context['results'][] = $module;
  $context['message'] = t('Installed %module_name module.', ['%module_name' => $module]);
}

/**
 * Implements callback_batch_operation().
 */
function lightning_dxpr_cleanup_batch(&$context) {
  Drupal::service('module_installer')->uninstall(['default_content', 'better_normalizers'], FALSE);

  // Update url aliases with menu tokens (only needed for alises that reflect menu structure)
  $result = \Drupal::entityQuery('node')->execute();
  $entity_storage = \Drupal::entityTypeManager()->getStorage('node');
  $entities = $entity_storage->loadMultiple($result);
  foreach ($entities as $entity) {
    \Drupal::service('pathauto.generator')->updateEntityAlias($entity, 'update');
  }

  $context['message'] = t('Cleanup.');
}