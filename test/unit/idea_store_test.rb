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
    IdeaStore.create("title" => "Yo?", "tags" => "hi")
    IdeaStore.create("title" => "Hey?", "tags" => "Why?")
  end

  def teardown
    IdeaStore.destroy_database
  end

  def test_the_database_exists
    assert_kind_of Psych::Store, IdeaStore.database
  end

  def test_it_finds_by_tags
    result = IdeaStore.search("Why?")
    assert_equal 1, result.count
  end

  def test_it_finds_idea_by_word_or_phrase
    result = IdeaStore.lookup("Why?")
    assert_equal 1, result.count
  end

end
