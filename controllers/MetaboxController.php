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
    public function slider(){
        $option_page = 'slider_options';
        /**
         * Repeatable Field Groups
         */
        $cmb_group = new_cmb2_box( array(
            'id'           => $option_page,
            'title'        => __( 'Repeating Field Group', 'cmb2' ),
            'hookup'  => false, // Do not need the normal user/post hookup
            'show_on' => array(
                // These are important, don't remove
                'key'   => 'options-page',
                'value' => array( $option_page )
            ),
        ) );

        // $group_field_id is the field id string, so in this case: 'demo'
        $group_field_id = $cmb_group->add_field( array(
            'id'          => 'demo',
            'type'        => 'group',
            'description' => __( 'Generates reusable form entries', 'cmb2' ),
            'options'     => array(
                'group_title'   => __( 'Slider {#}', 'cmb2' ), // {#} gets replaced by row number
                'add_button'    => __( 'Add Another Slider', 'cmb2' ),
                'remove_button' => __( 'Remove Slider', 'cmb2' ),
                'sortable'      => true, // beta
                // 'closed'     => true, // true to have the groups closed by default
            ),
        ) );

        /**
         * Group fields works the same, except ids only need
         * to be unique to the group. Prefix is not needed.
         *
         * The parent field's id needs to be passed as the first argument.
         */
        $cmb_group->add_group_field( $group_field_id, array(
            'name'       => __( 'Title', 'cmb2' ),
            'id'         => 'title',
            'type'       => 'text',
            // 'repeatable' => true, // Repeatable fields are supported w/in repeatable groups (for most types)
        ) );

        $cmb_group->add_group_field( $group_field_id, array(
            'name'        => __( 'Description', 'cmb2' ),
            'description' => __( 'Write a short description for this entry', 'cmb2' ),
            'id'          => 'description',
            'type'        => 'textarea_small',
        ) );

        $cmb_group->add_group_field( $group_field_id, array(
            'name' => __( 'Image', 'cmb2' ),
            'id'   => 'image',
            'type' => 'file',
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
}