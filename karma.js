module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'spec/**/*.coffee',
      'src/**/*.coffee'
    ],
    exclude: ['spec/e2e/*'],
    preprocessors: {
      '**/*.coffee': ['coffee']
    },
    reporters: ['progress', 'osx'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: false
  });
};
