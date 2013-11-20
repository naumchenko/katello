require 'ui_alchemy-rails'

module Bastion
  class Engine < ::Rails::Engine
    isolate_namespace Bastion

    initializer "bastion.assets.paths", :group => :all do |app|
      app.config.assets.paths << Bastion::Engine.root.join('app', 'assets')
      app.config.assets.paths << Bastion::Engine.root.join('vendor', 'assets', 'components')
      app.config.assets.paths << Bastion::Engine.root.join('vendor', 'assets', 'components', 'font-awesome')
      app.config.assets.paths << Bastion::Engine.root.join('vendor', 'assets', 'components', 'rcue')

      # Slight hack due to how import loading of SCSS looks up paths
      app.config.assets.paths << "#{::UIAlchemy::Engine.root}/vendor/assets/ui_alchemy/alchemy-forms"
      app.config.less.paths << "#{Rails.root}/vendor/assets/components"

      app.middleware.use ::ActionDispatch::Static, "#{root}/app/assets/bastion"
      app.middleware.use ::ActionDispatch::Static, "#{root}/app/assets/bootstrap"

      app.config.assets.precompile << proc do |path|
        full_path = Rails.application.assets.resolve(path).to_path
        if path =~ /\.(css|js)\z/
          if full_path.include?("bastion.js")
            puts "Including Bastion master JS file"
            true
          elsif full_path.include?("bastion.scss")
            puts "Including Bastion master SCSS file"
            true
          elsif full_path.include?("bastion.less")
            puts "Including Bastion master LESS file"
            true
          else
            false
          end
        else
          false
        end
      end

    end
  end
end
