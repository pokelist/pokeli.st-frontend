gulp = require 'gulp'
_ = require 'lodash'
config = require './config'

gulp.task 'watch', ['default'], ->
    for task in config.watch
        cleantasks = []
        for e in task.tasks
            if _.isString(e)
                cleantasks.push(e)
            else if _.isFunction(e)
                gulp.watch(task.files, e)
        gulp.watch(task.files, cleantasks)