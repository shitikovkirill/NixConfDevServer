<?php
/*
Template Name: About
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['about_sidebar'] 	= Timber::get_widgets('about_sidebar');
$context['persons'] = about_get_option('about_person');
$context['testimonials'] = about_get_option('about_testimonials');

Timber::render( array( 'about.twig' ), $context );