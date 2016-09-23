var gulp = require('gulp');
var elm  = require('gulp-elm');

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function(){
  return gulp.elm('elm/*.elm')
    .pipe(elm())
    .pipe(gulp.dest('dist/'));
});

gulp.task('elm-bundle', ['elm-init'], function(){
  return gulp.elm('elm/*.elm')
    .pipe(elm.bundle('main.js'))
    .pipe(gulp.dest('static/'));
});

gulp.task('watch', function(){
  gulp.watch('elm/*.elm', ['elm-bundle']);
});
