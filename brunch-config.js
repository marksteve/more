module.exports = {
  paths: {
    public: 'priv/static'
  },

  files: {
    javascripts: {
      joinTo: {
        'js/vendor.js': /^(?!app)/,
        'js/app.js': /^app/
      }
    },
    stylesheets: {joinTo: 'css/app.css'}
  },

  plugins: {
    babel: {presets: ['es2015']}
  }
};
