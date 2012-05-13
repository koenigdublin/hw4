FactoryGirl.define do 
  factory :movie do
    title 'A Fake Title' # default values
    rating 'PG'
    release_date {10.years.ago}
    director 'unknown'
  end
end
