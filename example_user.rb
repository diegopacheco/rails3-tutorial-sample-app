class User
  attr_accessor :name, :email

  def initialize(atributes= {})
     @name  = atributes[:name]
     @email = atributes[:email] 
  end   

  def formatted_email
    "#{@name} <#{@email}>"  
  end
end
