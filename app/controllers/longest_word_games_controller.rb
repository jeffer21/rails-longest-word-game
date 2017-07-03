class LongestWordGamesController < ApplicationController
  def game
    @grid = []
    12.times { @grid << ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @attempt = params[:attempt]
    @end_time = Time.now
    @grid = params[:grid]
    @start_time = Time.parse(params[:start_time])
    run_game(@attempt, @grid, @start_time, @end_time)
  end

  private

  def included_in_grid?(attempt, grid)
    attempt.upcase.chars.each do |letter|
      if grid.count(letter) == 0 || attempt.chars.count(letter) > grid.count(letter)
       return false
      end
   end
   true
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    @result = {}

    user_score = 10
    user_message = ""
    data = ""

    time_taken = (end_time - start_time)
    @result[:time] = time_taken.to_i

    api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    open(api_url) do |stream|
      data = JSON.parse(stream.read)
    end

    if included_in_grid?(attempt, grid)
      if data['term0'] != nil
        user_score = attempt.length * 100 + 100 / time_taken.to_i
        user_message = "OK"
      else
        user_message = "not an english word"
        user_score = 0
      end
    else
      user_message = "not in the grid"
      user_score = 0
    end
    @result[:score] = user_score
    @result[:message] = user_message
  end
end
