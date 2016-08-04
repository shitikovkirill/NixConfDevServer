<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 03.08.16
 * Time: 6:31
 */

namespace Cold\Classes;


class TopWidget extends \WP_Widget {

    public function __construct(){
        parent::__construct(
            'cols-storage-top', 'Home: Top', array(
                'description' => __('for top section', 'cold-storage')
            )
        );
    }

    function form( $instance ) {
        if ( $instance ) {
            $title = $instance['title'];
            $icon = $instance['icon'];
            $description = $instance['description'];
            $link = $instance['link'];
        }
        else {
            $description='';
            $title = '';
            $icon='fa-thumbs-o-up';
            $link = '';
        }
        ?>

        <p xmlns="http://www.w3.org/1999/html">
            <label for="<?php echo $this->get_field_id( 'title' ); ?>"><?php esc_html_e( 'Title:' , 'cold-storage'); ?></label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'title' ); ?>" name="<?php echo $this->get_field_name( 'title' ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
        </p>
        <p>
            <label for="<?php echo $this->get_field_id( 'icon' ); ?>"><?php esc_html_e( 'Icon:' , 'cold-storage'); ?></label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'icon' ); ?>" name="<?php echo $this->get_field_name( 'icon' ); ?>" type="text" value="<?php echo esc_attr( $icon ); ?>" />
        </p>
        <p>
            <label for="<?php echo $this->get_field_id( 'description' ); ?>"><?php esc_html_e( 'Description:' , 'cold-storage'); ?></label>
            <textarea class="widefat" rows="8" cols="20" id="<?php echo $this->get_field_id('description'); ?>" name="<?php echo $this->get_field_name('description'); ?>"><?php echo esc_textarea( $description ); ?></textarea></p>
        </p>
        <p>
            <label for="<?php echo $this->get_field_id( 'link' ); ?>"><?php esc_html_e( 'Link:' , 'cold-storage'); ?></label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'link' ); ?>" name="<?php echo $this->get_field_name( 'link' ); ?>" type="text" value="<?php echo esc_attr( $link ); ?>" />
        </p>
        <?php
    }

    function update( $new_instance, $old_instance ) {
        $instance['title'] = strip_tags( $new_instance['title'] );
        $instance['icon'] = strip_tags( $new_instance['icon'] );
        $instance['description'] = strip_tags( $new_instance['description'] );
        $instance['link'] = strip_tags( $new_instance['link'] );
        return $instance;
    }

    function widget( $args, $instance ) {
        $instance['args']=$args;
        $templates = 'widget/form/top.twig';
        \Timber::render( $templates, $instance);
    }
}

