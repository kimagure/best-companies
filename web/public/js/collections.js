var app = app || {};

(function () {
  'use strict';

  var Companies = Backbone.Collection.extend({
    model: app.Company,
    url: '/api/companies'
  });
  app.companies = new Companies();

  var Users = Backbone.Collection.extend({
    model: app.User,
    url: '/api/users'
  });
  app.users = new Users();
})();