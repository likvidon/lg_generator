class User
  include Mongoid::Document

  field :login, type: String
  field :password, type: String

  before_create :send_message

  protected
  def send_message
    puts 'creating User'
  end
end

