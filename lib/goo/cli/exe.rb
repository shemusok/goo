require 'goo/client'

require 'thor'
require 'yaml'

module Goo::CLI
  class Exe < Thor
    no_commands {
      class_option :email, {
        desc: 'service account email',
        default: ENV['GOO_EMAIL'],
        aliases: '-e'
      }
      class_option :key_file, {
        desc: 'service account p12 key file',
        default: ENV['GOO_P12KEYFILE'],
        aliases: '-k'
      }

      DEFAULT_APIS = {
        webmasters: {
          version: 'v3',
          scope: 'https://www.googleapis.com/auth/webmasters'
        },
        siteVerification: {
          scope: 'https://www.googleapis.com/auth/siteverification'
        }
      }

      def client
        @client ||= Goo::Client.new(
          options[:email],
          options[:key_file],
          DEFAULT_APIS
        )
      end

      def say msg
        puts msg
      end

      def show obj
        puts obj.to_yaml
      end
    }

    desc 'call [options] api.[resources.]method', 'Executes google api method'
    method_option :parameters, {
      type: :hash,
      desc: 'api call parameters, ',
      aliases: '-p'
    }
    def call api_method
      result = client.execute api_method, options[:parameters]
      show result
      result
    end

    desc 'info [options] api.[resources.]method', 'show help for google api/resource/method'
    def info string
      obj = client.get_api_object string
      case obj
      when ::Google::APIClient::API
        say "#{obj.title} #{obj.version}"
        say obj.description
        unless obj.discovered_resources.empty?
          say "Resources:"
          obj.discovered_resources.each do |r|
            d = r.description
            say "  #{r.name}#{d ? " - #{d}" : ""}"
          end
        end
        unless obj.discovered_methods.empty?
          say "Methods:"
          obj.discovered_methods.each do |m|
            d = m.description
            say "  #{m.name}#{d ? " - #{d}" : ""}"
          end
        end
      when ::Google::APIClient::Resource
        say obj.description if obj.description
        unless obj.discovered_resources.empty?
          say "Resources:"
          obj.discovered_resources.each do |r|
            d = r.description
            say "  #{r.name}#{d ? " - #{d}" : ""}"
          end
        end
        unless obj.discovered_methods.empty?
          say "Methods:"
          obj.discovered_methods.each do |m|
            d = m.description
            say "  #{m.name}#{d ? " - #{d}" : ""}"
          end
        end
      when ::Google::APIClient::Method
        say obj.description if obj.description
        unless obj.parameters.empty?
          say "Parameters"
          obj.parameter_descriptions.each do |n, p|
            d = p['description']
            r = p['required']
            say "  #{n}(#{p['type']})#{d ? " - #{d} " : " "}#{r ? "Required" : "Optional"}"
          end
        end
      end
      obj
    end
  end
end
