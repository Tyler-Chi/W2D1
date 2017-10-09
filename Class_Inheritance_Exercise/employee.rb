class Employee

  attr_reader :name, :title, :salary

  def initialize(name, title, salary, boss)
    @boss = boss
    if @boss
      @boss.employees << self unless @boss.employees.include?(self)
    end
    @name = name
    @title = title
    @salary = salary
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def boss=(boss)
    @boss = boss
    @boss.employees << self unless @boss.employees.include?(self)
  end

end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss)
    #once you inherit manager into employee, there ALWAYS has to be at least
    #the original initial values, and then you can just have super below it
    #if you want different attributes, then you need to add it to the list
    #BUT THEN. super needs to accept the original four
    #(name, title, salary,boss)

    super #super adds wtv is in the same method of the super class. SAME name
    @employees = []
  end

  def total_salary
    total_salary = 0

    @employees.each do |employee|
      if employee.class == Manager
        total_salary += employee.total_salary #this is method call
      end
      total_salary += employee.salary #this is a attributes
    end
    total_salary
  end

  def bonus(multiplier)
    total_salary * multiplier
  end

end
