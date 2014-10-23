gulp     = require "gulp"
_        = require "lodash"
merge    = require "merge-stream"
cached   = require "gulp-cached"
remember = require "gulp-remember"
watch    = require "gulp-watch"
plumber  = require "gulp-plumber"
clean    = require "gulp-clean"
coffee   = require "gulp-coffee"
less     = require "gulp-less"
bower    = require "gulp-bower"

transformDict = (dict, transform) ->
    for key, val of dict
        dict[key] = transform(val)
    dict

registerTask = (name, arg1, arg2) ->
    watchName = (name) -> if name != "default" then "watch-#{name}" else "watch"
    if _.isArray(arg1)
        deps = arg1
        fn   = arg2 or ->
    else
        deps = []
        fn   = arg1
    gulp.task name, deps, fn(false)
    gulp.task watchName(name), _.map(deps, watchName), fn(true)


config =
    sourceDirectory: "./src/"
    buildDirectory: "./build/"

# ==================
# == ENTRY POINTS ==
# ==================

getFiles = transformDict(
    coffee: "js/**/*.coffee"
    js: "js/**/*.js"
    less: "styles/**/*.less"
    css: "styles/**/*.css"
    html: "*.html"
    (val) -> (isWatch) ->
        path = "#{config.sourceDirectory}#{val}"
        src = gulp.src path, base: config.sourceDirectory
        if isWatch then src = src.pipe(watch(path)).pipe(plumber())
        src
)

# ==================
# == DESTINATIONS ==
# ==================

store = transformDict(
    js: ""
    css: ""
    html: ""
    (val) -> ->
        gulp.dest "#{config.buildDirectory}#{val}"
)

# ===================
# == COMPILE FILES ==
# ===================

compile =
    coffee: (isWatch) ->
        getFiles.coffee(isWatch)
        .pipe(cached("coffee"))
        .pipe(coffee())
        .pipe(remember("coffee"))
    js: (isWatch) ->
        merge(
            compile.coffee(isWatch)
            getFiles.js(isWatch)
        )
    less: (isWatch) ->
        getFiles.less(isWatch)
        .pipe(less())
    css: (isWatch) ->
        merge(
            compile.less(isWatch)
            getFiles.css(isWatch)
        )
    html: (isWatch) ->
        getFiles.html(isWatch)

# =================
# == CLEAN TASKS ==
# =================

registerTask "clean", -> ->
    gulp.src config.buildDirectory, read: false
    .pipe(clean())

# =======================
# == DEVELOPMENT TASKS ==
# =======================

registerTask "js-dev", ["clean", "bower"], (isWatch) -> ->
    compile.js(isWatch)
    .pipe(store.js())

registerTask "css-dev", ["clean", "bower"], (isWatch) -> ->
    compile.css(isWatch)
    .pipe(store.css())

registerTask "html-dev", ["clean"], (isWatch) -> ->
    compile.html(isWatch)
    .pipe(store.html())

registerTask "bower", (isWatch) -> ->
    bower().
    pipe(gulp.dest("#{config.sourceDirectory}vendor"))

registerTask "default", ["js-dev", "css-dev", "html-dev"]
