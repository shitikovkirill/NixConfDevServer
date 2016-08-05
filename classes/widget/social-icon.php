<?php
/**
 * Plugin Name: CMB2 Widget Boilerplate
 * Description: A boilerplate for building widgets with CMB2. Early alpha version. NEEDS WORK.
 */

// Exit if accessed directly
if ( ! defined ( 'ABSPATH' ) ) {
	exit;
}

/**
 * @todo Properly hook in JS events, etc. Fields which require JS are not working.
 * @todo Fix css styling. Probably needs a sep. CSS file enqueued for widgets.
 */
class SocialIcon extends WP_Widget {

	/**
	 * Unique identifier for this widget.
	 *
	 * Will also serve as the widget class.
	 *
	 * @var string
	 */
	protected $widget_slug = 'social-icon-slug';

	/**
	 * Shortcode name for this widget
	 *
	 * @var string
	 */
	protected static $shortcode = 'cmb2_widget_social_icon';

	/**
	 * This widget's CMB2 instance.
	 *
	 * @var CMB2
	 */
	protected $cmb2 = null;

	/**
	 * Array of default values for widget settings.
	 *
	 * @var array
	 */
	protected static $defaults = array();

	/**
	 * Store the instance properties as property
	 *
	 * @var array
	 */
	protected $_instance = array();

	/**
	 * Array of CMB2 fields args.
	 *
	 * @var array
	 */
	protected $cmb2_fields = array();

	/**
	 * Contruct widget.
	 */
	public function __construct() {

		parent::__construct(
			$this->widget_slug,
			esc_html__( 'Home: Social icon', 'your-textdomain' ),
			array(
				'classname' => $this->widget_slug,
				'customize_selective_refresh' => true,
				'description' => esc_html__( 'Add social icon in footer', 'cold-storage' ),
			)
		);

		$this->cmb2_fields = array(
			array(
				'id_key' => 'facebook',
				'id'     => 'facebook',
				'description' => esc_html__( 'Facebook url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'twitter',
				'id'     => 'twitter',
				'description' => esc_html__( 'Twitter url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'pinterest',
				'id'     => 'pinterest',
				'description' => esc_html__( 'Pinterest url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'instagram',
				'id'     => 'instagram',
				'description' => esc_html__( 'Instagram url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'google',
				'id'     => 'google',
				'description' => esc_html__( 'Google url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'skype',
				'id'     => 'skype',
				'description' => esc_html__( 'Skype url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'vimeo',
				'id'     => 'vimeo',
				'description' => esc_html__( 'Vimeo url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'youtube',
				'id'     => 'youtube',
				'description' => esc_html__( 'Youtube url', 'cold-storage' ),
				'type'   => 'text_url',
			),
			array(
				'id_key' => 'rss',
				'id'     => 'rss',
				'description' => esc_html__( 'Rss url', 'cold-storage' ),
				'type'   => 'text_url',
			),
		);

		add_action( 'save_post',    array( $this, 'flush_widget_cache' ) );
		add_action( 'deleted_post', array( $this, 'flush_widget_cache' ) );
		add_action( 'switch_theme', array( $this, 'flush_widget_cache' ) );
		add_shortcode( self::$shortcode, array( __CLASS__, 'get_widget' ) );
	}

	/**
	 * Delete this widget's cache.
	 *
	 * Note: Could also delete any transients
	 * delete_transient( 'some-transient-generated-by-this-widget' );
	 */
	public function flush_widget_cache() {
		wp_cache_delete( $this->id, 'widget' );
	}

	/**
	 * Front-end display of widget.
	 *
	 * @param  array  $args      The widget arguments set up when a sidebar is registered.
	 * @param  array  $instance  The widget settings as set by user.
	 */
	public function widget( $args, $instance ) {

		echo self::get_widget( array_merge(
			$args, $instance, [$this->id] // whatever the widget id is
		) );

	}

	/**
	 * Return the widget/shortcode output
	 *
	 * @param  array  $atts Array of widget/shortcode attributes/args
	 * @return string       Widget output
	 */
	public static function get_widget( $atts ) {
		$instance=$atts;
		$templates = 'part/footer/socials.twig';
		\Timber::render( $templates, $instance);
	}

	/**
	 * Update form values as they are saved.
	 *
	 * @param  array  $new_instance  New settings for this instance as input by the user.
	 * @param  array  $old_instance  Old settings for this instance.
	 * @return array  Settings to save or bool false to cancel saving.
	 */
	public function update( $new_instance, $old_instance ) {
		$this->flush_widget_cache();
		$sanitized = $this->cmb2( true )->get_sanitized_values( $new_instance );
		return $sanitized;
	}
	/**
	 * Back-end widget form with defaults.
	 *
	 * @param  array  $instance  Current settings.
	 */
	public function form( $instance ) {
		// If there are no settings, set up defaults
		$this->_instance = wp_parse_args( (array) $instance, self::$defaults );

		$cmb2 = $this->cmb2();

		$cmb2->object_id( $this->option_name );
		CMB2_hookup::enqueue_cmb_css();
		CMB2_hookup::enqueue_cmb_js();
		$cmb2->show_form();
	}

	/**
	 * Creates a new instance of CMB2 and adds some fields
	 * @since  0.1.0
	 * @return CMB2
	 */
	public function cmb2( $saving = false ) {

		// Create a new box in the class
		$cmb2 = new CMB2( array(
			'id'      => $this->option_name .'_box', // Option name is taken from the WP_Widget class.
			'hookup'  => false,
			'show_on' => array(
				'key'   => 'options-page', // Tells CMB2 to handle this as an option
				'value' => array( $this->option_name )
			),
		), $this->option_name );

		foreach ( $this->cmb2_fields as $field ) {

			if ( ! $saving ) {
				$field['id'] = $this->get_field_name( $field['id'] );
			}

			$field['default_cb'] = array( $this, 'default_cb' );

			$cmb2->add_field( $field );
		}

		return $cmb2;
	}

	/**
	 * Sets the field default, or the field value.
	 *
	 * @param  array      $field_args CMB2 field args array
	 * @param  CMB2_Field $field CMB2 Field object.
	 *
	 * @return mixed      Field value.
	 */
	public function default_cb( $field_args, $field ) {
		return isset( $this->_instance[ $field->args( 'id_key' ) ] )
			? $this->_instance[ $field->args( 'id_key' ) ]
			: null;
	}

}

/**
 * Register this widget with WordPress.
 */
function register_wds_widget_boilerplate() {
	register_widget( 'SocialIcon' );
}
add_action( 'widgets_init', 'register_wds_widget_boilerplate' );
