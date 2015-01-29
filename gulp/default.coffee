gulp = require 'gulp'
runSequence = require 'run-sequence'

gulp.task 'default', ->
    runSequence(['clean', 'bower', 'config'], ['browserify', 'sass', 'assets', 'html'])