<?php
/*
Template Name: Contacts
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;

Timber::render( array( 'contacts.twig' ), $context );