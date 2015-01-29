gulp = require 'gulp'
changed = require 'gulp-changed'
config = require './config'

gulp.task 'assets', ->
    for files in config.assets
        gulp.src(files.src)
        .pipe(changed(files.dest))
        .pipe(gulp.dest(files.dest))