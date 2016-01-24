var express = require('express'),
    mongoose = require('mongoose'),
    colors = require('colors');


module.exports = function (app) {
// ---MODELS---

{% for schemaName,schema in schemas %}
    var {{ schemaName }}Schema = mongoose.Schema({{ schema | toMongoose | raw }});
    var {{ schemaName }}Model = mongoose.model('{{ schemaName }}', {{ schemaName }}Schema);
{% endfor %}

    // ---JSON API---
{% for group in resourceGroups %}
    // Route functions for {{ group.name }}
    {% for resource in group.resources %}{% for methodObject in resource.methods %}
    function {{ group.name }}_{{ methodObject.action }}{{ resource.suffix }} (req, res) {

        {%  if methodObject.action == 'show' and resource.uriParameters %}
            {{ resource.groupRelativeUri }}Model.find({_id: req.params.{{ Object.keys(resource.uriParameters)[0] }}}, function (err, msg) {
                res.json(msg);
            });
        {%  elseif methodObject.action == 'show' and not resource.uriParameters %}
            {{ resource.groupRelativeUri }}Model.find(function (err, msg) {
                res.json(msg);
            });
        {%  elseif methodObject.action == 'index' %}
            {{ resource.groupRelativeUri }}Model.find(function (err, msg) {
            res.json(msg);
            });
        {%  elseif methodObject.action == 'create' %}
            var document = new {{ resource.groupRelativeUri }}Model(req.body);
            document.save(function (err) {
                if (!err) {
                    console.log("added " + document.toString());
                }
            });
            res.json(document);
        {%  elseif methodObject.action == 'update' %}
            {{ resource.groupRelativeUri }}Model.findOne({_id: req.params.{{ Object.keys(resource.uriParameters)[0] }}}, function (err, document) {
                if (!err) {
                    document = req.body;
                    document.save(function (err) {
                        console.log("updated " + document.toString());
                        if (!err) {
                            res.json(req.body);
                        }
                    });
                }
            });
        {%  elseif methodObject.action == 'delete' %}
            {{ resource.groupRelativeUri }}Model.remove({_id: req.params.id}, function (err) {
            if (!err) {
            console.log("deleted " + req.params.id);
            }
            });
            res.json({'_id': req.params.id});
        {%  else %}
            // TODO Not implemented yet
            res.json({error: true, msg: '{{ group.name }}_{{ methodObject.action }}{{ resource.suffix }} not implemented yet'});
        {% endif %}

    }
    {% endfor %}{% endfor %}
    // Assign {{ group.name }} functions to routes
    {% for resource in group.resources %}{% for methodObject in resource.methods %}{% spaceless %}
            app.{{ methodObject.method }}('/api{{ resource.parentRelativeUri }}{{ resource.relativeUri }}', {{ group.name }}_{{ methodObject.action }}{{ resource.suffix }});
        {% endspaceless %}
    {% endfor %}{% endfor %}{% endfor %}
    // Catch all GET and defer routing to angular
    app.get('*', function (req, res) {
        res.render('index', {});
    });
};