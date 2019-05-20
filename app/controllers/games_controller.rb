require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:time] = Time.now
    @score = params["score"].to_i
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
    @letters
  end

  def score
    @time_score = ((Time.now - Time.parse(session[:time])) / 100).to_i
    @score = params["score"].to_i
    @word = params["word"]
    @letters = params["grid"].split(//)
    if included?(@word.upcase, @letters)
      if english_word?(@word)
        @score = @score + @word.length + @time_score
        @result = "is a valid English word !"
      else
        @result = "does not seem to be a valid English word..."
      end
    else
      @result = "can't be built out of"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end