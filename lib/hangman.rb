module Hangman
  class Game
    attr_reader :guess_left, :word, :display_word

    GUESS_LIMIT = 10

    def initialize(word)
      @word = word
      @guess_left = GUESS_LIMIT
      @display_word = '_'*word.length
      @done = false
    end

    def guess(letter)
      if @word.include?(letter)
        index = (0..@word.length).find_all { |i| @word[i,1] == letter }
        index.each { |i| @display_word[i] = letter }
      else
        @guess_left -= 1
      end
    end

    def done?
      @done = true if @guess_left == 0 || won?
      @done
    end

    def won?
      !@display_word.include?('_')
    end
  end
end
