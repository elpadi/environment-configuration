<?php
define('WP_CONTENT_DIR', dirname(__DIR__).'/wp-content');
if (isset($_SERVER['HTTP_HOST'])) define('WP_CONTENT_URL', 'http://'.$_SERVER['HTTP_HOST'].'/wp-content');
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'database_name_here');

/** MySQL database username */
define('DB_USER', 'username_here');

/** MySQL database password */
define('DB_PASSWORD', 'password_here');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
//define('WP_DEBUG', false);
if (is_file(__DIR__.'/vendor/autoload.php')) include(__DIR__.'/vendor/autoload.php');
define('IS_LOCAL', isset($_SERVER['HTTP_HOST']) && strpos($_SERVER['HTTP_HOST'], 'localhost') !== FALSE);

if (IS_LOCAL) define('WP_DEBUG', true);
else call_user_func(function() {
	define('PRINT_ERROR_TRACE', FALSE);
	$DEBUG_VAL = 'wp_debug_cookie_value';
	$DEBUG_KEY = 'wp_debug_cookie_key';
	if (isset($_COOKIE[$DEBUG_KEY]) && $_COOKIE[$DEBUG_KEY] == $DEBUG_VAL) {
		ini_set('error_log', __DIR__.'/errors.log');
		set_error_handler(function($errno, $errstr, $errfile, $errline) {
			if (IS_LOCAL && strpos($errfile, 'update.php') !== FALSE) return;
			if (function_exists('dump')) dump(func_get_args(), PRINT_ERROR_TRACE ? debug_backtrace() : NULL);
			else var_dump(func_get_args(), PRINT_ERROR_TRACE ? debug_backtrace() : NULL);
			error_log("$errfile:$errline (Error $errno) $errstr");
		});
		ini_set('display_startup_errors','1');
		ini_set('display_errors','1');
		error_reporting(-1);
		clearstatcache();
		define('WP_DEBUG', true);
	}
	else define('WP_DEBUG', false);
});

if (IS_LOCAL) {
	define('AUTOMATIC_UPDATER_DISABLED', TRUE);
}

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
