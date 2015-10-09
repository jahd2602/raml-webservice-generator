var express = require('express'),
    mongoose = require('mongoose'),
    colors = require('colors');

var env = process.env.NODE_ENV = process.env.NODE_ENV || 'development';
var app = express();

// Config Object
var config = {
    //db : 'mongodb://test:test@ds053188.mongolab.com:53188/hello',
    db: 'mongodb://localhost:27017/hello',
    rootPath: __dirname,
    port: process.env.PORT || 3030
};

// EXPRESS setup
require('./server/config/express')(app, config);

// MongoDB setup via mongoose 
require('./server/config/mongoose')(config);

// Config Routes/API
require('./server/config/routes')(app);

// GO GO GO 
app.listen(config.port);
console.log("Listening on port ".green + config.port);