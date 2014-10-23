gulp   = require "gulp"
merge  = require "merge-stream"
coffee = require "gulp-coffee"
less   = require "gulp-less"

# ==================
# == ENTRY POINTS ==
# ==================

getFiles =
    coffee: ->
        gulp.src "./src/js/**/*.coffee"
    js: ->
        gulp.src "./src/js/**/*.js"
    less: ->
        gulp.src "./src/styles/**/*.less"
    css: ->
        gulp.src "./src/styles/**/*.css"
    html: ->
        gulp.src "./src/*.html"

# ==================
# == DESTINATIONS ==
# ==================

store =
    js: ->
        gulp.dest "./build/js"
    css: ->
        gulp.dest "./build/styles"
    html: ->
        gulp.dest "./build"

# ===================
# == COMPILE FILES ==
# ===================

compile =
    coffee: ->
        getFiles.coffee()
        .pipe(coffee())
    js: ->
        merge(
            compile.coffee()
            getFiles.js()
        )
    less: ->
        getFiles.less()
        .pipe(less())
    css: ->
        merge(
            compile.less()
            getFiles.css()
        )
    html: ->
        getFiles.html()

# =======================
# == DEVELOPMENT TASKS ==
# =======================

gulp.task "jsDev", ->
    compile.js()
    .pipe(store.js())

gulp.task "cssDev", ->
    compile.css()
    .pipe(store.css())

gulp.task "htmlDev", ->
    compile.html()
    .pipe(store.html())

gulp.task "default", ["jsDev", "cssDev", "htmlDev"]
