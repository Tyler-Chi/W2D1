class Dog
  attr_reader :age
  def initialize(age)
    @age = age
  end
  def method(num)
    num.times { puts "hi!" }
  end

end

class Poodle < Dog
  def initialize(age)
    super
  end


  def method
      puts 'hello'
    super
  end

  def woof
    puts 'woof'
  end
end

a = Poodle.new(5)
