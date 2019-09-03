class UserAuthenticator
  class AuthenticationError < StandardError
  end

  attr_reader :user
  attr_reader :access_token

  def initialize(code)
    @code = code
  end

  def perform
    raise AuthenticationError if @code.blank? || token.try(:error).present?
    prepare_user
    prepare_access_token
  end

  private
    def client
      @client ||= Octokit::Client.new(
        client_id: Rails.application.credentials.github[:client_id],
        client_secret: Rails.application.credentials.github[:client_secret]
      )
    end

    def token
      @token ||= client.exchange_code_for_token(@code)
    end

    def user_data
      @user_data ||= Octokit::Client.new(access_token: token)
        .user.to_h.slice(:login, :name, :url, :avatar_url)
    end

    def prepare_user
      @user = if User.exists?(login: user_data[:login])
        User.find_by(login: user_data[:login])
      else
        User.create(user_data.merge(provider: "github"))
      end
    end

    def prepare_access_token
      @access_token = if user.access_token.present?
        user.access_token
      else
        user.create_access_token
      end
    end
end
