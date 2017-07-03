Rails.application.routes.draw do
  get '/', to: 'longest_word_games#game'

  get 'score', to: 'longest_word_games#score'

  post '/longest_word_games', to: 'longest_word_games#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
