<?php
/*
Template Name: Customer
*/
$context = Timber::get_context();
$post = new TimberPost();
$context['post'] = $post;
$context['customer_sidebar'] = Timber::get_widgets('customer_sidebar');
Timber::render(array('customer.twig'), $context);