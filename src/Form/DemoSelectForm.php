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
      '#type' => 'radio',
      '#title' => t('Install demo content and configuration'),
      '#default_value' => 'dxpr_test_content',
      '#options' => array(
        'dxpr_main_demo' => $this->t('DXPR.com Showcase demo site'),
        'dxpr_test_content' => $this->t('Test Content'),
        'logistics_demo' => $this->t('Logistics demo site'),
        'none' => $this
          ->t('No'),
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
