<?php
/**
 * The main template file
 * This is the most generic template file in a WordPress theme
 * and one of the two required files for a theme (the other being style.css).
 * It is used to display a page when nothing more specific matches a query.
 * E.g., it puts together the home page when no home.php file exists
 *
 * Methods for TimberHelper can be found in the /lib sub-directory
 *
 * @package  WordPress
 * @subpackage  Timber
 * @since   Timber 0.1
 */

if ( ! class_exists( 'Timber' ) ) {
    echo 'Timber not activated. Make sure you activate the plugin in <a href="/wp-admin/plugins.php#timber">/wp-admin/plugins.php</a>';
    return;
}

$context = Timber::get_context();
$context['post'] = new TimberPost();
$context['home_slider'] = Timber::get_widgets('home_slider');
$context['home_top'] 	= Timber::get_widgets('home_top');
$context['home_right'] 	= Timber::get_widgets('home_left');

$templates = array( 'home.twig' );
Timber::render( $templates, $context );