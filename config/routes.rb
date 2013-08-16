Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  get '/movies/:id/similar_movies', to: 'movies#similar_movies_search', as: 'similar_movies'
end


