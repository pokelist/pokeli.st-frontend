gulp = require 'gulp'
browsersync = require 'browser-sync'
config = require './config'

gulp.task 'browsersync', ['watch'], ->
    browsersync(config.browsersync)