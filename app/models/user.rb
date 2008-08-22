require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of :login, :message => 'Bitte wählen Sie einen Benutzernamen.'
  validates_presence_of :email, :message => 'Bitte geben Sie ihre E-Mail-Adresse ein.'
  validates_presence_of :password, :if => :password_required?, :message => 'Bitte geben Sie ein Passwort an.'
  validates_presence_of :password_confirmation, :if => :password_required?, :message => 'Bitte bestätigen Sie das Passwort.'
  validates_length_of :password, :within => 4..40, :if => :password_required?, :too_short => 'Das Passwort muss mindestens 4 Zeichen lang sein.', :too_long => 'Das Passwort darf höchstens 40 Zeichen lang sein.'
  validates_confirmation_of :password, :if => :password_required?, :message => 'Bitte geben Sie zur Bestätigung das Passwort noch einmal ein.'
  validates_length_of :login, :within => 3..40, :too_short => 'Der Benutzername muss mindestens 3 Zeichen lang sein.', :too_long => 'Der Benutzername darf höchstens 40 Zeichen lang sein.'
  validates_length_of :email, :within => 3..100, :too_short => 'Die angegebene E-Mail-Adresse ist ungültig.', :too_long => 'Die angegebene E-Mail-Adresse ist ungültig.'
  validates_uniqueness_of :login, :message => 'Der Benutzername ist bereits vergeben.'
  validates_uniqueness_of :email, :case_sensitive => false, :message => 'Die E-Mail-Adresse wird bereits verwendet.'
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate( login, password )
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt( password, salt )
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
end
