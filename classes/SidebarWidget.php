<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 03.08.16
 * Time: 6:31
 */

namespace Cold\Classes;


class SidebarWidget extends \WP_Widget {

    public function __construct(){
        parent::__construct(
            'cols-storage-sidebar', 'Home: Sidebar', array(
                'description' => __('for top section', 'cold-storage')
            )
        );
    }

    function form( $instance ) {
        if ( $instance ) {
            $title = $instance['title'];
            $image = $instance['image'];
            $description = $instance['description'];
            $link = $instance['link'];
        }
        else {
            $description='';
            $title = '';
            $image = get_template_directory_uri().'/images/page1_img1.jpg';
            $link = '';
        }
        ?>

        <p xmlns="http://www.w3.org/1999/html">
            <label for="<?php echo $this->get_field_id( 'title' ); ?>"><?php esc_html_e( 'Title:' , 'cold-storage'); ?></label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'title' ); ?>" name="<?php echo $this->get_field_name( 'title' ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
        </p>
        <p>
            <label for="<?php echo $this->get_field_id( 'image' ); ?>"><?php esc_html_e( 'Image:' , 'cold-storage'); ?></label>
            <input class="widefat" id="<?php echo $this->get_field_id( 'image' ); ?>" name="<?php echo $this->get_field_name( 'image' ); ?>" type="text" value="<?php echo esc_attr( $image ); ?>" />
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
        $instance['image'] = strip_tags( $new_instance['image'] );
        $instance['description'] = strip_tags( $new_instance['description'] );
        $instance['link'] = strip_tags( $new_instance['link'] );
        return $instance;
    }

    function widget( $args, $instance ) {
        $instance['args']=$args;
        $templates = 'widget/form/sidebar.twig';
        \Timber::render( $templates, $instance);
    }
}

