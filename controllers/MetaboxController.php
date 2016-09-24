<?php
/**
 * Created by PhpStorm.
 * User: kirill
 * Date: 02.08.16
 * Time: 6:19
 */

namespace Cold\Controllers;


class MetaboxController
{
    public function services_slider(){

        $cmb = new_cmb2_box( array(
            'id'         => 'services_slider',
            'title'        => 'Services Metabox',
            'object_types' => array( 'page' ), // post type
            'context'      => 'normal', //  'normal', 'advanced', or 'side'
            'priority'     => 'high',  //  'high', 'core', 'default' or 'low'
            'show_names'   => true, // Show field names on the left
            'show_on'    => array(
                // These are important, don't remove
                'key'   => 'template',
                'value' => 'services'
            ),
        ) );

        // Set our CMB2 fields

        $group_field_id = $cmb->add_field( array(
            'id'          => 'services',
            'type'        => 'group',
            'name'=>'Services',
            'options'     => array(
                'group_title'   => __( 'Entry {#}', 'cmb2' ), // {#} gets replaced by row number
                'add_button'    => __( 'Add Another Entry', 'cmb2' ),
                'remove_button' => __( 'Remove Entry', 'cmb2' ),
                'sortable'      => true, // beta
                // 'closed'     => true, // true to have the groups closed by default
            ),
        ) );

        // Set our CMB2 fields
        $cmb->add_group_field( $group_field_id, array(
            'name' => __( 'Foto', 'cmb2' ),
            'id'   => 'image',
            'type' => 'file',
        ) );

        $cmb->add_group_field($group_field_id, array(
            'name' => __( 'Title', 'about' ),
            'id'   => 'text',
            'type' => 'text',
        ) );

        $cmb->add_group_field($group_field_id,array(
            'id'     => 'link',
            'description' => esc_html__( 'Link', 'cold-storage' ),
            'type'   => 'text_url',
        ));

        $cmb->add_group_field( $group_field_id, array(
            'name'        => __( 'Text', 'cmb2' ),
            'id'          => 'description',
            'type'        => 'textarea',
        ) );
    }

    public function about_field(){
        $cmb = new_cmb2_box( array(
            'id'         => 'about_personal',
            'title'        => 'About Metabox',
            'object_types' => array( 'page' ), // post type
            'context'      => 'normal', //  'normal', 'advanced', or 'side'
            'priority'     => 'high',  //  'high', 'core', 'default' or 'low'
            'show_names'   => true, // Show field names on the left
            'show_on'    => array(
                // These are important, don't remove
                'key'   => 'template',
                'value' => 'about'
            ),
        ) );

        $group_field_id = $cmb->add_field( array(
            'id'          => 'about_person',
            'type'        => 'group',
            'name'=>'Person',
            'options'     => array(
                'group_title'   => __( 'Entry {#}', 'cmb2' ), // {#} gets replaced by row number
                'add_button'    => __( 'Add Another Entry', 'cmb2' ),
                'remove_button' => __( 'Remove Entry', 'cmb2' ),
                'sortable'      => true, // beta
                // 'closed'     => true, // true to have the groups closed by default
            ),
        ) );

        // Set our CMB2 fields
        $cmb->add_group_field( $group_field_id, array(
            'name' => __( 'Foto', 'cmb2' ),
            'id'   => 'image',
            'type' => 'file',
        ) );

        $cmb->add_group_field($group_field_id, array(
            'name' => __( 'Name', 'about' ),
            'id'   => 'text',
            'type' => 'text',
        ) );

        $cmb->add_group_field($group_field_id,array(
            'id'     => 'link',
            'description' => esc_html__( 'Link', 'cold-storage' ),
            'type'   => 'text_url',
        ));

        $cmb->add_group_field( $group_field_id, array(
            'name'        => __( 'Text', 'cmb2' ),
            'id'          => 'description',
            'type'        => 'textarea',
        ) );

        $group_field_id_2 = $cmb->add_field( array(
            'id'          => 'about_testimonials',
            'type'        => 'group',
            'name' 		  => 'Testimonials',
            'options'     => array(
                'group_title'   => __( 'Entry {#}', 'cmb2' ), // {#} gets replaced by row number
                'add_button'    => __( 'Add Another Entry', 'cmb2' ),
                'remove_button' => __( 'Remove Entry', 'cmb2' ),
                'sortable'      => true, // beta
                // 'closed'     => true, // true to have the groups closed by default
            ),
        ) );

        $cmb->add_group_field($group_field_id_2, array(
            'name' => __( 'Name', 'about' ),
            'id'   => 'text',
            'type' => 'text',
        ) );

        $cmb->add_group_field( $group_field_id_2, array(
            'name'        => __( 'Text', 'cmb2' ),
            'id'          => 'description',
            'type'        => 'textarea',
            'before' => '"... ',
            'after'  => ' ..."',
        ) );
    }

    public function be_metabox_show_on_template( $display, $meta_box ) {

        if ( ! isset( $meta_box['show_on']['key'], $meta_box['show_on']['value'] ) ) {
            return $display;
        }

        if ( 'template' !== $meta_box['show_on']['key'] ) {
            return $display;
        }

        $post_id = 0;

        // If we're showing it based on ID, get the current ID
        if ( isset( $_GET['post'] ) ) {
            $post_id = $_GET['post'];
        } elseif ( isset( $_POST['post_ID'] ) ) {
            $post_id = $_POST['post_ID'];
        }

        if ( ! $post_id ) {
            return false;
        }

        $template_name = get_page_template_slug( $post_id );
        $template_name = ! empty( $template_name ) ? substr( $template_name, 0, -4 ) : '';
        // See if there's a match
        return in_array( $template_name, (array) $meta_box['show_on']['value'] );
    }
}