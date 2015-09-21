var gulp = require('gulp'),
    gutil = require('gulp-util'),
    jshint = require('gulp-jshint'),
    browserify = require('browserify'),
    source = require('vinyl-source-stream'),
    concat = require('gulp-concat'),
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    imagemin = require('gulp-imagemin'),
    cache = require('gulp-cache'),
    notify = require('gulp-notify'),
    minifycss = require('gulp-minify-css'),
    rename = require('gulp-rename'),
    rimraf = require('gulp-rimraf'),
    open = require("gulp-open"),
    uglify = require('gulp-uglify');

// Dev task
gulp.task('dev', ['clean'], function () {
    gulp.start(['views', 'images', 'styles', 'lint', 'browserify']);
    gulp.src('public/js/TweenMax.min.js')
        .pipe(gulp.dest('dist/js/'));
    gulp.start('watch');
});

// JSHint task
gulp.task('lint', function () {
    gulp.src('public/js/app.js')
        // Pass in our jshint rules
        .pipe(jshint('.jshintrc'))
        // Set our jshint reporter - using jshint-stylish
        .pipe(jshint.reporter('jshint-stylish'))
        .pipe(notify({message: 'JSLint task complete', onLast: true}));
});

// Styles task
gulp.task('styles', function () {
    gulp.src('public/css/*.css')
        // The onerror handler prevents Gulp from crashing when you make a mistake in your SASS
        .pipe(sass({
            onError: function (e) {
                console.log(e);
            }
        }))
        // Add autoprefixer
        .pipe(autoprefixer("last 2 versions", "> 1%", "ie 8"))
        // Output it to our dist folder
        .pipe(gulp.dest('dist/css/'))
        // Create a minified css file
        .pipe(rename({suffix: '.min'}))
        .pipe(minifycss())
        // Output it to our dist folder
        .pipe(gulp.dest('dist/css/'))
        .pipe(notify({message: 'Styles task complete', onLast: true}));
});

// Browserify task
gulp.task('browserify', function () {
    // Single point of entry (make sure not to src ALL your files, browserify will figure it out)
    return browserify('./public/js/app.js')
        .bundle({debug: true})
        .on('error', gutil.log)
        // Bundle to a single file
        .pipe(source('bundle.js'))
        // Output it to our dist folder
        .pipe(gulp.dest('dist/js'))
        // Create a minified bundle file
        .pipe(notify({message: 'Browserify task complete', onLast: true}));
});

// Uglify task
gulp.task('uglify', function () {
    gulp.src('dist/js/bundle.js')
        .pipe(rename({suffix: '.min'}))
        .pipe(uglify())
        // Output it to our dist folder
        .pipe(gulp.dest('dist/js'))
        .pipe(notify({message: 'Uglify task complete', onLast: true}))
});

// Views task
gulp.task('views', function () {
    // Get our index.html
    gulp.src('public/partials/**/*')
        // Will be put in the dist/views folder
        .pipe(gulp.dest('dist/partials/'))
        .pipe(notify({message: 'Views task complete', onLast: true}));
});

// Images task
gulp.task('images', function () {
    return gulp.src('public/assets/**/*')
        // optimize images
        .pipe(cache(imagemin({optimizationLevel: 3, progressive: true, interlaced: true})))
        // Will be put in the dist/images folder
        .pipe(gulp.dest('dist/assets'))
        .pipe(notify({message: 'Images task complete', onLast: true}));
});

// Clean task
gulp.task('clean', function () {
    return gulp.src('dist/*', {read: false})
        // Remove dist folder and contents
        .pipe(rimraf({force: true}))
        .pipe(notify({message: 'Clean task complete', onLast: true}));

});

gulp.task('watch', function () {
    // Watch our scripts, and when they change run lint and browserify
    gulp.watch(['public/js/*.js', 'public/js/**/*.js'], [
        'browserify',
        'lint'
    ]);
    // Watch our sass files
    gulp.watch(['public/css/**/*.css'], [
        'styles'
    ]);
    // Watch our html files
    gulp.watch(['public/**/*.html'], [
        'views'
    ]);
    // Watch our image files
    gulp.watch(['public/assets/**/*'], [
        'images'
    ]);
});
