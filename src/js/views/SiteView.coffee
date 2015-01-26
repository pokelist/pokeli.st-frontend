Chaplin = require 'chaplin'
BaseView = require './BaseView'

module.exports = class SiteView extends BaseView
    container: 'body'
    id: 'site-container'
    regions:
        header: '#header-container'
        main: '#page-container'
        footer: '#footer-container'
    template: require '/templates/site'