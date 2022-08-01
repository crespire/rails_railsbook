# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Add JS for trix and actiontext plus dependencies.
pin "trix", to: "https://ga.jspm.io/npm:trix@2.0.0-beta.0/dist/trix.js"
pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@7.0.3-1/app/javascript/actiontext/index.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.3-1/app/assets/javascripts/activestorage.esm.js"

# Add trix overrides
pin 'trix-editor-overrides', to: 'lib/trix-editor-overrides.js', preload: true