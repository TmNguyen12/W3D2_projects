require_relative 'database'

class QuestionFollows
  attr_reader :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
