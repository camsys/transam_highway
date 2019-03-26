class AdditionalHighwayFields < ActiveRecord::Migration[5.2]
  def change
    create_table :service_on_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    create_table :service_under_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    create_table :historical_significance_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    create_table :bridge_toll_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    create_table :design_load_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    create_table :load_rating_method_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    create_table :bridge_posting_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    create_table :reference_feature_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    add_reference :highway_structures, :highway_significance_type

    add_reference :bridges, :service_on_type
    add_reference :bridges, :service_under_type
    add_reference :bridges, :bridge_toll_type
    add_reference :bridges, :design_load_type
    add_reference :bridges, :operating_rating_method_type
    add_column :bridges, :operating_rating, :decimal, precision: 9, scale: 2
    add_reference :bridges, :inventory_rating_method_type
    add_column :bridges, :inventory_rating, :decimal, precision: 9, scale: 2
    add_reference :bridges, :bridge_posting_type
    add_column :bridges, :max_span_length, :decimal, precision: 9, scale: 2
    add_column :bridges, :left_curb_sidewalk_width, :decimal, precision: 9, scale: 2
    add_column :bridges, :right_curb_sidewalk_width, :decimal, precision: 9, scale: 2
    add_column :bridges, :roadway_width, :decimal, precision: 9, scale: 2
    add_column :bridges, :deck_width, :decimal, precision: 9, scale: 2
    add_column :bridges, :min_vertical_clearance_above, :decimal, precision: 9, scale: 2
    add_reference :bridges, :vertical_reference_feature_below
    add_column :bridges, :min_vertical_clearance_below, :decimal, precision: 9, scale: 2
    add_reference :bridges, :lateral_reference_feature_below
    add_column :bridges, :min_lateral_clearance_below_right, :decimal, precision: 9, scale: 2
    add_column :bridges, :min_lateral_clearance_below_left, :decimal, precision: 9, scale: 2

  end
end
