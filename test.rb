#!/usr/bin/env ruby

require 'rubygems'
require 'httparty'
require 'pry'

HOST = 'http://localhost:3000/v1'

ACCESS_TOKEN = '15d0459f01994427ad2893c7a109cdf0'

def request type, path, options={}
  url = File.join(HOST, path)
  options[:query] ||= {}
  options[:query][:access_token] = ACCESS_TOKEN
  HTTParty.public_send(type, url, options)
end

%w{get put post delete patch head}.each do |method|
  define_method method do |*args|
    request method, *args
  end
end


users = get '/users'

user = post('/users',
  :query => {
    "user" => {
      "name"                  => "Steven Miller",
      "email"                 => 'steve@gmail.com',
      "password"              => 'password',
      "password_confirmation" => 'password',
      "roles"                 => ['student'],
    }
  }
)

Pry.start
