gulp = require 'gulp'
sass = require 'gulp-sass'
plumber = require 'gulp-plumber'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
gulpif = require 'gulp-if'
cssmin = require 'gulp-minify-css'
newer = require 'gulp-newer'
graph = require 'sass-graph'
touch = require 'touch'
path = require 'path'
_ = require 'lodash'

g = undefined

gulp.task 'sass', ->
    config = require './config'
    gulp.src(config.sass.src)
    .pipe(plumber())
    .pipe(newer(dest: config.sass.dest, ext: '.css'))
    .pipe(sass(config.sass.config))
    .pipe(autoprefixer(config.autoprefixer))
    .pipe(gulpif(config.environment == 'production', concat('main.css')))
    .pipe(gulpif(config.environment == 'production', cssmin(config.cssmin)))
    .pipe(gulp.dest(config.sass.dest))

    g = graph.parseDir(path.dirname(path.dirname(config.sass.src)))

module.exports.watch = (e) ->
    if e.path in g.index
        subgraph = graph.parseFile(e.path)
        g.loadPaths = _.union(g.loadPaths, subgraph.loadPaths)
        oldImports = _.without(g.index[e.path].imports, subgraph.index.imports)
        newImports = _.without(subgraph.index.imports, g.index[e.path].imports)
        g.index[e.path].imports = subgraph.index.imports
        for file in oldImports
            _.pull(g.index[file].importedBy, e.path)
        for file in newImports
            g.index[file].push(e.path)
        for own file, props of g.index
            if file in subgraph.index.imports and file not in props.importedBy
                props.importedBy.push(file)
    g.visitAncestors(e.path, touch.sync)
    gulp.run('sass')