# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.transaction do
    Movie.destroy_all
    movies_table.hashes.each do |movie|
      # each returned element will be a hash whose key is the table header.
      # you should arrange to add that movie to the database here.
       
      Movie.create!(movie)# unless Movie.find_by_title(movie['title'])
      assert Movie.find_by_title(movie['title']),"Movie exists"
    end
  end
#  assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  
  
  assert page.body.index(/#{e1}/)<page.body.index(/#{e2}/),"#{e1} found after #{e2}"
end

Then /the director of "(.*)" should be "(.*)"/ do|m_title,m_director|
  found_movie = Movie.find_by_title(m_title)
  assert found_movie.director==m_director, "Movie director is #{found_movie.director} but expected to be #{m_director}"
end

When /I sort by "(.*)"/ do |el|
  step %Q{I follow "#{el}_header"}  
end

Then /I should (not\s)?see movies for the following ratings: (.*)/ do |hidden,rating_list|
  rating_list.split(',').each do |e|
     movies = Movie.find_all_by_rating(e)
     
     movies.each do |m|
       step %Q{I should not see "#{m.title}"} if hidden
       step %Q{I should see "#{m.title}"} unless hidden
     end
  end  
end

Given /(all|no)? ratings selected/ do |all|
 
  step %Q{I check the following ratings: PG,G,R,PG-13} if all=='all'
  step %Q{I uncheck the following ratings: PG,G,R,PG-13} if all=='no'
end
  
  
Then /I should (not\s)?see (all|any)? of the movies/ do |all_hidden,all_any|
  step %Q{I should see movies for the following ratings: PG,G,R,PG-13} unless all_hidden
  step %Q{I should not see movies for the following ratings: PG,G,R,PG-13} if all_hidden

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |e|
    if uncheck 
      step %Q{I uncheck "ratings_#{e}"} 
    else
      step %Q{I check "ratings_#{e}"}
    end
  end
end

When /I submit the search form/ do
  step %Q{I press "ratings_submit"}
end

