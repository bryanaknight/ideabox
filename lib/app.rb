require 'bundler'
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
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new}
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

  get '/search' do 
    tagged_ideas = IdeaStore.search(params[:search_tag])
    erb :search, locals: {tagged_ideas: tagged_ideas}
  end

end
