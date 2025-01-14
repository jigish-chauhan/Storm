<?php

/**
 * @file
 * Storm profile.
 */

/**
 * Implements hook_install_tasks.
 */
function storm_install_tasks(array &$install_state) {
  $tasks = [];

  // All of these tasks modify configuration, so don't do any of them if
  // we're installing from existing config.
  if (empty($install_state['config_install_path'])) {
    $tasks['storm_set_default_theme'] = [];
  }

  return $tasks;
}

/**
 * Sets the default and administration themes.
 */
function storm_set_default_theme() {
  Drupal::configFactory()
    ->getEditable('system.theme')
    ->set('default', 'olivero')
    ->set('admin', 'gin')
    ->save(TRUE);

  // Use the admin theme for creating content.
  if (Drupal::moduleHandler()->moduleExists('node')) {
    Drupal::configFactory()
      ->getEditable('node.settings')
      ->set('use_admin_theme', TRUE)
      ->save(TRUE);
  }
}

/**
 * Implements hook_page_attachments().
 *
 * @param array $attachments
 */
function storm_page_attachments(array &$attachments) {
  // Override the Gin variables globally.
  $attachments['#attached']['library'][] = 'storm/global';

  // Overrides for admin theme.
  $current_theme = \Drupal::theme()->getActiveTheme()->getName();
  if ($current_theme === 'gin') {
    $attachments['#attached']['library'][] = 'storm/overrides';
  }
}
