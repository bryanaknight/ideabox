gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea_store'
require './lib/idea_box/idea'
require 'yaml/store'

class IdeaStoreTest <Minitest::Test

  def setup
    IdeaStore.database
    IdeaStore.create("title" => "Is this thing on?", "tags" => "poop")
    IdeaStore.create("title" => "Yo?", "tags" => "Why?")
    IdeaStore.create("title" => "hey", "tags" => "Why?")
  end

  def teardown
    IdeaStore.destroy_database
  end

  def test_the_database_exists
    assert_kind_of Psych::Store, IdeaStore.database
  end

  def test_it_finds_by_tags
    result = IdeaStore.search("Why?")
    assert_equal 2 , result.count
  end

end
