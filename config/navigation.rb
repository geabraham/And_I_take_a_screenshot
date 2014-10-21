# Simple Navigation config

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'dropdown-menu'
    primary.item :sandman, 'Intro', '/sandman'
    primary.item :platform_layout, 'Platform Layout', '/sandman/platform_layout'
    primary.item :generator, 'Rails Generator', '/sandman/generator'
    primary.item :cdn, 'CDN Assets', '/sandman/cdn'
    primary.item :asset_sync, 'Asset Sync', '/sandman/asset_sync'
    primary.item :mixins, 'Mixins', '/sandman/mixins'
    primary.item :platform_layout, 'Two Column Layout', '/sandman/sidebar'
    primary.item :buttons, 'Buttons', '/sandman/buttons'
    primary.item :icons, 'Icons', '/sandman/icons'
    primary.item :forms, 'Forms', '/sandman/forms'
    primary.item :panels, 'Panels', '/sandman/panel'
    primary.item :underscore, 'Underscore.js', '/sandman/underscore'
    primary.item :validate, 'Validation Plugin', '/sandman/validate'
    primary.item :select2, 'Select2', '/sandman/select2'
    primary.item :select2, 'Datepicker', '/sandman/datepicker'
  end
end
