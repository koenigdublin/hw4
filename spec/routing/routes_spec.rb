require 'spec_helper'
 
describe MoviesController do
  describe 'display all movies'
    it 'should redirects to RESTful route' do
      {:get => "/movies"}.should route_to("movies#index") # be_routable
    
  end
  describe 'find similar movies' do
    
    it 'should follow path to the RESTful route' do
     same_director_movie_path(25).should =="/movies/25/same_director"
    end
    it 'should follow path to the RESTful route' do
     same_director_path(25).should =="/same_director_movies/25"
    end
    
    it 'should redirects to controller action from the RESTful route' do
      {:get => "/movies/11/same_director"}.should route_to("movies#same_director","id"=>"11")
    end
     
  end
end
