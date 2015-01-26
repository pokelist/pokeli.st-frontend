require 'materialize'
Pokelist = require 'application'
routes = require 'routes'
$ = require 'jquery'

$ ->
    new Pokelist {
        title: 'Pokelist'
        controllerSuffix: 'Controller'
        routes
    }
