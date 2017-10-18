require_relative 'database'

class Users < ModelBase
  attr_reader :id
  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?;
    SQL
    users.map { |user| Users.new(user) }
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(question_likes.user_id) / CAST(COUNT(DISTINCT(questions.title)) AS FLOAT) AS avg_karma
    FROM
      users
    JOIN
      questions
      ON users.id = questions.user_id
    LEFT OUTER JOIN
      question_likes
      ON questions.id = question_likes.question_id
    WHERE
      users.id = ?
    GROUP BY
      users.id;
    SQL
    karma.first['avg_karma']
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?;
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO users (fname, lname)
        VALUES (?, ?);
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
