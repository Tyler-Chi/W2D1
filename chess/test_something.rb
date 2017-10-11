
module Dog
  def woof
    woof1
  end

  def change_age
    @age = 6
  end

end

class Animal
  attr_accessor :age

  def woof1
    puts 'woof'
  end
  def initialize(age)
    @age = age
    #type is going to be a string that refers
    #to what type of animal it is
  end

  # def tester
  #   self.extend(Dog) if self.type == "dog"
  # end

  include Dog


end

class Mammal
  include Dog
end

joe = Animal.new(5)
p joe.age
joe.change_age
p joe.age
