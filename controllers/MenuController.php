<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 02.08.16
 * Time: 22:32
 */

namespace Cold\Controllers;


use Amostajo\LightweightMVC\Controller;

class MenuController extends Controller
{
    public function addMenuPage(){
        $main = add_menu_page( 'Theme settings', 'Theme settings', 'manage_options', 'cold-storage', array( $this, 'cold_storage_page_display' ) );
        $slider = add_submenu_page( 'cold-storage', 'Slider', 'Slider', 'manage_options', 'slider_options', array( $this, 'slider_page_display' ) );

        //add_submenu_page('limited_mm','Users list', 'Users list',  'administrator', 'limited_mm_list_page', array($this, 'admin_page_list') );
        //$user =add_submenu_page('limited_mm_list_page','User', 'User',  'administrator', 'limited_mm_user', array($this, 'admin_page_user') );
        //$access = add_submenu_page('limited_mm_list_page','User access rights', 'User access rights',  'administrator', 'limited_mm_user_access_rights', array($this, 'admin_page_user_access_rights') );
    }
    public function slider_page_display(){
        $this->view->show('admin.index',
            ['key'=>'cold-storage', 'title'=>'Slider']);
    }

    public function cold_storage_page_display(){
        $this->view->show('admin.index',
            ['key'=>'slider_options', 'title'=>'Slider']);
    }
}