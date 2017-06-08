require 'rspec'
require './hangman.rb'

describe Hangman do
	shared_examples 'a winning game' do
		it 'is done' do
			expect(game.done?).to be_truthy
		end

		it 'won' do
			expect(game.won?).to be_truthy
		end
	end

	shared_examples 'an unfinish game' do
		it 'is not done' do
			expect(game.done?).to be_falsey
		end

		it 'has not win' do
			expect(game.won?).to be_falsey
		end
	end

	shared_examples 'a lose game' do
		it 'is not done' do
			expect(game.done?).to be_truthy
		end

		it 'has lose' do
			expect(game.won?).to be_falsey
		end
	end

	let(:guess) { 'somewhere' }
	let(:guess_limit) { Hangman::GUESS_LIMIT }
	let(:all_hidden) { '_________' }
	let(:game) { Hangman.new(guess) }

	context 'when new game start' do
		it 'picks a word on new game' do
			expect(game.word).to be_truthy
		end

		it 'starts with 10 guesses' do
			expect(game.guess_left).to eq(guess_limit)
		end

		it 'shows all letter is hidden' do
			expect(game.display_word).to eq(all_hidden)
		end

		it_behaves_like 'an unfinish game'
	end

	context 'when guessing the wrong letter' do
		before(:each) { game.guess('a') }

		it 'will decrement guesses' do
			expect(game.guess_left).to eq(9)
		end	

		it 'won\'t reveal any letter' do
			expect(game.display_word).to eq(all_hidden)
		end

		it_behaves_like 'an unfinish game'
	end

	context 'when guessing the right letter' do
		let(:reveal_s) { 's________' }
		let(:reveal_se) { 's__e__e_e' }

		before(:each) { game.guess('s') }

		it 'won\'t decrement guesses' do
			expect(game.guess_left).to eq(guess_limit)
		end

		it 'will reveal the guess letter position' do
			expect(game.display_word).to eq(reveal_s)
			game.guess('e')
			expect(game.display_word).to eq(reveal_se)
		end
	end

	context 'when guess expire on guesses' do
		before(:each) { guess_limit.times { game.guess('a') } }

		it_behaves_like 'a lose game'
	end

	context 'when find all characters' do
		before(:each) { game.guess('a') }

		context 'when guess is 1 character' do
			let(:guess) { 'a'}
			it_behaves_like 'a winning game'
		end

		context 'when guess has multiple characters' do
			let(:guess) { 'aaaa' }
			it_behaves_like 'a winning game'
		end

		context 'when guess has different characters' do
			let(:guess) { 'aabbaa' }
			before(:each) { game.guess('b') }

			it_behaves_like 'a winning game'
		end
	end
end
