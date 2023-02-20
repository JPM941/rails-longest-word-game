require "json"
require "open-uri"

class ApplicationController < ActionController::Base
  def new
    @letters = []
    @letters += Array.new(11) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].downcase.split(" ")
    @score_number = 0
    @ready = false
    @simple_result = params[:result]
    @result = params[:result].split("")

    url = "https://wagon-dictionary.herokuapp.com/#{@simple_result}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    if user["found"]
      @result.each do |each|
        var = each.match(/#{@letters}/)
        if var
          @letters.delete_at(@letters.index(each))
          @ready = true
        else
          @ready = false
        end
      end
      if @ready == true
        @score_number += @result.size.to_i
      else
        @score_number = "Wrong word"

      end
    else
    @score_number = "Wrong word"
    end
  end

end
