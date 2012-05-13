require 'spec_helper'

describe Movie do 
  #fixtures :movies
  it 'should include rating and year in full name' do
     # movie = movies(:milk_movie)
      movie = FactoryGirl.build(:movie, :title => 'Milk', :rating => 'R')
      movie.name_with_rating.should == 'Milk (R)'
  end
 # subject { create :movie, :title => 'Milk', :rating => 'R' }
 # its :name_with_rating { should == 'Milk (R)' }
 
   it 'should return all ratings' do
      assert Movie.all_ratings ==  %w(G PG PG-13 NC-17 R)   
   end
    
   describe 'searching TMDB by keyword' do
      it 'should call tmdb with title keywordds' do
        TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception')
        Movie.find_in_tmdb('Inception')
      end
      
       it 'should raise an InvalidKeyError with no API key' do
        Movie.stub(:api_key).and_return('')
        lambda {Movie.find_in_tmdb('Inception')}.
           should raise_error(Movie::InvalidKeyError)
      end
      
      it 'should raise an InvalidKeyError with INVALID API key' do
        #we need break dependency between tmdb
        TmdbMovie.stub(:find).and_raise(RuntimeError.new('API returned status code \'404\''))
        
        lambda {Movie.find_in_tmdb('Inception')}.
           should raise_error(Movie::InvalidKeyError)
      end
     
      it 'should raise a commmon exception if something unepected happens' do
        #we need break dependency between tmdb
        TmdbMovie.stub(:find).and_raise(RuntimeError.new('UNKNOWN'))
        
        lambda {Movie.find_in_tmdb('Inception')}.
           should raise_error(RuntimeError)
      end
      
   end
  
end
