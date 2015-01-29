gulp = require 'gulp'
coffeelint = require 'gulp-coffeelint'
config = require './config'

gulp.task 'coffeelint', ->
    gulp.src(config.coffeelint.src)
    .pipe(coffeelint(config.coffeelint.config))
    .pipe(coffeelint.reporter())