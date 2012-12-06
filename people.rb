class Hash
  def symbolize_keys
    dup.symbolize_keys!
  end
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

class Person
  attr_accessor :email, :name
  def initialize(hash)
    hash.symbolize_keys!
    @name = hash[:name]
    @email = hash[:email]
  end
  def to_s
    "#{@name} <#{@email}>"
  end
end

class People < Array
  attr_accessor :title

  def initialize(array=[])
    super
    self.shuffle!
    self.delete_if {|v| ( !v.is_a? Hash ) or v.symbolize_keys[:name].blank? or v.symbolize_keys[:email].blank? }
    self.collect! {|elm| Person.new(elm) }
  end
  def [](idx)
    idx = idx%length if length > 0
    super
  end

  def send_emails
    mailer = Mandrill::API.new
    emails = []
    self.each_with_index do |person, index|
      config = {
        html: "You have to give a gift to: #{self[index+1].name}",
        from_email: "santa@pytera.com",
        from_name: "Secret Santa",
        subject: "SecretSanta - #{title}",
        to: [
          {email:person.email, name:person.name}
        ],
        async: true
      }
      mailer.messages.send config
    end
    true
  end
end