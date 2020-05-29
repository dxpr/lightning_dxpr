<?php

namespace Drupal\lightning_dxpr\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Component\Utility\Environment;
use Drupal\Core\Form\FormStateInterface;

/**
 * Provides a Cms form.
 */
class DemoSelectForm extends FormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'lightning_dxpr_demo_select';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {

    $form['#title'] = $this->t('Would you like to install a demo site?');

    $form['demo_select'] = [
      '#type' => 'radios',
      '#title' => t('Install demo content and configuration'),
      '#default_value' => 'dxpr_basic_demo',
      '#options' => array(
        'dxpr_basic_demo' => $this->t('Basic demo (1 page, 1 block, 2 menu links, 1 file)'),
        'dxpr_logistics_demo' => $this->t('Logistics Company demo (15 pages, 3 blocks, 15 menu links, 17 files)'),
        // 'dxpr_main_demo' => $this->t('Product Showcase demo (25 pages, 3 blocks)'),
        // 'dxpr_test_demo' => $this->t('Tech showcase demo for product testing and validation'),
        'none' => $this->t('No demo content'),
      ),
    ];

    $form['actions'] = ['#type' => 'actions'];
    $form['actions']['submit'] = [
      '#type' => 'submit',
      '#value' => t('Save'),
    ];

    return $form;
  }

  /**
   * Runs cron and reloads the page.
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $build_info = $form_state->getBuildInfo();
    $build_info['args'][0]['demo_select'] = $form_state->getValue('demo_select');
    $form_state->setBuildInfo($build_info);
  }

}
