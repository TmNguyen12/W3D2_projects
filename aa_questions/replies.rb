require_relative 'database'

class Replies
  attr_reader :id, :question_id, :parent_id, :user_id
  attr_accessor :body

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']

    # finish putting these in after lunch
  end

end
