require 'spec_helper'
 
describe MoviesController do
  describe 'crud' do
    before :each do
      @fake_movie= mock_model(Movie)
      Movie.should_receive(:find).with("23").and_return(@fake_movie)
    end
    it 'should show Movie with the following pass ID, get movie, render show, pass movie to a view' do
      post :show,{:id=>23}
      response.should render_template('show')
      assigns(:movie).should == @fake_movie
    end
    it 'should edit a Movie' do
      post :edit,{:id=>23}
      response.should render_template('edit')
      assigns(:movie).should == @fake_movie
    end    
    it 'should delete a Movie' do
      @fake_movie.should_receive(:destroy)
      post :destroy,{:id=>23}
      response.should redirect_to('/movies')
    end    
    it 'should update a movie' do
      @fake_movie.should_receive(:update_attributes!).with(hash_including :title => 'Inception')
      post :update,{:id=>23,:movie=>{:title=>'Inception'}}
      response.should redirect_to('/movies/1004')
    end
   
  end
    it 'should return all the movies' do
    
      post :index,{}
      response.should render_template('movies/index')
    end
    it 'should return all the movies sorted by title' do
    
      post :index,{:sort=>'title'}
      response.should redirect_to('/movies?&sort=title')
    end
    it 'should return all the movies sorted by release date' do
    
      post :index,{:sort=>'release_date'}
      response.should redirect_to('/movies?&sort=release_date')
    end
   
    it 'should create a movie' do
      movie = FactoryGirl.build(:movie, :title => 'Kill Bill')
        
      Movie.should_receive(:create!).with(hash_including :title => 'Inception').and_return(movie)
      post :create,{:movie=>{:title=>'Inception'} }
      response.should redirect_to movies_path  
    end
  
  describe 'searching TMDb' do
    before :each do
      @fake_results = [mock('Movie'), mock('Movie')]
    end
    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end
    it 'should redirect to movies page if no movies found' do
        Movie.stub(:find_in_tmdb).and_return([])
        post :search_tmdb, {:search_terms => 'hardware'}
        response.should redirect_to movies_path
    end
    describe 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end

    describe 'find similar movies' do
      before :each do
        @fake_movies = [mock_model(Movie), mock_model(Movie)]
        @fake_movie = mock_model(Movie)
      end 
      it 'should call the controller method, grab the id of the movie, find the movie' do
         Movie.should_receive(:find).with("2").and_return(@fake_movie)
         post :same_director, { :id => 2 }
      end
      it 'should redirect if no director found for passed movieID ' do
         movie = FactoryGirl.build(:movie, :director => '')
         Movie.stub(:find).and_return(movie)
         post :same_director, { :id => 14 }
         response.should redirect_to movies_path
      end
     
      it 'should call the Movie model method to find movies whose director matches ' do
         movie = FactoryGirl.build(:movie, :director => 'Torontino')
         Movie.stub(:find).and_return(movie)
         Movie.should_receive(:find_all_by_director).with('Torontino').and_return(@fake_movies)
         post :same_director, { :id => 3 }
      end
      
      
      describe 'when found similar movies' do
        before :each do
           Movie.stub(:find).and_return(@fake_movie)
           Movie.stub(:find_all_by_director).and_return(@fake_movies)
           post :same_director, { :id => 3 }
        end

        it 'should select find similar movies template for rendering' do
           response.should render_template 'movies/same_director'
        end
        it 'should make the similar movies list available to that template' do
           assigns(:movies).should == @fake_movies
        end
      end 
    end
  end
end
