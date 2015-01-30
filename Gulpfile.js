require("coffee-script/register");
var argv = require('minimist')(process.argv.slice(2));
var config = require('./gulp/config');

config.environment = argv.env || argv.d && 'debug' || argv.p && 'production' || process.env;
config.browsersync.proxy = argv.proxy;

if(argv.dest)
{
    config.destBase = argv.dest;
}

require("require-dir")("./gulp", { recurse: true });

