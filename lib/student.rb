class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
    # find the student in the database given a name
    # return a new instance of the Student class
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    grade_9 = []
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, 9).map do |row|
      grade_9 << self.new_from_db(row)
    end
    grade_9
  end

  def self.students_below_12th_grade
    grade_not_12 = []
    sql = <<-SQL
    SELECT * FROM students WHERE grade < ?
    SQL
    DB[:conn].execute(sql, 12).map do |row|
      grade_not_12 << self.new_from_db(row)
    end
    grade_not_12
  end

  def self.first_X_students_in_grade_10(x)
    first_from_10 = []
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL
    DB[:conn].execute(sql, 10, x).map do |row|
      first_from_10 << self.new_from_db(row)
    end
    first_from_10
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ? LIMIT 1
    SQL
    first_in_10 = DB[:conn].execute(sql, 10).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(x)
    all_in_grade = []
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    first_in_10 = DB[:conn].execute(sql, x).map do |row|
      all_in_grade << self.new_from_db(row)
    end
    all_in_grade
  end

  



end
