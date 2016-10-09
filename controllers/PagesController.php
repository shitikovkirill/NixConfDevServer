<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 09.10.16
 * Time: 11:11
 */

namespace Cold\Controllers;


use Amostajo\LightweightMVC\Controller;

class PagesController extends Controller
{
    public function add_shortcode_to_all_page($content)
    {
        if(is_single()) {
            $content.= '<div class="calendar-asc" style="">';
            $content.= do_shortcode('[APCAL_MOBILE]');
            $content.= '</div>';
        }
        return $content;
    }
}