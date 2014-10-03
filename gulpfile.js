var gulp = require('gulp');
var less = require('gulp-less');
var browserify = require('browserify');
var source = require('vinyl-source-stream');

gulp.task('browserify', function() {
  return browserify()
    .require('./js/forma.js', { expose: 'forma' })
    .bundle()
    .pipe(source('./forma.js'))
    .pipe(gulp.dest('./vendor/assets/javascripts'));
});

gulp.task('less', function () {
  gulp.src('./less/forma.less')
    .pipe(less())
    .pipe(gulp.dest('./vendor/assets/stylesheets'));
});
