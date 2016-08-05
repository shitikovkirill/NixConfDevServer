<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 01.08.16
 * Time: 20:39
 */

namespace Cold\Controllers;


use Amostajo\LightweightMVC\Controller;

class TwigController extends Controller
{
   public function add_to_twig($twig){

       $function = new \Twig_SimpleFunction('about_get_option', function ($key=''){
          return about_get_option($key);
       });
       $twig->addFunction($function);

       return $twig;
   }
}