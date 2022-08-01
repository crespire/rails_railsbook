# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Add JS for trix and actiontext plus dependencies.
pin "trix", preload: true # @2.0.0
pin "@rails/actiontext", to: "@rails--actiontext.js", preload: true # @7.0.3
pin "@rails/activestorage", to: "@rails--activestorage.js", preload: true # @7.0.3

# Add trix overrides
pin 'trix-editor-overrides', to: 'lib/trix-editor-overrides.js', preload: true