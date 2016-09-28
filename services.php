<?php
/*
Template Name: Services
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;

$services = get_post_meta( get_the_ID(), 'services', true );

if(empty($services)){
    $post = get_post( get_the_ID() );
    $services = get_post_meta( $post -> post_parent, 'services', true );
}

$context['services'] = $services;
$context['menu']['services'] = new TimberMenu('services');

Timber::render( array( 'services.twig' ), $context );