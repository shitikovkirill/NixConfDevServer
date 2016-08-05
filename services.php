<?php
/*
Template Name: Services
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['services'] = services_get_option('services');
$context['menu']['services'] = new TimberMenu('services');

Timber::render( array( 'services.twig' ), $context );