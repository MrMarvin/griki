require 'sinatra'
require 'haml'
require 'grit'

set :environment, :development
set :haml, :format => :html5

get '/' do
  begin
    repo = Grit::Repo.new(Dir.pwd)
  rescue Grit::InvalidGitRepositoryError
    return "No (or invalid) git repository found!"
  end
  @current_tree = repo.tree.contents
  haml :griki_default
end

get '/:blob_or_tree' do
  repo = Grit::Repo.new(Dir.pwd)
  begin
    @blob = repo.tree(params[:blob_or_tree])
  rescue
    @blob = repo.blob(params[:blob_or_tree])
  end
  puts @blob.class
  if @blob.class == Grit::Tree
    "treeeee"
  else
    haml :griki_show
  end
end
