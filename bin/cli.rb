#!/usr/bin/env ruby

require './lib/hangman.rb'

def pick_random_word
	word = ''
	while word.size < 5
		word = File.readlines('/usr/share/dict/words').sample.chomp.downcase
	end
	word
end

def divider
	puts '*'*80
end

def display_error
	puts 'Please enter a valid letter.'
end

def display_game(game)
	word = game.display_word
	divider
	puts word.split('').zip((' '*(word.length - 1)).split('')).flatten.join
	puts "#{game.guess_left} guess is left"
	print 'Guess a letter: '
end

def display_end(game)
	divider
	puts "The word is #{game.word}"
	game.won? ? 'You won!' : 'Loser....'
end

def main
	game = Hangman::Game.new(pick_random_word)

	begin
		display_game(game)

		user_input = gets.chomp
		if user_input.length == 1 && user_input =~ /[[:alpha:]]/
			game.guess(user_input.downcase)
		else
			display_error
		end
	end until game.done?

	display_end(game)
end

main if __FILE__ == $0
