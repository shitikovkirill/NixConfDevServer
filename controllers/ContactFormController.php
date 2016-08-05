<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 05.08.16
 * Time: 15:35
 */

namespace Cold\Controllers;


use Amostajo\LightweightMVC\Controller;
use Katzgrau\KLogger\Logger;

class ContactFormController extends Controller
{
    public function showForm(){
        wp_enqueue_style('form_css', get_template_directory_uri().'/css/form.css');
        wp_enqueue_script(
            'jTMForm',
            get_template_directory_uri().'/js/TMForm.js',
            ['jquery']
        );
        wp_localize_script('jTMForm', 'myajax',
            array(
                'url' => admin_url('admin-ajax.php')
            )
        );
        return $this->view->get('page.contacts.form');
    }
    
    public function sendMail(){
        
        $blog_name = get_option('blogname');
        $url = get_option('siteurl');
        $admin_email = get_option('admin_email');
        $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
        $name  = filter_input(INPUT_POST, 'name', FILTER_SANITIZE_STRING);
        $message = filter_input(INPUT_POST, 'message', FILTER_SANITIZE_STRING);
        $phone = filter_input(INPUT_POST, 'phone', FILTER_SANITIZE_STRING);

        $html = $this->view->get('page.contacts.email', [
            'blog_name'=>$blog_name,
            'url' => $url,
            'email'=>$email,
            'name'=>$name,
            'message'=>$message,
            'phone' =>$phone
        ]);

        $headers = array('Content-Type: text/html; charset=UTF-8');
        
        $res = wp_mail($admin_email, 'Email from '.$name.'.', $html, $headers);
        $logger = new Logger(__DIR__.'/../logs');
        $logger -> info('Send mail:',[$blog_name, $url, $admin_email, $email, $name, $message, $phone, 'result'=>$res]);
        $this->view->show('page.contacts.letter');
        die;
    }
}