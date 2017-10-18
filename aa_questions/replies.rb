require_relative 'database'

class Replies < ModelBase
  attr_reader :id, :question_id, :parent_id, :user_id
  attr_accessor :body

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?;
    SQL
    replies.map { |reply| Replies.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?;
    SQL
    replies.map { |reply| Replies.new(reply) }
  end

  def author
    Users.find_by_id(@user_id)
  end

  def question
    Questions.find_by_id(@question_id)
  end

  def parent_reply
    return nil unless @parent_id
    Replies.find_by_id(@parent_id)
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?;
    SQL
    children.map { |child| Replies.new(child) }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body, @id)
        UPDATE
          replies
        SET
          question_id = ?, parent_id = ?, user_id = ?, body = ?
        WHERE
          id = ?;
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body)
        INSERT INTO replies (question_id, parent_id, user_id, body)
        VALUES (?, ?, ?, ?);
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end


end
