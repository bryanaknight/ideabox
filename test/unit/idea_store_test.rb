ENV['RACK_ENV'] = 'test'
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea_store'
require './lib/idea_box/idea'
require 'yaml/store'

class IdeaStoreTest <Minitest::Test

  def setup
    IdeaStore.database
    IdeaStore.create("title" => "Baseball", "tags" => "sports")
    IdeaStore.create("title" => "Ice Cream", "tags" => "food", "created_at" => Time.new(2007,11,19,8,37,48,"-06:00"))
    IdeaStore.create("title" => "Study", "tags" => "school, sports", "created_at" => Time.now)
  end

  def teardown
    IdeaStore.destroy_database
  end

  def test_the_database_exists
    assert_kind_of Psych::Store, IdeaStore.database
  end

  def test_all
    assert_equal 3, IdeaStore.all.count
  end

  def test_it_finds_idea_by_word_or_phrase
    skip
    result = IdeaStore.lookup("food")
    assert_equal 1, result.count
  end

  def test_it_displays_all_tags
    result = IdeaStore.all_tags  
    assert_equal ["sports", "food", "school", " sports"], result
  end

  def test_tag_hash
    result = IdeaStore.tag_hash  
    assert_equal 4, result.count
    assert_equal ["sports", "food", "school", " sports"], result.keys
  end

  def test_it_searches_for_ideas_by_group
    # IdeaStore.database
    IdeaStore.create("title" => "Baseball", "tags" => "sports", "group" => "travel")
    IdeaStore.create("title" => "Ice Cream", "tags" => "food", "created_at" => Time.new(2007,11,19,8,37,48,"-06:00"), "group" =>"leisure")
    IdeaStore.create("title" => "Study", "tags" => "school, sports", "created_at" => Time.now, "group" => "travel")
    result = IdeaStore.find_by_group("travel")
    assert_equal 2, result.count
    assert_equal "Baseball", result.first.title
  end


  
end
