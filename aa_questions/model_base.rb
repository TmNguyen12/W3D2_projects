# require 'active_support/inflector'

class ModelBase
  # keep in mind what self is within the class method

  def initialize
  end

  def self.find_by_id(id)
    new_obj = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.to_s.downcase}
      WHERE
        id = ?
    SQL
    self.new(new_obj.first)
  end

  def self.all
    new_obj = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.downcase}
    SQL
    new_obj.map {|obj| self.new(obj)}
  end

  def self.where(options)
    conditions = ''
    options.each do |k, v|
      conditions += "#{k} = '#{v}', "
    end
    conditions = conditions[0...-2]
    p conditions
    testing = "fname = 'Jack'"
    new_obj = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.downcase}
      WHERE
        "fname = 'Jack'"
    SQL
    p new_obj
    new_obj.map { |obj| self.new(obj) }
  end

end
