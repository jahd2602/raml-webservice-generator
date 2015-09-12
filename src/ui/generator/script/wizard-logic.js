(function () {

    var remote = require('remote');
    var fs = require('fs');
    var BrowserWindow = remote.require('browser-window');
    var languages = require('../../languages/index');
    var assert = require('assert');
    var Bluebird = require('bluebird');
    var resolve = require('path').resolve;
    var ramlParser = require('raml-parser');
    var mkdirp = Bluebird.promisify(require('mkdirp'));
    var writeFile = Bluebird.promisify(require('fs').writeFile);

    $generator = $('#generator');
    $steps = $generator.find('> .row');

    function goToStep1() {
        $steps.hide();
        $('#step1').fadeIn();
    }

    function goToStep2() {
        $steps.hide();
        $('#step2').fadeIn();
    }

    function goToStep3() {
        $steps.hide();
        $('.final-container').show();
        $('.error-generator').hide();
        $('.loading').hide();
        $('#step3').fadeIn();
    }

    function goToStep4() {
        $steps.hide();
        $('#step4').fadeIn();
    }

    $('.goto-step1').on('click', function (event) {
        setTimeout(function () {
            goToStep1();
        }, 200);

    });
    $('.goto-step2').on('click', function (event) {
        setTimeout(function () {
            goToStep2();
        }, 200);

    });
    $('.goto-step3').on('click', function (event) {
        setTimeout(function () {
            goToStep3();
        }, 200);

    });
    $('.goto-step4').on('click', function (event) {
        setTimeout(function () {
            goToStep4();
        }, 200);

    });

    $('.titlebar-minimize').on('click', function (event) {
        var window = BrowserWindow.getFocusedWindow();
        window.minimize();
    });

    $('.titlebar-close,.exit').on('click', function (event) {
        var window = BrowserWindow.getFocusedWindow();
        window.close();
    });

    $('#github-link').on('click', function (event) {
        event.preventDefault();
        console.log('open github link');
        require('shell').openExternal('https://github.com/jahd2602/raml-js-webservice-generator');
    });

    var inputFile = '';
    var outputDirectory = '';
    var template = '';

    $generator.find('input[name=inputFile]').change(function (event) {
        var theFiles = event.target.files;
        inputFile = theFiles[0].path;
        if (inputFile) {
            goToStep2();
        }
        console.log(inputFile);
    });

    $generator.find('input[name=outputDirectory]').change(function (event) {
        var theFiles = event.target.files;
        outputDirectory = theFiles[0].path;
        if (outputDirectory) {
            $('#submit-form').trigger('click');
        }
        console.log(outputDirectory);
    });

    $('.open-output-folder').on('click', function (event) {
        event.preventDefault();
        require('shell').openItem(outputDirectory);
    });

    $('#submit-form').on('click', function (event) {
        event.preventDefault();

        $('.loading').show();
        $('.final-container').hide();

        var template = $('#generator').find('select[name=template]').val();

        if (!inputFile) {
            goToStep1();
            $('.error-step1').fadeIn();

            setTimeout(function () {
                $('.error-step1').fadeOut();
            }, 2000);
            return;
        } else if (!outputDirectory) {
            goToStep3();
            $('.error-step3').fadeIn();

            setTimeout(function () {
                $('.error-step3').fadeOut();
            }, 2000);
            return;
        } else if (!template) {
            goToStep2();
            $('.error-step2').fadeIn();

            setTimeout(function () {
                $('.error-step2').fadeOut();
            }, 2000);
            return;
        }

        /**
         * Pull out options into an object for passing into generator.
         *
         * @type {Object}
         */
        var options = {
            entry: inputFile,
            output: outputDirectory,
            language: template
        };

        /**
         * Generate the API client.
         */
        Bluebird.resolve(options)
            .tap(function (options) {
                // Make sure the language exists
                assert(languages.hasOwnProperty(options.language), 'Unsupported language');
            })
            .then(function (options) {
                // Load the RAML file
                //FIXME de momento solo se puede usando readFileSync y los schemas deben estar en el mismo archivo

                var fileData = fs.readFileSync(options.entry);
                return ramlParser.load(fileData);
//                        return ramlParser.loadFile(options.entry);
            })
            .then(function (ast) {
                // Process the RAML object using the selected language
                return languages[options.language](ast, options);
            })
            .then(function (output) {
                // Write the resulting output to the fs
                return objectToFs(options.output, output.files);
            })
            .then(function () {
                return setTimeout(function () {
                    goToStep4();
                }, 200);
            })
            .catch(function (err) {
                // Log the error stacktrace
                var errorDescription = err instanceof Error ? (err.stack || err.message) : err;

                goToStep3();
                console.log(err);
                $('.error-generator').fadeIn();
                $('.error-generator span').text('Error: ' + errorDescription);

            });

        /**
         * Save on object structure to the file system.
         *
         * @param  {String}  dir
         * @param  {Object}  objectToSave
         * @return {Promise}
         */
        function objectToFs(dir, objectToSave) {
            var promise = mkdirp(dir);

            Object.keys(objectToSave).forEach(function (key) {
                var content = objectToSave[key];
                var filename = resolve(dir, key);

                promise = promise.then(function () {
                    if (typeof content === 'object') {
                        return objectToFs(filename, content);
                    }

                    return writeFile(filename, content);
                });
            });

            return promise.then(function () {
                return objectToSave;
            });
        }

    });

})();