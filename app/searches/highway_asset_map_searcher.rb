# Inventory searcher.
# Designed to be populated from a search form using a new/create controller model.
#
class HighwayAssetMapSearcher < BaseSearcher

  # Include the numeric sanitizers mixin
  include TransamNumericSanitizers

  def self.form_params
    [
    ]
  end

  private

  #---------------------------------------------------
  # Simple Equality Queries
  #---------------------------------------------------


  # Removes empty spaces from multi-select forms

  def remove_blanks(input)
    output = (input.is_a?(Array) ? input : [input])
    output.select { |e| !e.blank? }
  end

end
