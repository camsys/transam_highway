class AddSshmlPropertyTypes < ActiveRecord::DataMigration
  def up
    mast_arm_frame_types = [
        {name: 'Single arm', code: 'SNGL ARM', active: true},
        {name: 'Double-arm', code: 'DBL ARM', active: true},
        {name: 'Double-arm truss', code: 'DBL ARM TRUSS', active: true},
        {name: 'Box beam truss', code: 'BOX BEAM TRUSS', active: true},
        {name: 'Triple arm', code: 'TRI ARM', active: true},
        {name: 'Monotube', code: 'MONOTUBE', active: true},
        {name: 'High-mast light', code: 'HML', active: true},
        {name: 'Span wire', code: 'SPAN WIRE', active: true},
        {name: 'Nonstandard', code: 'OTHER', active: true}
    ]

    column_types = [
        {name: 'Single tapered column', code: 'SNGTC', active: true},
        {name: 'Single uniform column', code: 'SNGUC', active: true},
        {name: 'Monotube column', code: 'MTUBE', active: true},
        {name: 'Split monotube column', code: 'SPTBE', active: true},
        {name: 'Double uniform column', code: 'DBLUC', active: true},
        {name: 'Built-up column', code: 'BLTUC', active: true}
    ]

    foundation_types = [
        {name: 'Buried, not visible, or otherwise not accessible', code: '0', active: true},
        {name: 'Caisson', code: '1', active: true},
        {name: 'Median barrier wall', code: '2', active: true},
        {name: 'Formed concrete, rectangle', code: '3', active: true},
        {name: 'Formed concrete, round', code: '4', active: true},
        {name: 'Other', code: '5', active: true}
    ]

    ['mast_arm_frame_types', 'column_types', 'foundation_types'].each do |prop|
      eval(prop).each do |type|
        prop.classify.constantize.create!(type)
      end
    end
  end
end