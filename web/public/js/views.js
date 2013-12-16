var app = app || {};

(function ($) {
  'use strict';

  // The DOM element for a user item...
  app.UserView = Backbone.View.extend({
    tagName:  "li",

    template: _.template($('#user-template').html()),

    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    }
  });

  // The DOM element for a company item...
  app.CompanyView = Backbone.View.extend({
    tagName:  "li",

    attributes: {
      "class": "list-group-item"
    },

    template: _.template($('#company-template').html()),

    events: {
      "click .details_toggle" : "toggleDetails"
    },

    // Re-render the contents of the company item.
    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    },

    // Add a details section to this list item
    toggleDetails: function() {
      var user_list_elem = this.$("#user-list");
      this.closed = !this.closed;

      if(this.closed) {
        this.$(".glyphicon-chevron-down").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");
        var company_users = app.users.where({company: this.model.get('_id')});
        _.each(company_users, function(company) {
          var view = new app.UserView({model: company});
          user_list_elem.append(view.render().el);
        });
      } else {
        this.$(".glyphicon-chevron-up").removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
        user_list_elem.empty();
      }
    }
  });

  // Welcome View
  // ---------------
  app.WelcomeView = Backbone.View.extend({
    template: _.template($('#welcome-template').html()),
    initialize: function () {
      this.render();
    },
    render: function() {
      $("#page").html(this.template());
      return this;
    }
  });

  // The Application
  // ---------------
  app.AppView = Backbone.View.extend({
    template: _.template($('#app-template').html()),

    initialize: function () {
      this.listenTo(app.companies, 'add', this.addOne);
      this.listenTo(app.companies, 'reset', this.addAll);
      app.companies.fetch({reset: true});
      app.users.fetch({reset: true});
      this.render();
    },

    render: function() {
      $("#page").html(this.template());
      return this;
    },

    addOne: function (company) {
      if(company.get('_id')) {
        var view = new app.CompanyView({ model: company });
        $('#company-list').append(view.render().el);
      }
    },

    addAll: function () {
      this.$('#company-list').html('');
      app.companies.each(this.addOne, this);
    }
  });
})(jQuery);