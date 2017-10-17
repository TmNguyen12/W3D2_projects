class ModelBase
  # keep in mind what self is within the class method

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?;
    SQL
    Users.new(user.first)
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    Questions.new(question.first)
  end




end
