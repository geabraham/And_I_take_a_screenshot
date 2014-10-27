# Simple Navigation config

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'dropdown-menu'

    primary.item :platform_layout, 'Under Construction', '/construction'

  end
end
