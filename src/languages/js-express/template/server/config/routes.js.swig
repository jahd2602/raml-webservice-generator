module.exports = function (app) {
    // ---JSON API---
{% for group in resourceGroups %}
    // Route functions for {{ group.name }}
    {% for resource in group.resources %}{% for methodObject in resource.methods %}
    function {{ group.name }}_{{ methodObject.action }}{{ resource.suffix }} (req, res) {
        // TODO Not implemented yet
        res.json({error: true, msg: '{{ group.name }}_{{ methodObject.action }}{{ resource.suffix }} not implemented yet'});
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