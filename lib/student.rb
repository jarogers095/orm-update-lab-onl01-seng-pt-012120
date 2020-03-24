require_relative "../config/environment.rb"

class Student
  attr_reader(:id)
  attr_accessor(:name, :grade)
  
  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table()
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);"
    DB[:conn].execute(sql)
  end
  
  def self.drop_table()
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end
  
  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save()
  end
  
  def self.new_from_db(row)
    new_student = Student.new(row[0], row[1], row[2])
    return new_student
  end
  
  def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?;"
      found_student = Student.new_from_db(DB[:conn].execute(sql, name).first)
      return found_student
  end
  
  def save()
    if @id == nil
      sql = "INSERT INTO students (name, grade) VALUES (?,?);"
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    else
      self.update()
    end
  end
  
  def update()
    if @id == nil
      self.save
    else
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
      DB[:conn].execute(sql, @name, @grade, @id)
    end
  end
end
