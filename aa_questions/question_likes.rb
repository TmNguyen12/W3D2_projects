require_relative 'database'

class QuestionLikes
  attr_reader :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON user_id = id
      WHERE
        question_id = ?;
    SQL
    likers.map { |liker| Users.new(liker) }
  end

  def self.num_likes_for_question_id(question_id)
    num = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id) AS count
      FROM
        question_likes
      WHERE
        question_id = ?
      GROUP BY
        question_id;
    SQL
    num.first['count']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_id
      WHERE
        question_likes.user_id = ?;
    SQL
    questions.map { |question| Questions.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      GROUP BY
        questions.title
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        ? ;
    SQL
    questions.map { |question| Questions.new(question) }
  end

end
