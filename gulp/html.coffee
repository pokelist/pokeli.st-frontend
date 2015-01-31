gulp = require 'gulp'
inject = require 'gulp-inject'
gulpif = require 'gulp-if'
htmlmin = require 'gulp-htmlmin'
path = require 'path'
browsersync = require 'browser-sync'
config = require './config'

gulp.task 'html', ['browserify', 'sass'], ->
    gulp.src(config.html.src)
    .pipe(inject(gulp.src([path.join(config.browserify.dest, '**', '*.js'),
                           path.join(config.sass.dest, '**', '*.css')], read: false, cwd: config.destBase)))
    .pipe(gulpif(config.environment == 'production', htmlmin(config.htmlmin)))
    .pipe(gulp.dest(config.html.dest))
    .pipe(gulpif(browsersync.active, browsersync.reload(stream: true)))
