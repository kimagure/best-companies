var app = app || {};

(function () {
  'use strict';

  var CompaniesRouter = Backbone.Router.extend({
    routes: {
      'companies': function() {
        new app.AppView();
      },
      '':  function() {
        new app.WelcomeView();
      }
    }
  });

  app.CompaniesRouter = new CompaniesRouter();
  Backbone.history.start({pushState: true});
})();