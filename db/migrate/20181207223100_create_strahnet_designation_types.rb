class CreateStrahnetDesignationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :strahnet_designation_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active

    end
  end
end
