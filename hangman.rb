require "yaml"

class Hangman

  def initialize()
    @board = ["_","_","_","_","_","_","_","_","_","_","_","_"]
    @available_letters = ("a".."z").to_a
    @the_word = ""
    @remaining_guesses = 6
    @chosen_letters = []
    @correct_letters = []
    @wrong_letters = []
  end

  def play
    #game_menu
    secret_word
    menu
    #turn
  end

  def letters_in_word
    @the_word.length
  end

  def divider
    50.times {print "."}
    puts
  end

  def save_game(game_data)
    File.open('game_save.txt', 'w') { |f| f.puts game_data.to_yaml }
  end

  def load_game
    game_load = File.open('game_save.txt', 'r')
    game_data = YAML.load(game_load)
    game_data
  end

  def save_prompt
    puts "Would you like to save your game? (y/n)"
    opt_save = gets.chomp.downcase
    if opt_save == 'y'
      game_data = [@the_word, @available_letters, @remaining_guesses, @chosen_letters, @correct_letters, @wrong_letters]
      save_game(game_data)
      puts '---Game saved---'
    elsif opt_save == 'n'
      turn
    else
      puts "Invalid response"
      save_prompt
    end
  end

  def menu
    puts "Welcome to hangman."
    puts "Type 'play' to start playing."
    puts "Type 'load' to open a saved game."
    divider
    menu_choice = gets.chomp.downcase
    if menu_choice == 'play'
      turn
    elsif menu_choice == 'load'
      game_data = load_game
      @the_word = game_data[0]
      @available_letters = game_data[1]
      @remaining_guesses = game_data[2]
      @chosen_letters = game_data[3]
      @correct_letters = game_data[4]
      @wrong_letters = game_data[5]
      puts '---Game loaded---'
      turn
    else
      puts "Invalid Entry"
      menu
    end
  end

  def turn
    display_board
    display_remaining_guesses

    while @remaining_guesses > 0
      puts "Enter a letter."
      letter_choice = gets.chomp.downcase
      if @chosen_letters.include? letter_choice
        puts "Already selected. Try Again!"
        turn
      end
      @chosen_letters << letter_choice
      @available_letters.delete(letter_choice)
        if @the_word.include? letter_choice
          word_letters = @the_word.scan /\w/
          correct_letter_index = word_letters.each_index.select{|i| word_letters[i] == letter_choice}
          #p correct_letter_index
          correct_letter_index.each { |index| @board[index] = letter_choice }
          @correct_letters << letter_choice
          puts "Correct!"
        else #need to include a message if you select an already selected letter
          @wrong_letters << letter_choice
          puts "Incorrect"
          @remaining_guesses -= 1
        end
        display_board
        display_remaining_guesses
        display_available_letters
        display_wrong_letters
        save_prompt
        divider
    end
      game_over
      display_secret_word
  end

  def game_over
    puts "Game Over!"
  end

  def display_wrong_letters
     puts "Incorrect:"
     @wrong_letters.each { |letter| print letter }
     puts
  end

  def letters_available
    @available_letters.each { |letter| print letter }
  end

  def display_available_letters
    puts "Available:"
    letters_available
    puts
  end

  def display_remaining_guesses
    puts "#{@remaining_guesses} guesses remaining"
  end

  def display_chosen_letters
    puts "Guessed letters:"
    @chosen_letters.each { |letter| print letter }
    puts
  end

  def display_board
    (letters_in_word-1).times { |x| print @board[x] }
    puts
    #puts "#{@board[0]} #{@board[1]} #{@board[2]} #{@board[3]} #{@board[4]} #{@board[5]} #{@board[6]} #{@board[7]}"
  end

  def secret_word
    valid_words = File.open('dictionary.txt').select do |word|
      word_length = word.length
      word_length >= 5 && word_length <= 12
    end
    @the_word = valid_words.sample.downcase
    #puts "The word is: #{@the_word}"
  end

  def display_secret_word
    puts "The word was: #{@the_word}"
  end
end

Hangman.new.play
