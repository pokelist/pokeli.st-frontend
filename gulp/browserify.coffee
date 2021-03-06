gulp = require 'gulp'
plumber = require 'gulp-plumber'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffeeify = require 'coffeeify'
debowerify = require 'debowerify'
hbsfy = require 'hbsfy'
_ = require 'lodash'
gulpif = require 'gulp-if'
uglify = require 'gulp-uglify'
buffer = require 'vinyl-buffer'
path = require 'path'
browsersync = require 'browser-sync'
config = require './config'

# TODO: work with more than one entry point

gulp.task 'browserify', ->
    browserify(config.browserify.src, config.browserify.config)
    .transform(coffeeify)
    .transform(debowerify)
    .transform(hbsfy)
    .bundle()
    .pipe(plumber())
    .pipe(source(path.basename(config.browserify.src, path.extname(config.browserify.src))+'.js'))
    .pipe(buffer())
    .pipe(gulpif(config.environment == 'production', uglify(config.uglify)))
    .pipe(gulp.dest(config.browserify.dest))
    .pipe(gulpif(browsersync.active, browsersync.reload(stream: true)))
