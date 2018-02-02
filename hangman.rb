class Hangman

  def initialize()
    @board = ["_","_","_","_","_","_","_","_"]
    @available_letters = ("a".."z").to_a
    @the_word = ""
    @remaining_guesses = 7
    @chosen_letters = []
    @correct_letters = []
    @wrong_letters = []
  end

  def play
    #game_menu
    secret_word
    turn
  end

  def letters_available
    @available_letters.each { |letter| print letter }
  end

  def letters_in_word
    @the_word.size-1
  end

  def divider
    50.times {print "="}
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
    letters_in_word
    puts "Let's play hangman! Enter a letter."
    while @remaining_guesses > 0
      letter_choice = gets.chomp.downcase
      @chosen_letters << letter_choice
      @available_letters.delete(letter_choice)
        if @the_word.include? letter_choice
          word_letters = @the_word.scan /\w/
          correct_letter_index = word_letters.each_index.select{|i| word_letters[i] == letter_choice}
          #p correct_letter_index
          correct_letter_index.each { |index| @board[index] = letter_choice }
          @correct_letters << letter_choice
          puts "That's a bingo! '#{letter_choice}' is in the word!"
        else #need to include a message if you select an already selected letter
          @wrong_letters << letter_choice
          puts "WRONG! '#{letter_choice}' is not in the word."
        end
      @remaining_guesses -= 1
      display_board
      display_remaining_guesses
    end
      game_over
  end

  def game_over
    puts "Game Over!"
  end

  def display_wrong_letters
     puts "These are your wrong guesses:"
     @wrong_letters.each { |letter| print letter }
     puts
  end

  def display_available_letters
    puts "Available letters:"
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
    letters_in_word.times { |x| print @board[x] }
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
end


Hangman.new.play
