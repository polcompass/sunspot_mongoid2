require 'helper'

describe Sunspot::Mongoid2 do
  class Foo
    include Mongoid::Document
    field :title

    include Sunspot::Mongoid2
    searchable do
      text :title
      integer :counting, multiple: false
    end
  end

  class Bar
    include Mongoid::Document
    field :title

    include Sunspot::Mongoid2
    searchable(:auto_index => false, :auto_remove => false) do
      text :title
    end
  end

  describe 'initial' do
    it 'sunspot_options is specified' do
      Foo.sunspot_options.must_equal({include: []})
      Bar.sunspot_options.must_equal({auto_index: false, auto_remove: false, include: []})
    end

    it 'get as text_fields from Sunspot::Setup' do
      text_field = Sunspot::Setup.for(Foo).all_text_fields.first
      text_field.type.must_be_instance_of Sunspot::Type::TextType
      text_field.name.must_equal :title
      text_field.multiple?.must_equal true
    end

    it "Sunspot field must support the 'multiple' attribute" do
      integer_field = Sunspot::Setup.for(Foo).fields.last
      integer_field.name.must_equal :counting
      integer_field.multiple?.must_equal false
    end

    it 'be called Sunspot.setup when call Foo.searchable' do
      mock(Sunspot).setup(Foo)
      Foo.searchable
    end

    it '#search' do
      options = {}
      mock.proxy(Foo).solr_execute_search(options)
      mock(Sunspot).new_search(Foo) { mock(Object.new).execute }
      Foo.search(options)
    end
  end
end
