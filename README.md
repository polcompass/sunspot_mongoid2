sunspot_mongoid 2
====

A Sunspot wrapper for Mongoid that just works.

Gemfile
----
    gem 'sunspot_mongoid2'
    bundle install

For Rails 3.x
----

### Configure your gem

Create `config/initializers/sunspot_mongoid.rb`:

    Sunspot.session = Sunspot::Rails.build_session
    ActionController::Base.module_eval { include(Sunspot::Rails::RequestLifecycle) }
    
Don't forget to restart your rack server (or pow.cx)

### as plugin (only if really needed):

add gems to Gemfile as following,

    gem 'sunspot_mongoid2'
    gem 'sunspot_rails'

and install `sunspot_mongoid` as rails plugin,

    rails plugin install https://github.com/hlegius/sunspot_mongoid2.git


A Simple Example
----

    class Post
      include Mongoid::Document
      include Sunspot::Mongoid2

      searchable do
        text :title
        integer :foo_totals, multiple: true
      end

      field :title
    end

    class SomeController < ActionController::Base
      def index
        search = Sunspot.search(Post) do
          fulltext params[:q]
        end
        
        @results = search.results
        @total_lines = search.total
      end
    end

    # http://yourapplication.dev/search?q=foobarbaz

Links
----

* [sunspot](http://github.com/outoftime/sunspot)
* [sunspot_rails](http://github.com/outoftime/sunspot/tree/master/sunspot_rails/)



Copyright (and left)
----

Copyright (c) 2010 jugyo. See LICENSE for details.

A lot of other contributions were made before I did.
