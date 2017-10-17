require_relative 'database'

class Questions
  attr_reader :id
  attr_accessor :title, :body, :user_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end


end
