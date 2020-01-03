module HasAssemblyTypes
  #-----------------------------------------------------------------------------
  #
  # HasAssemblyTypes
  #
  # Mixin that adds association to AssemblyTypes
  #
  #-----------------------------------------------------------------------------
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :assembly_types
  end

end
