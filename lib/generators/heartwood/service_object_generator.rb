require 'rails/generators'

module Heartwood
  class ServiceGenerator < Rails::Generators::Base

    desc "Create a new service object for your app."

    argument :name, required: true

    source_root File.expand_path("../templates", __FILE__)

    def create_service
      filename = "#{name.underscore.chomp('_service')}_service.rb"
      @class_name = "#{name.classify.chomp('Service')}Service"
      template 'service.erb', "app/services/#{filename}"
    end

  end
end
