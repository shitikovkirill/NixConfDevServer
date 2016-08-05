<?php
/*
Template Name: About
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['about_sidebar'] 	= Timber::get_widgets('about_sidebar');

Timber::render( array( 'about.twig' ), $context );