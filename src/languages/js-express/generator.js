/**
 * Generates source file from RAML
 */

var swig = require('swig'),
    util = require('util'),
    string = require('string'),
    raml = require('../base/raml'),
    schemaParser = require('../base/parser/schema'),
    keysParser = require('../base/parser/keys');

/**
 * Renders the params into the swings templates
 * @param file path of the output file
 * @param params template variables to pass to the template
 * @returns {*}
 */
var render = function (file, params) {
    return swig.renderFile(util.format('%s/template/%s.swig', __dirname, file), params);
};

module.exports = {
    /**
     * Generate the files to output by inserting the RAML data in the templates
     * @param RAMLObject
     * @param options
     * @returns {{files: {web: {}, src: {Controllers: {}, Models: {}, Views: {}}, raml: {}}}}
     */
    generate: function (RAMLObject, options) {
        var files = {
            public: {
                assets: {},
                css: {},
                js: {},
                partials: {}
            },
            server: {
                config: {},
                includes: {},
                views: {}
            },
            raml: {}
        };

        var resources = raml.resources(RAMLObject);
        var schemas = raml.schemas(RAMLObject);
        var resourceGroups = raml.resourceGroupsFromResources(resources);

        // Dumps the variables to raml/
        files.raml['RAML.json'] = JSON.stringify(RAMLObject, null, 2);
        files.raml['RAML-resources.json'] = JSON.stringify(resources, null, 2);
        files.raml['RAML-resourceGroups.json'] = JSON.stringify(resourceGroups, null, 2);

        // Render static files
        files['.gitignore'] = render('.gitignore');
        files['.jshintrc'] = render('.jshintrc');
        files['gulpfile.js'] = render('gulpfile.js');
        files['package.json'] = render('package.json');
        files['README.md'] = render('README.md');
        files['server.js'] = render('server.js');

        files.public.css['style.css'] = render('public/css/style.css');
        files.public.css['toastr.css'] = render('public/css/toastr.css');

        files.public.js['app.js'] = render('public/js/app.js');
        files.public.js['TweenMax.min.js'] = render('public/js/TweenMax.min.js');

        files.public.partials['edit.html'] = render('public/partials/edit.html');
        files.public.partials['main.html'] = render('public/partials/main.html');

        files.server.config['express.js'] = render('server/config/express.js');
        files.server.config['mongoose.js'] = render('server/config/mongoose.js');
        files.server.includes['layout.jade'] = render('server/includes/layout.jade');
        files.server.includes['scripts.jade'] = render('server/includes/scripts.jade');

        files.server.views['index.jade'] = render('server/views/index.jade');

        // Render dynamic files
        files.server.config['routes.js'] = render('server/config/routes.js', {
            resources: resources,
            resourceGroups: resourceGroups
        });

        return {
            files: files
        };
    }
};