Chaplin = require 'chaplin'
SiteView = require 'views/SiteView'

module.exports = class BaseController extends Chaplin.Controller
    beforeAction: ->
        @reuse 'site', SiteView