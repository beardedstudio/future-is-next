require 'rubygems'
require 'sinatra'
require 'haml'
require 'compass'
require 'breakpoint'

# set sinatra's variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, "views"
set :public_folder, 'static'

if production?
  set :static_cache_control, [:public, max_age: 60 * 60 * 24]
end

configure do
  set :haml, {:format => :html5, :escape_html => false}
  set :scss, {:style => :compact, :debug_info => false}
  set :protection, except: [:frame_options]
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end



get '/:version/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"#{params[:version]}/stylesheets/#{params[:name]}", Compass.sass_engine_options)
end

# routes for version-less error pages

get '/404.html' do
  erb :"v1/404.html"
end

get '/422.html' do
  erb :"v1/422.html"
end

get '/500.html' do
  erb :"v1/500.html"
end

get '/503.html' do
  erb :"v1/503.html"
end

# routes for versioned error pages

get '/:version/404.html' do
  erb :"#{params[:version]}/404.html"
end

get '/:version/422.html' do
  erb :"#{params[:version]}/422.html"
end

get '/:version/500.html' do
  erb :"#{params[:version]}/500.html"
end

get '/:version/503.html' do
  erb :"#{params[:version]}/503.html"
end

not_found do
  status 404
  erb :'v1/404.html'
end

error do
  status 500
  erb :'v1/500.html'
end

before do
  if settings.production?
    cache_control :public, max_age: (60 * 60 * 24) # 1 day
    last_modified $updated_at ||= Time.now
  end
end

# routes for non-error pages

get '/' do
  haml :"v1/index.html", :layout => :"v1/layout"
end

get '/:page_name.html' do
  haml :"v1/#{params[:page_name]}.html", :layout => :"v1/layout"
end

get '/:version/?' do
  haml :"#{params[:version]}/index.html", :layout => :"#{params[:version]}/layout"
end

get '/:version/:page_name.html' do
  haml :"#{params[:version]}/#{params[:page_name]}.html", :layout => :"#{params[:version]}/layout"
end
