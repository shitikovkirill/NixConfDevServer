<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 01.08.16
 * Time: 20:40
 */

namespace Cold\Controllers;


use Amostajo\LightweightMVC\Controller;

class ColdStorageController extends Controller
{
    public function addSidebar(){
        register_sidebar( array(
            'name' => 'Home: Slider',
            'id' => 'home_slider',
            'before_widget' => '',
            'after_widget' => '',
            'before_title' => '',
            'after_title' => '',
        ) );
        register_sidebar( array(
            'name' => 'Home: Right sidebar',
            'id' => 'home_left',// mistake right
            'before_widget' => '<div class="block1">',
            'after_widget' => '</div>',
            'before_title' => '',
            'after_title' => '',
        ) );
        register_sidebar( array(
            'name' => 'Home: Footer',
            'id' => 'home_footer',
            'before_widget' => '<div class="grid_12 home-footer">',
            'after_widget' => '</div>',
            'before_title' => '',
            'after_title' => '',
        ) );
        register_sidebar( array(
            'name' => 'All: Social icon',
            'id' => 'home_icon',
            'before_widget' => '<div class="socials">',
            'after_widget' => '</div>',
            'before_title' => '',
            'after_title' => '',
        ) );
        register_sidebar( array(
            'name' => 'Home: Top',
            'id' => 'home_top',
            'before_widget' => '
                <div class="grid_4">
                    <div class="banner">
                        <div class="maxheight">',
            'after_widget' => '
                        </div>
                    </div>
                </div>',
            'before_title' => '',
            'after_title' => '',
        ) );
        register_sidebar( array(
            'name' => 'All: Right sidebar',
            'id' => 'navigation_sidebar',
            'before_widget' => '<ul class="list">',
            'after_widget' => '</ul><div class="hor hr2"></div>',
            'before_title' => '<h3>',
            'after_title' => '</h3>',
        ) );
        register_sidebar( array(
            'name' => 'About: Right sidebar',
            'id' => 'about_sidebar',
            'before_widget' => '<ul class="list">',
            'after_widget' => '</ul><div class="hor hr2"></div>',
            'before_title' => '<h3>',
            'after_title' => '</h3>',
        ) );
        register_sidebar( array(
            'name' => 'Customer: Right sidebar',
            'id' => 'customer_sidebar',
            'before_widget' => '<ul class="list">',
            'after_widget' => '</ul><div class="hor hr2"></div>',
            'before_title' => '<h3>',
            'after_title' => '</h3>',
        ) );
    }

    public function addMenu(){
        register_nav_menu( 'primary', 'Primary Menu' );
        register_nav_menu( 'footer', 'Footer' );
        register_nav_menu( 'services', 'Services' );
    }
    
    public function addCss(){
        wp_enqueue_style('stuck', get_template_directory_uri().'/css/stuck.css');
        wp_enqueue_style('camera', get_template_directory_uri().'/css/camera.css');
        wp_enqueue_style('style', get_template_directory_uri().'/css/style.css');
        wp_register_style('ie', get_template_directory_uri().'/css/ie.css');
        wp_style_add_data('ie','conditional', 'lt IE 9');

    }
    public function deregisterCss()
    {
        if (is_front_page()) {
            wp_dequeue_style('style_register_widget');
            wp_deregister_style('style_register_widget');
        }
    }
    
    public function addJs(){
        wp_deregister_script('jquery');
        wp_enqueue_script(
            'jquery',
            get_template_directory_uri().'/js/jquery.js'
        );
        wp_deregister_script('jquery-migrate');
        wp_enqueue_script(
            'jquery-migrate',
            get_template_directory_uri().'/js/jquery-migrate-1.1.1.js',
            ['jquery'],
            "1.1.1"
        );
        wp_enqueue_script(
            'easing',
            get_template_directory_uri().'/js/jquery.easing.1.3.js',
            ['jquery']
        );
        wp_enqueue_script(
            'script',
            get_template_directory_uri().'/js/script.js',
            ['jquery']
        );
        wp_enqueue_script(
            'superfish',
            get_template_directory_uri().'/js/superfish.js',
            ['jquery']
        );
        wp_enqueue_script(
            'jquery.equalheights',
            get_template_directory_uri().'/js/jquery.equalheights.js',
            ['jquery']
        );
        wp_enqueue_script(
            'jquery.mobilemenu',
            get_template_directory_uri().'/js/jquery.mobilemenu.js',
            ['jquery']
        );
        wp_enqueue_script(
            'jquery.equalheights',
            get_template_directory_uri().'/js/jquery.easing.1.3.js',
            ['jquery'],
            '1.3'
        );
        wp_enqueue_script(
            'tmStickUp',
            get_template_directory_uri().'/js/tmStickUp.js',
            ['jquery']
        );
        wp_enqueue_script(
            'jquery.ui.totop',
            get_template_directory_uri().'/js/jquery.ui.totop.js',
            ['jquery']
        );
        wp_enqueue_script(
            'camera',
            get_template_directory_uri().'/js/camera.js',
            ['jquery']
        );
        wp_register_script(
            'jquery.mobile.customized.min',
            get_template_directory_uri().'/js/jquery.mobile.customized.min.js',
            ['jquery']
        );
        wp_register_script(
            'html5shiv',
            get_template_directory_uri().'/js/html5shiv.js',
            ['jquery']
        );

        wp_enqueue_script(
            'film_roll',
            get_template_directory_uri().'/js/carousel/jquery.film_roll.min.js',
            ['jquery']
        );
        wp_enqueue_script(
            'touchSwipe',
            get_template_directory_uri().'/js/carousel/jquery.touchSwipe.min.js',
            ['jquery']
        );

        wp_script_add_data('jquery.mobile.customized.min', 'conditional', '(gt IE 9)|!(IE)');
        wp_script_add_data('html5shiv','conditional', 'lt IE 9');
    }

    public function dellVersion($src){
        $parts = explode( '?', $src );
        $script =$parts[0];
	    return $script;
    }
    
    public function context($context){
        $context['menu']['main'] = new \TimberMenu('primary');
        $context['menu']['footer_menu'] = new \TimberMenu('footer');
        $context['theme_url'] = get_template_directory_uri();
        $context['option']['head'] = get_option('head_options');
        $context['home_icon'] 	= \Timber::get_widgets('home_icon');
        $context['navigation_sidebar'] 	= \Timber::get_widgets('navigation_sidebar');
        $context['site'] = new \TimberSite();
        return $context;
    }

    public function remove_admin_bar() {
        if (!current_user_can('administrator') && !is_admin()) {
            add_filter('show_admin_bar', '__return_false'); // отключить
        }
    }
}