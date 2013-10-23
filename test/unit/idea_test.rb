gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea'

class IdeaTest < Minitest::Test 
  attr_reader :idea

  def setup
    @idea = Idea.new("title"       => "pool party",
                    "description" => "Splash around and drink margs",
                    "id"          => "1",
                    "tags"        => "fun",
                    "updated_at"  => "10/21/2013",
                    "created_at"  => "10/22/2013"
                    )
  end

  def test_idea_exists_and_has_attributes
    assert_equal "pool party", idea.title
    assert_equal "Splash around and drink margs", idea.description
    assert_equal "1", idea.id 
    assert_equal "fun", idea.tags
  end

  def test_it_starts_with_rank_0
    idea = Idea.new 
    assert_equal 0, idea.rank
  end

  def test_it_has_a_hash_of_data_as_input
    expected = {    "title"       => "pool party",
                    "description" => "Splash around and drink margs",
                    "rank"        => 0,
                    "tags"        => "fun",
                    "updated_at"  => "10/21/2013",
                    "created_at"  => "10/22/2013",
                    "group"       => "Groupless"
                  }
    assert_equal expected, idea.to_h
  end

  def test_the_like_method_increases_the_rank
    idea = Idea.new
    idea.like!
    assert_equal 1, idea.rank
  end

  def test_the_comparable
    idea1 = Idea.new
    idea2 = Idea.new
    idea2.like!
    assert_equal 1, idea2.rank
    assert_equal 0, idea1.rank
  end

  def test_it_gets_assigned_to_a_group
    idea = Idea.new("title"       => "pool party",
                    "description" => "Splash around and drink margs",
                    "id"          => "1",
                    "tags"        => "fun",
                    "updated_at"  => "10/21/2013",
                    "created_at"  => "10/22/2013",
                    "group"       => "travel"
                    )
    assert_equal "travel", idea.group
  end

  def test_it_gets_assigned_to_default_group_when_no_group_assigned
    idea = Idea.new("title"       => "pool party",
                    "description" => "Splash around and drink margs",
                    "id"          => "1",
                    "tags"        => "fun",
                    "updated_at"  => "10/21/2013",
                    "created_at"  => "10/22/2013",
                    )
    assert_equal "Groupless", idea.group
  end

end
