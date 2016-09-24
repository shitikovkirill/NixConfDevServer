<?php
/*
Template Name: Services
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['services'] = get_post_meta( get_the_ID(), 'services', true );
$context['menu']['services'] = new TimberMenu('services');

Timber::render( array( 'services.twig' ), $context );