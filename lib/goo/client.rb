require 'goo'
require 'google/api_client'

class Goo::Client
  NAME = ENV['GOO_APPNAME'] || 'goo'
  VERSION = ENV['GOO_APPVERSION'] || Goo::VERSION

  attr_reader :email
  attr_reader :key_file
  attr_reader :apis_config
  def initialize email, key_file, apis_config
    @email = email
    @key_file = key_file
    @apis_config = apis_config
  end

  def key
    @key ||= ::Google::APIClient::KeyUtils.load_from_pkcs12 key_file, 'notasecret'
  end

  def auth
    if @auth.nil?
      @auth = Signet::OAuth2::Client.new(
       :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
       :audience => 'https://accounts.google.com/o/oauth2/token',
       :scope => scopes,
       :issuer => email,
       :signing_key => key
      )
      @auth.fetch_access_token!
    end
    @auth
  end

  def scopes
    @scopes ||= apis_config.values.collect {|api_config| api_config[:scope]}
  end

  def driver
    @driver ||= ::Google::APIClient.new(
      application_name: NAME,
      application_version: VERSION
    )
  end

  def api name
    api_config = apis_config[name.to_sym]
    raise "unknown google api: #{name}" unless api_config
    result = driver.discovered_api *[name, api_config[:version] ? api_config[:version] : 'v1']
    unless respond_to? name
      singleton_class.send :define_method, name.to_sym do
        result
      end
    end
    result
  end

  def get_api_object string
    api_name, *other = string.split '.'
    other.inject api(api_name) do |method, part|
      method = method.send part.underscore
    end
  end

  def execute string, parameters = nil
    api_method = get_api_object string
    options = {
      api_method: api_method,
      authorization: auth
    }
    options[:parameters] = parameters if parameters
    res = driver.execute options
    unless res.success?
      puts "'#{string}' request failed (#{res.status})"
      puts res.headers
      puts res.body
      return nil
    end
    res.data ? res.data.to_hash : nil
  end
end
