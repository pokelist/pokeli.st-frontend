gulp = require 'gulp'
plumber = require 'gulp-plumber'
scsslint = require 'gulp-scsslint'
config = require './config'

gulp.task 'sasslint', ->
    gulp.src(config.sasslint.src)
    .pipe(scsslint(config.sasslint.config))
    .pipe(scsslint.reporter())