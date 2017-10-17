require_relative 'database'
# require 'byebug'

class Questions
  attr_reader :id
  attr_accessor :title, :body, :user_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
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

  def self.find_by_author_id(author_id)
    # byebug
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?;
    SQL
    questions.map { |question| Questions.new(question) }
  end

  def author
    Users.find_by_id(@user_id)
  end

  def replies
    Replies.find_by_question_id(@id)
  end
end
