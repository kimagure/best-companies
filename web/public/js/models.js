var app = app || {};

(function () {
  'use strict';

  app.Company = Backbone.Model.extend({
    toJSON: function() {
      var json = Backbone.Model.prototype.toJSON.apply(this, arguments);
      json.index = this.collection.indexOf(this) + 1;
      return json;
    }
  });
  app.User = Backbone.Model.extend({});
})();