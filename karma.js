module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: ['spec/**/*.coffee', 'src/**/*.coffee'],
    exclude: [],
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


