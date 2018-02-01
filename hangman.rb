class Hangman

  def initialize()
    @board = ["_","_","_","_","_","_","_","_"]
    @available_letters = ("a".."z").to_a
    @the_word = ""
  end

  def play
    secret_word
    puts "Let's play hangman!"
    display_board
    turn
  end

  def letters
    @available_letters.each { |letter| print letter }
  end

  def letters_in_word
    @the_word.size-1
  end

  def turn
    remaining_guesses = 7
    chosen_letters = []
    correct_letters = []
    wrong_letters = []
    letters_in_word
    while remaining_guesses > 0
      puts
      puts "You have #{remaining_guesses} guesses. \nAvailable letters:"
      letters
      puts
      letter_choice = gets.chomp.downcase
      chosen_letters << letter_choice
      puts
      @available_letters.delete(letter_choice)
        if @the_word.include? letter_choice
          word_letters = @the_word.scan /\w/
          correct_letter_index = word_letters.each_index.select{|i| word_letters[i] == letter_choice}
          #p correct_letter_index
          correct_letter_index.each { |index| @board[index] = letter_choice }
          correct_letters << letter_choice
          puts "Yes, #{letter_choice} is in the word!"
          puts
        else #need to include a message if you select an already selected letter
          wrong_letters << letter_choice
          puts "No, I'm sorry, #{letter_choice} is not in the word."
          puts
        end
      remaining_guesses -= 1
      puts "REMINDER: These are the letters you've already guessed:"
      chosen_letters.each { |letter| print letter }
      puts
      puts "These are your wrong guesses:"
      wrong_letters.each { |letter| print letter }
      puts
      display_board
      puts
    end
      game_over
  end

  def game_over
    puts "Game Over!"
  end



  def display_board
    letters_in_word.times { |x| print @board[x] }
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
