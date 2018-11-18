class User
  extend Kuronuri::Mask

  attr_accessor :screen_name
  attr_accessor :email

  mask :email

  def initialize(screen_name, email)
    @screen_name = screen_name
    @email = email
  end
end