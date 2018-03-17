require 'rails/generators'

module Heartwood
  class ServiceObjectGenerator < Rails::Generators::Base

    desc "Create a new service object for your app."

    argument :name, required: true

    source_root File.expand_path("../templates", __FILE__)

    def create_service_object
      filename = "#{name.underscore.chomp('_service')}_service.rb"
      @class_name = "#{name.classify.chomp('Service')}Service"
      template 'service_object.erb', "app/services/#{filename}"
    end

  end
end
