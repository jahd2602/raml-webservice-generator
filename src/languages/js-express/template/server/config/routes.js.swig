var mongoose = require('mongoose');

module.exports = function (app) {
    var messageSchema = mongoose.Schema({message: String});
    var Message = mongoose.model('Message', messageSchema);

    // JSON API
    app.get('/api/:id', function (req, res) {
        Message.find({_id: req.params.id}, function (err, msg) {
            mongo = msg;
            res.json(mongo);
        });
    });

    app.get('/api', function (req, res) {
        Message.find(function (err, msg) {
            mongo = msg;
            res.json(mongo);
        });
    });

    app.post('/api', function (req, res) {
        var message = new Message({
            message: req.body.message
        });
        message.save(function (err) {
            if (!err) {
                console.log("added ".green + message.toString().green);
            }
        });
        res.json(message);
    });

    app.put('/api/:id', function (req, res) {
        Message.findOne({_id: req.params.id}, function (err, user) {
            if (!err) {
                user.message = req.body.message;
                console.log("updated ".green + user.toString().green);
                user.save(function (err) {
                    if (!err) {
                        res.json(req.body);
                    }
                });
            }
        });
    });

    app.delete('/api/:id', function (req, res) {
        Message.remove({_id: req.params.id}, function (err) {
            if (!err) {
                console.log("deleted ".green + req.params.id.green);
            }
        });
        res.json({'_id': req.params.id});
    });

    // catch-all GET - defer routing to angular
    app.get('*', function (req, res) {
        res.render('index', {});
    });
};