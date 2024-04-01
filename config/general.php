<?php

/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 *
 * @see \craft\config\GeneralConfig
 */

use craft\helpers\App;
use craft\config\GeneralConfig;

$isDev = App::env('CRAFT_ENVIRONMENT') == 'local';
$isProd = App::env('CRAFT_ENVIRONMENT') == 'production';

return GeneralConfig::create()
    // Default Week Start Day (0 = Sunday, 1 = Monday...)
    ->defaultWeekStartDay(1)
    // Disable GraphQL. Set to true or remove this setting (the default is true) in order to use GraphQL features
    ->enableGql(false)
    // Whether generated URLs should omit "index.php"
    ->omitScriptNameInUrls()
    // Whether Dev Mode should be enabled (see https://craftcms.com/guides/what-dev-mode-does)
    ->devMode($isDev)
    // Whether administrative changes should be allowed
    ->allowAdminChanges($isDev)
    // Whether crawlers should be allowed to index pages and following links
    ->disallowRobots(!$isProd)
    // https://craftcms.com/docs/3.x/config/config-settings.html#limitautoslugstoascii
    ->limitAutoSlugsToAscii(true)
    // https://craftcms.com/docs/3.x/config/config-settings.html#convertfilenamestoascii
    ->convertFilenamesToAscii(true)
    // https://craftcms.com/docs/3.x/config/#aliases
    ->aliases([
        '@web' => rtrim(App::env('PRIMARY_SITE_URL'), '/'),
        '@webroot' => dirname(__DIR__) . '/web',
    ])
    ->sendPoweredByHeader(false);