# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    Movie.create(movie)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings:(.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  other_ratings_list=Movie.all_ratings.delete_if {|key,val| rating_list=~Regexp.new(/ #{Regexp.quote(key)}/)}

  if uncheck
  	rating_list.gsub(/\W/," ").split.each do |rating|
 	 	step("I uncheck \"ratings_#{rating}\"")  
	end
	other_ratings_list.each do |rating|
 	 	step("I check \"ratings_#{rating}\"")  
  	end
  else 
	rating_list.gsub(/\W/," ").split.each do |rating|
 	 	step("I check \"ratings_#{rating}\"")  
	end
	other_ratings_list.each do |rating|
 	 	step("I uncheck \"ratings_#{rating}\"")  
  	end
  end
end

When /I check all of the ratings/ do
	Movie.all_ratings.each do |rating|
 	 	step("I check \"ratings_#{rating}\"") 
	end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body=~ /#{Regexp.quote(e1)}.*#{Regexp.quote(e2)}/m 
  #See http://stackoverflow.com/questions/150095/ruby-regex-string-insertion/150115#150115
  # /m switch is to change to multiple lines matches
end

Then /I should (not )?see movies with(out)? rating:(.*)/ do |dont, without, rating_list|
  rating_list=rating_list.gsub(/,/,"")	
  if without 
	#changes the rating_list to a list with all the other ratings
	rating_list=Movie.all_ratings.delete_if {|key,val| rating_list=~Regexp.new(/ #{Regexp.quote(key)}/)}
  else
	rating_list=rating_list.split
  end	
  rating_list.each do |rating|
	if dont 
		bool = !(page.body =~ /<td>#{Regexp.quote(rating)}<\/td>/m)		
	else 		
		bool = page.body =~ /<td>#{Regexp.quote(rating)}<\/td>/m
	end 
	assert bool
  end
end

Then /I should see all of the movies/ do
	rows = page.all(:xpath, "/html/body/div/table/tbody/tr").length
	rows.should == Movie.count
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |arg1, arg2|
	page.should have_content("Director: #{arg2}")
end


