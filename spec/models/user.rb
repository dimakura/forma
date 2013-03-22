# -*- encoding : utf-8 -*-
class User
  include Forma::Init
  attr_accessor :email
  attr_accessor :first_name
  attr_accessor :last_name

  def full_name
    "#{first_name} #{last_name}"
  end

end
