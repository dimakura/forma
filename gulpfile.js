var gulp = require('gulp');
var less = require('gulp-less');

gulp.task('less', function () {
  gulp.src('./less/forma.less')
    .pipe(less())
    .pipe(gulp.dest('./vendor/assets/stylesheets'));
});
