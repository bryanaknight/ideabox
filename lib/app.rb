require 'bundler'
require 'faraday'
require 'json'
require_relative 'idea_box'
Bundler.require

class IdeaBox < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  configure :development do
    register Sinatra::Reloader  
  end

  not_found do
    erb :error
  end

  get '/' do
    data = Faraday.get("http://en.seedfinder.eu/api/json/threadfinder.json")
    data_json = JSON.parse(data.body)
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new, data: data_json}
  end

  post '/' do 
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/lookup' do
    lookup_ideas = IdeaStore.lookup(params[:lookup])
    no_ideas = IdeaStore.all.none?
    erb :lookup, locals: {lookup_ideas: lookup_ideas, no_ideas: no_ideas}
  end

  get '/tags' do 
    idea_tags = IdeaStore.all_tags
    idea = IdeaStore.new
    erb :tags, locals: {idea_tags: idea_tags, ideas: IdeaStore} 
  end

  get '/dates' do
    day_of_week = params[:search_day]
    ideas = IdeaStore.find_by_wday(day_of_week)
    erb :dates, locals: {ideas: ideas, day_of_week: day_of_week }
  end

  get '/groups' do
    matching_ideas = IdeaStore.find_by_group(params[:group])
    erb :groups, locals: {matching_ideas: matching_ideas}
  end


end
