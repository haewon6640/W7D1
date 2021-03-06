# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    attr_reader :password
    validates :session_token, presence: true
    validates :password_digest, presence: {message: 'Password can\'t be blank'}
    validates :password, length: {minimum: 6, allow_nil: true}
    after_initialize :ensure_session_token
    
    has_many :cats,
        foreign_key: :user_id,
        class_name: :Cat
    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def self.find_by_credentials(user_name, password)
        @user = self.find_by(user_name: user_name)
        if @user && @user.is_password?(password)
            return @user
        else
            return nil
        end
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    private 
    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
