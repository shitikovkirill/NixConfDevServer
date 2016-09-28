<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 02.08.16
 * Time: 5:52
 */

namespace Cold\Classes;

use Symfony\Component\Form\Extension\Core\Type\DateType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Forms;

class SliderWidget extends \WP_Widget
{
    public function __construct(){
        parent::__construct(
            'cols-storage-slider', 'Home: Slider', array(
                'description' => __('A widget that shows sliders', 'cold-storage')
            )
        );
    }
    
    public function widget($args, $instance) {
        $context = \Timber::get_context();

        $slider = get_option('slider_options');
        $context['slider'] = $slider['demo'];
        /*var_dump($slider);die;*/
        $templates = 'widget/form/slider.twig';
        \Timber::render( $templates, $context);
    }

    public function form($instance) {
        echo '<p><a href="/wp-admin/admin.php?page=slider_options">Link to the settings page</a></p>';
    }
}