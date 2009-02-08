module ControllerMacros
   def self.included(base)
     base.fixtures :all
     base.integrate_views
   end
end