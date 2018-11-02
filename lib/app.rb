def get_random_word
  word = ''
  while word.length < 4 || word.length > 13
    word = File.readlines('../data/5desk.txt').sample.chomp
  end
  return word.downcase
end

class Game
  def initialize(random_word)
    @random_word = random_word.split('')
    @already_chosen = []
    @wrong_tries = 0
    @progress = []
    @random_word.each {|i| @progress.push('_')}
    @loaded_game = false
  end

  def user_choose_letter
    puts @progress.join(' ')
    puts "Pick a new letter, to save type 'save'"
    letter = gets.chomp.downcase
    if letter == 'save'
      marshal_dump()
      abort
    end
    while @already_chosen.include? letter
      if @already_chosen.include? letter
        puts "You've already chosen #{letter}! Pick a new letter!"
      end
      letter = gets.chomp.downcase
    end
    @already_chosen.push(letter)
    if @random_word.include? letter
      @random_word.each_with_index do |val, index|
        @progress[index] = val if val == letter
      end
      puts "Yes! #{letter} is in the word!"
    else
      puts "Letter #{letter} is not in the word!"
      @wrong_tries += 1
      puts "You have #{@wrong_tries} wrong tries"
    end
  end

  def play
    if File.file?('../data/marshal.dump')
      puts "Saved game detected, would you like to load it?"
      if gets.chomp == 'y'
        puts "Loading game!"
        marshal_load()

      end
    end
    while @progress.include? '_'
     user_choose_letter()
    end
    puts "You won! The word is #{@progress.join('')}"
    if @loaded_game == true
      File.delete('../data/marshal.dump') if File.exist?('../data/marshal.dump')
    end
  end

  def marshal_dump
    my_data = [@random_word, @already_chosen, @wrong_tries, @progress]
    File.open('../data/marshal.dump', 'w') { |f| f.write(Marshal.dump(my_data))}
    puts "Game Saved!"
  end

  def marshal_load
    my_data = Marshal.load(File.read('../data/marshal.dump'))
    @random_word = my_data[0]
    @already_chosen = my_data[1]
    @wrong_tries = my_data[2]
    @progress = my_data[3]
    puts "Saved game loaded!"
    @loaded_game = true
  end
end

game = Game.new(get_random_word)
game.play