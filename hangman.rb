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
    turn
  end

  def letters_in_word
    @the_word.length
  end

  def divider
    50.times {print "."}
    puts
  end

  def game_menu
    divider
    puts "MENU"
    puts "1 to see avialable letters"
    puts "2 to see your incorrectly guessed letters"
    puts "3 to save the game"
    puts "4 to load the game"
    puts "5 to quit the game"
    divider
  end

  def turn
    display_board
    display_remaining_guesses
    puts "Enter a letter."
    while @remaining_guesses > 0
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
        divider
        display_available_letters
        display_wrong_letters
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
