var app = app || {};

(function () {
  'use strict';

  var CompaniesRouter = Backbone.Router.extend({
    routes: {
      'companies': function() {
        new app.AppView();
      },
      'about':  function() {
        new app.WelcomeView();
      },
      '': function() {
        new app.AppView();
      },
    }
  });

  app.CompaniesRouter = new CompaniesRouter();
  Backbone.history.start({pushState: true});
})();