var express = require('express'),
    morgan = require('morgan'),
    bodyParser = require('body-parser');

module.exports = function (app, config) {
    app.set('views', config.rootPath + '/server/views');
    app.set('view engine', 'jade');

    app.use(bodyParser.json({
        extended: true
    }));

    app.use(morgan('combined'))
    // only log error responses
    morgan('combined', {
        skip: function (req, res) {
            return res.statusCode < 400
        }
    })
    app.use(express.static(config.rootPath + '/dist'));
};