gulp = require 'gulp'
_ = require 'lodash'
path = require 'path'

config =
    destBase: path.join(__dirname, '..', 'dist')
    srcBase: path.join(__dirname, '..', 'src')
    pathsBase: path.join(__dirname, '..')
    filesBase: path.join(__dirname, '..', 'src')
    debug: true
    browserify:
        config:
            extensions: ['.coffee', '.hbs']
            paths: ['src', 'src/js', 'node_modules']
            noParse: [path.join(__dirname, '..', 'bower_components', 'materialize', 'bin', 'materialize.js')]
        src: 'js/main.coffee'
        dest: 'js'
    sass:
        src: 'styles/**/*.{sass,scss}'
        dest: 'styles'
        config: {}
    assets: [
        { src: 'assets/**/*', dest: 'assets' }
        { src: '../bower_components/materialize/font/**/*', dest: 'font' }
    ]
    html:
        src: 'index.html'
        dest: ''
    cssmin:
        keepSpecialComments: 0
    htmlmin:
        collapseWhitespace: true
    coffeelint:
        src: 'js/**/*.coffee'
    sasslint:
        src: 'styles/**/*.{sass,scss}'
    watch: [
        { files: ['styles/**/*.{sass,scss}'], tasks: [require('./sass').watch, 'sasslint']}
        { files: ['js/**/*.coffee'], tasks: ['browserify', 'coffeelint']}
        { files: ['templates/**/*.hbs'], tasks: ['browserify']}
        { files: ['assets/**/*'], tasks: ['assets']}
        { files: ['index.html'], tasks: ['html']}
    ]
    browsersync:
        proxy: 'http://localhost:1337'

pathProperties = ['dest', 'src', 'paths', 'files']

join = (base, ext) ->
    if ext.charAt(0) == '!'
        '!' + path.join(base, ext.substring(1))
    else
        path.join(base, ext)

initialize = (obj) ->
    for own key, val of obj
        if key in pathProperties
            if _.isString(val)
                obj[key] = join(config[key+"Base"], val)
            else if _.isArray(val)
                obj[key] = _.map(val, (name) -> join(config[key+"Base"], name))
        else if _.isPlainObject(val)
            initialize(val)
        else if _.isArray(val)
            initialize(e) for e in val
    undefined

gulp.task 'config', ->
    initialize(config)

module.exports = config