class CreateJoinTableDefectDefintionsElementDefinition < ActiveRecord::Migration[5.2]
  def change
    create_join_table :defect_definitions, :element_definitions do |t|
      t.index [:element_definition_id, :defect_definition_id],
              name: 'idx_defect_defintions_element_definitions'
    end
  end
end
