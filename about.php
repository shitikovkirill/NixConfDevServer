<?php
/*
Template Name: About
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['about_sidebar'] 	= Timber::get_widgets('about_sidebar');
$context['persons'] = get_post_meta( get_the_ID(), 'about_person', true );
$context['testimonials'] = get_post_meta( get_the_ID(), 'about_testimonials', true );

Timber::render( array( 'about.twig' ), $context );