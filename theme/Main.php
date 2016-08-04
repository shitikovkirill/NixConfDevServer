<?php

namespace Cold;

use Amostajo\WPPluginCore\Plugin as Theme;

require_once __DIR__.'/../classes/SliderWidget.php';
require_once __DIR__.'/../classes/TopWidget.php';
require_once __DIR__.'/../classes/SidebarWidget.php';
require_once __DIR__.'/../classes/admin/head.php';
require_once __DIR__.'/../classes/admin/slider.php';
require_once __DIR__.'/../classes/widget/social-icon.php';
/**
 * Main class.
 * Registers HOOKS used within the plugin.
 * Acts like a bridge or router of actions between Wordpress and the plugin.
 *
 * @link http://wordpress-dev.evopiru.com/documentation/main-class/
 * @version 1.0
 */
class Main extends Theme
{
	
	public function init()
	{
		$this->setTheme();
		$this->add_filter('get_twig', 'TwigController@add_to_twig');
		
		$this->add_filter('timber_context','ColdStorageController@context');
		$this->add_action('wp_enqueue_scripts', 'ColdStorageController@addCss');
		$this->add_action('wp_enqueue_scripts', 'ColdStorageController@addJs');
		$this->add_action('after_setup_theme', 'ColdStorageController@addMenu');
		$this->add_action('widgets_init','ColdStorageController@addSidebar');

		$this->addWidget();


		/*$this->add_action('admin_menu', 'MenuController@addMenuPage');*/
		/*$this->add_action('cmb2_admin_init', 'MetaboxController@slider');
		$this->add_action('cmb2_admin_init', 'MetaboxController@head');*/
	}

	
	public function on_admin()
	{
		
	}

	private function addWidget(){
		$this->add_widget('Cold\Classes\SliderWidget');
		$this->add_widget('Cold\Classes\TopWidget');
		$this->add_widget('Cold\Classes\SidebarWidget');
	}

	private function setTheme(){
		\Timber::$dirname = array('views');
		add_theme_support( 'post-formats' );
		add_theme_support( 'post-thumbnails' );
		add_theme_support( 'menus' );
	}
}