best-companies
==============

This app scours GitHub to find DC area companies with the best coders.

Requirements
------------

* Ruby 1.9.3
* MongoDB
* Bundler

You'll also need to know:

* Your GitHub API username
* Your GitHub API password

Importing data
--------------

To install:

    bundle install

To run:

    ruby best.rb

Running the web application
---------------------------------    

The web application is built with Sinatra on the server, and Backbone.js on the client.

To install:

    bundle install

To run:

    github_api_username=[your username or email] github_api_password=[your password] ruby best.rb 