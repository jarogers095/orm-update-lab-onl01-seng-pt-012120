require_relative "../config/environment.rb"

class Student
  attr_reader(:id, :name, :grade)
  
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
  end
  
  def self.new_from_db()
    
  end
  
  def self.find_by_name(name)
    
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
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
      DB[:conn].execute(sql, @name, @grade, @id)
  end
end
