ENV['RACK_ENV'] = 'test'

gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require './lib/app'

class AppTest < Minitest::Test 
  include Rack::Test::Methods

  def app
    IdeaBox
  end

  def test_it_exists
    assert IdeaBox
  end

  def test_it_moves_to_erb_file
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_it_displays_the_form
    get '/'
    assert (last_response.body =~ /Existing Ideas/)
    assert (last_response.body =~ /Your Idea:/)
    assert (last_response.body =~ /Tag/)
    assert (last_response.body =~ /Name/)
    assert (last_response.body =~ /Description/)
    assert (last_response.body =~ /IdeaBox/)
  end

  def teardown
    IdeaStore.destroy_database
  end

end
