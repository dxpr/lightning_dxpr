<?php

/**
 * @file
 * Enables modules and site configuration for the Lightning DXPR profile.
 */

use Drupal\user\RoleInterface;

/**
 * Implements hook_install_tasks().
 */
function lightning_dxpr_install_tasks(&$install_state) {
  $tasks = [];

  // Set up base configuration (ported from lightning.profile).
  if (empty($install_state['config_install_path'])) {
    $tasks['lightning_dxpr_set_front_page'] = [];
    $tasks['lightning_dxpr_grant_shortcut_access'] = [];
  }

  $tasks['lightning_dxpr_demo_select'] = [
    'display_name' => t('Select Demo'),
    'type' => 'form',
    'function' => 'Drupal\lightning_dxpr\Form\DemoSelectForm',
  ];
  $tasks['lightning_dxpr_module_install'] = [
    'display_name' => t('Install additional modules'),
    'type' => 'batch',
  ];

  return $tasks;
}

/**
 * Sets the front page path to /node.
 */
function lightning_dxpr_set_front_page() {
  if (\Drupal::moduleHandler()->moduleExists('node')) {
    \Drupal::configFactory()
      ->getEditable('system.site')
      ->set('page.front', '/node')
      ->save(TRUE);
  }
}

/**
 * Allows authenticated users to use shortcuts.
 */
function lightning_dxpr_grant_shortcut_access() {
  if (\Drupal::moduleHandler()->moduleExists('shortcut')) {
    user_role_grant_permissions(RoleInterface::AUTHENTICATED_ID, ['access shortcuts']);
  }
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
  // Installed separately here so that it can detect and connect any pre-
  // installed media browsers.
  \Drupal::service('module_installer')->install(['dxpr_builder'], TRUE);
  \Drupal::service('module_installer')->install(['dxpr_builder_page'], TRUE);
  \Drupal::service('module_installer')->install(['dxpr_builder_block'], TRUE);

  $batch = [];
  if ($install_state['demo_select'] !== 'none') {
    $operations = [];
    $modules = ['default_content', $install_state['demo_select']];

    foreach ($modules as $module) {
      $operations[] = ['lightning_dxpr_install_module_batch', [$module]];
    }
    $operations[] = ['lightning_dxpr_cleanup_batch', [$install_state['demo_select']]];

    $batch = [
      'operations' => $operations,
      'title' => t('Installing additional modules'),
      'error_message' => t('The installation has encountered an error.'),
    ];
    return $batch;
  }
}

/**
 * Implements callback_batch_operation().
 *
 * Performs batch installation of modules.
 */
function lightning_dxpr_install_module_batch($module, &$context) {
  \Drupal::service('module_installer')->install([$module], TRUE);
  $context['results'][] = $module;
  $context['message'] = t('Installed %module_name module.', ['%module_name' => $module]);
}

/**
 * Implements callback_batch_operation().
 */
function lightning_dxpr_cleanup_batch($module, &$context) {
  \Drupal::service('module_installer')->uninstall(['default_content'], FALSE);

  // Update url aliases with menu tokens.
  $result = \Drupal::entityQuery('node')->accessCheck(FALSE)->execute();
  $entity_storage = \Drupal::entityTypeManager()->getStorage('node');
  $entities = $entity_storage->loadMultiple($result);
  foreach ($entities as $entity) {
    \Drupal::service('pathauto.generator')->updateEntityAlias($entity, 'update');
  }

  // Set the front page from the demo module's front-path.txt.
  $module_path = \Drupal::service('extension.list.module')->getPath($module);
  if ($path = file_get_contents($module_path . '/front-path.txt')) {
    $path = trim($path);
    $front_page = \Drupal::entityTypeManager()->getStorage('node')->loadByProperties(['uuid' => $path]);
    if ($front_page) {
      $node = reset($front_page);
      \Drupal::configFactory()->getEditable('system.site')->set('page.front', '/node/' . $node->id())->save(TRUE);
    }
    else {
      \Drupal::configFactory()->getEditable('system.site')->set('page.front', '/')->save(TRUE);
    }
  }

  $context['message'] = t('Cleanup.');
}
