gulp = require 'gulp'
bower = require 'gulp-bower'
path = require 'path'
fs = require 'fs'
config = require './config'

gulp.task 'bower', ->
    bower() unless fs.existsSync(path.join(config.srcBase, '..', 'bower_components'))