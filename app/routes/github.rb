require 'json'
require 'fileutils'
require './app/base/base'

module Pushroulette
  class Github < Pushroulette::Base

    def initialize(app)
      super
      @githubUsers = githubConfig('users')
    end

    post '/github/payload' do
      request.body.rewind  # in case someone already read it
      data = JSON.parse request.body.read
      puts data
      if !data['pusher'].nil?
        username = @githubUsers[data['pusher']['name']]
        repository = data['repository']['name']
        user = user(username)
        puts username
        puts user
        if !user.nil?
          speak("#{username}, pushed to #{repository}")
        end
      end
      hasClip = !user.nil? ? (!user['clip'].nil? ? true : false) : false
      playClip(user.nil? ? nil : user['clip'], !hasClip, user.nil? ? nil : user['genre'], !hasClip)
    end

    def githubConfig(config_key)
      pushrouletteConfig('github')[config_key]
    end
  end
end
