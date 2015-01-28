gulp = require 'gulp'
del = require 'del'
config = require './config'

gulp.task 'clean', ['config'], ->
    del.sync(config.destBase, {force: true});
