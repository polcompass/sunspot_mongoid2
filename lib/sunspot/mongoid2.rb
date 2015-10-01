require 'sunspot'
require 'mongoid'
require 'sunspot/rails'

module Sunspot
  module Mongoid2
    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        extend Sunspot::Mongoid2::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
      end
    end

    module ActsAsMethods
      # ClassMethods isn't loaded until searchable is called so we need
      # call it, then extend our own ClassMethods.
      def searchable(opt = {}, &block)
        super
        extend ClassMethods
      end
    end

    module ClassMethods
      # The sunspot solr_index method is very dependent on ActiveRecord, so
      # we'll change it to work more efficiently with Mongoid.
      def solr_index(opt={})
        Sunspot.index!(all)
      end
    end


    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id
      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor
      def load(id)
        @clazz.find(bson_id(id)) rescue nil
      end

      def load_all(ids)
        @clazz.where(:_id.in => ids.map { |id| bson_id(id) })
      end

      def bson_id(id)
        if Gem::Version.new(Mongoid::VERSION) >= Gem::Version.new('3')
          ::BSON::ObjectId.from_string(id)
        else
          ::BSON::ObjectId.from_string(id)
        end
      end
    end
  end
end
