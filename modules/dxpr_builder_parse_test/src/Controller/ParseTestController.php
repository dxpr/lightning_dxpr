<?php

namespace Drupal\dxpr_builder_parse_test\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Controller for DXPR Builder Parse Test.
 */
class ParseTestController extends ControllerBase {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Constructs a new ParseTestController object.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager) {
    $this->entityTypeManager = $entity_type_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('entity_type.manager')
    );
  }

  /**
   * Replaces all image URLs in HTML content with a placeholder URL.
   *
   * @param string $content
   *   The HTML content to process.
   *
   * @return string
   *   The processed HTML content with replaced image URLs.
   */
  protected function replaceImageUrls($content) {
    // Replace src attributes in img tags
    $content = preg_replace('/src=["\'](.*?)["\']/', 'src="https://promptahuman.com/400x300"', $content);
    
    // Replace background-image URLs in style attributes
    $content = preg_replace('/background-image:\s*url\(["\']?(.*?)["\']?\)/', 'background-image: url("https://promptahuman.com/400x300")', $content);
    
    return $content;
  }

  /**
   * Returns the parse_html_test template.
   */
  public function parseHtmlTest() {
    $node = $this->loadNodeByUuid('33379d0d-44a8-4ccb-ba01-7a239d3f2a1f');
    if (!$node) {
      \Drupal::messenger()->addError('Node not found');
      return [
        '#theme' => 'parse_html_test',
        '#node' => NULL,
      ];
    }

    $view_builder = $this->entityTypeManager->getViewBuilder('node');
    $build = $view_builder->view($node);

    // Get the module path
    $module_path = \Drupal::service('module_handler')->getModule('dxpr_builder_parse_test')->getPath();
    $html_examples_path = $module_path . '/html-examples';

    // Initialize array to store examples
    $examples = [];

    // Get all directories in html-examples
    $dirs = array_filter(scandir($html_examples_path), function($item) use ($html_examples_path) {
      return is_dir($html_examples_path . '/' . $item) && !in_array($item, ['.', '..']);
    });

    // Loop through discovered directories
    foreach ($dirs as $dir) {
      $dir_path = $html_examples_path . '/' . $dir;
      $files = scandir($dir_path);
      $examples[$dir] = [];
      
      foreach ($files as $file) {
        if ($file != '.' && $file != '..' && strpos($file, '.html') !== FALSE) {
          $content = file_get_contents($dir_path . '/' . $file);
          if ($content !== FALSE) {
            // Replace image URLs in the HTML content
            $content = $this->replaceImageUrls($content);
            $examples[$dir][$file] = $content;
          }
        }
      }
    }

    return [
      '#theme' => 'parse_html_test',
      '#node' => $node,
      '#node_render' => $build,
      '#examples' => $examples,
      '#attached' => [
        'library' => [
          'dxpr_builder_parse_test/parse-test',
        ],
      ],
    ];
  }

  /**
   * Loads a node by UUID.
   *
   * @param string $uuid
   *   The UUID of the node to load.
   *
   * @return \Drupal\node\NodeInterface|null
   *   The loaded node or null if not found.
   */
  protected function loadNodeByUuid($uuid) {
    $node = \Drupal::entityTypeManager()
      ->getStorage('node')
      ->loadByProperties(['uuid' => $uuid]);
    
    if (empty($node)) {
      \Drupal::logger('dxpr_builder_parse_test')->error('Node with UUID @uuid not found', ['@uuid' => $uuid]);
      return NULL;
    }
    
    return reset($node);
  }

} 