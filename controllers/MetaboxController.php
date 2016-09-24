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

    public function head(){
        $option_key = 'cold-storage';

        /**
         * Metabox for an options page. Will not be added automatically, but needs to be called with
         * the `cmb2_metabox_form` helper function. See wiki for more info.
         */
        $cmb_options = new_cmb2_box( array(
            'id'      => $option_key,
            'title'   => __( 'Theme Options Metabox', 'cmb2' ),
            'hookup'  => false, // Do not need the normal user/post hookup
            'show_on' => array(
                // These are important, don't remove
                'key'   => 'options-page',
                'value' => array( $option_key )
            ),
        ) );

        /**
         * Options fields ids only need
         * to be unique within this option group.
         * Prefix is not needed.
         */
        $cmb_options->add_field( array(
            'name' => __( 'Logo', 'cmb2' ),
            'desc' => __( 'Upload an image or enter a URL.', 'cmb2' ),
            'id'   => 'logo',
            'type' => 'file',
        ) );
        $cmb_options->add_field( array(
            'name' => __( 'Text near phone', 'cmb2' ),
            'id'   => 'text_phone',
            'type' => 'text_medium',
            // 'repeatable' => true,
        ) );
        $cmb_options->add_field( array(
            'name' => __( 'Phone number', 'cmb2' ),
            'id'   => 'phone',
            'type' => 'text_medium',
            // 'repeatable' => true,
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