class AddDefectDefinitions < ActiveRecord::DataMigration
  def up
    defect_definitions = [
      {number: 1000, short_name: 'Corrosion', long_name: 'Corrosion', description: 'This defect is used to report corrosion of metal and other material elements.'},
      {number: 1010, short_name: 'Cracking', long_name: 'Cracking', description: 'This defect is used to report fatigue cracking in metal and other material elements.'},
      {number: 1020, short_name: 'Connection', long_name: 'Connection', description: 'This defect is used to report connection distress in metal and other material elements.'},
      {number: 1080, short_name: 'Delamination/Spall/Patched Area', long_name: 'Delamination/Spall/Patched Area', description: 'This defect is used to report spalls, delamination and patched areas in concrete, masonry and other material elements.'},
      {number: 1090, short_name: 'Exposed Rebar', long_name: 'Exposed Rebar', description: 'This defect is used to report exposed conventional rein-forcing steel in reinforced and prestressed concrete ele-ments.'},
      {number: 1100, short_name: 'Exposed Prestressing', long_name: 'Exposed Prestressing', description: 'This defect is used to report exposed prestressing steel in concrete elements.'},
      {number: 1110, short_name: 'Cracking (PSC)', long_name: 'Cracking (PSC)', description: 'This defect is used to report cracking in prestressed con-crete elements.'},
      {number: 1120, short_name: 'Efflorescence/Rust Staining', long_name: 'Efflorescence/Rust Staining', description: 'This defect is used to report efflorescence/rust staining in concrete and masonry elements.'},
      {number: 1130, short_name: 'Cracking (RC and Other)', long_name: 'Cracking (RC and Other)', description: 'This defect is used to report cracking in reinforced con-crete and other material elements.'},
      {number: 1140, short_name: 'Decay/Section Loss', long_name: 'Decay/Section Loss', description: 'This defect is used to report decay (section loss) in tim-ber elements.'},
      {number: 1150, short_name: 'Check/Shake', long_name: 'Check/Shake', description: 'This defect is used to report checks and shakes in timber elements.'},
      {number: 1160, short_name: 'Crack (Timber)', long_name: 'Crack (Timber)', description: 'This defect is used to report cracking in timber elements.'},
      {number: 1170, short_name: 'Split/Delamination (Timber)', long_name: 'Split/Delamination (Timber)', description: 'This defect is used to report splits/delaminations in tim-ber elements.'},
      {number: 1180, short_name: 'Abrasion', long_name: 'Abrasion/Wear (Timber)', description: 'This defect is used to report abrasion in timber elements.'},
      {number: 1190, short_name: 'Abrasion(PSC/RC)', long_name: 'Abrasion/Wear(PSC/RC)', description: 'This defect is used to report abrasion in concrete elements.'},
      {number: 1220, short_name: 'Deterioration (Other)', long_name: 'Deterioration (Other)', description: 'This defect is used to report general deterioration in elements constructed of other materials such as fiber reinforced plastics or similar.'},
      {number: 1610, short_name: 'Mortar Breakdown (Masonry)', long_name: 'Mortar Breakdown (Masonry)', description: 'This defect is used to report breakdown of masonry mortar between brick, block or stone.'},
      {number: 1620, short_name: 'Split/Spall (Masonry)', long_name: 'Split/Spall (Masonry)', description: 'This defect is used to report splits or spalls in brick, block or stone.'},
      {number: 1630, short_name: 'Patched Area (Masonry)', long_name: 'Patched Area (Masonry)', description: 'This defect is used to report masonry patched areas.'},
      {number: 1640, short_name: 'Masonry Displacement', long_name: 'Masonry Displacement', description: 'This defect is used to report displaced brick, block or stone.'},
      {number: 1900, short_name: 'Distortion', long_name: 'Distortion', description: 'This defect is used to report distortion from the original line or grade of the element. It is used to capture all distortion regardless of cause.'},
      {number: 2210, short_name: 'Movement', long_name: 'Movement', description: 'This defect is used to report movement of bridge bearing elements.'},
      {number: 2220, short_name: 'Alignment', long_name: 'Alignment', description: 'This defect is used to report alignment of bridge bearing elements.'},
      {number: 2230, short_name: 'Bulging', long_name: ' Splitting or Tearing', description: 'Bulging, Splitting or Tearing,This defect is used to report bulging, splitting or tearing of elastomeric bearing elements.'},
      {number: 2240, short_name: 'Loss of Bearing Area', long_name: 'Loss of Bearing Area', description: 'This defect is used to report the loss of bearing area for bridge bearing elements.'},
      {number: 2310, short_name: 'Leakage', long_name: 'Leakage', description: 'This defect is used to report leakage through or around sealed bridge joints.'},
      {number: 2320, short_name: 'Seal Adhesion', long_name: 'Seal Adhesion', description: 'This defect is used to report loss of adhesion in sealed bridge joints.'},
      {number: 2330, short_name: 'Seal Damage', long_name: 'Seal Damage', description: 'This defect is used to report damage to the rubber in bridge joint seals.'},
      {number: 2340, short_name: 'Seal Cracking', long_name: 'Seal Cracking', description: 'This defect is used to report cracking in the rubber in bridge joint seals.'},
      {number: 2350, short_name: 'Debris Impaction', long_name: 'Debris Impaction', description: 'This defect is used to report the accumulation of debris in bridge joint seals that may or may not affect the per-formance of the joints.'},
      {number: 2360, short_name: 'Adjacent Deck or Header', long_name: 'Adjacent Deck or Header', description: 'This defect is used to report concrete deck damage in the area anchoring the bridge joint.'},
      {number: 2370, short_name: 'Metal Deterioration or Damage', long_name: 'Metal Deterioration or Damage', description: 'This defect is used to report metal damage or deteriora-tion in the bridge joint.'},
      {number: 3210, short_name: 'Del/Spall/Patch/Pot(Wear Surf)', long_name: 'Delamination/Spall/Patched Area/Pothole (Wearing Surfaces)', description: 'This defect is used to report spalls, delaminations, patched areas and potholes in wearing surface elements.'},
      {number: 3220, short_name: 'Crack (Wearing Surface)', long_name: 'Crack (Wearing Surface)', description: 'This defect is used to report cracking in wearing surface elements.'},
      {number: 3230, short_name: 'Effectiveness (Wearing Surface)', long_name: 'Effectiveness (Wearing Surface)', description: 'This defect is used to the loss of effectiveness in the protection provided to the deck by the wearing surface elements.'},
      {number: 3410, short_name: 'Chalk(Steel Protect Coatings)', long_name: 'Chalking (Steel Protective Coatings)', description: 'This defect is used to report chalking in metal protective coatings.'},
      {number: 3420, short_name: 'Peel/Bub/Crack(Stl Protect Coat)', long_name: 'Peeling/Bubbling/Cracking (Steel Protective Coatings)', description: 'This defect is used to report peeling, bubbling or crack-ing in metal protective coatings.'},
      {number: 3430, short_name: 'Ox Flm/Txt Adhr(Stl Prot Coat)', long_name: 'Oxide Film Degradation Color/Texture Adherence(Stl Protect Coat)', description: 'This defect is used to report oxide film degradation of texture in metal protective coatings.'},
      {number: 3440, short_name: 'Eff (Stl Protect Coat)', long_name: 'Effectiveness (Steel Protective Coatings)', description: 'This defect is used to report the loss of effectiveness of metal protective coatings.'},
      {number: 3510, short_name: 'Wear (Concrete Protect Coat)', long_name: 'Wear (Concrete Protective Coatings)', description: 'This defect is used to report the wearing of concrete protective coatings.'},
      {number: 3540, short_name: 'Eff(Crete Protect Coat)', long_name: 'Effectiveness (Concrete Protective Coatings)', description: 'This defect is used to report the effectiveness of concrete protective coatings.'},
      {number: 3600, short_name: 'Eff - Protect Sys(e.g. cathodic)', long_name: 'Effectiveness - Protective System (e.g. cathodic)', description: 'This defect is used to report the effectiveness of internal concrete protective systems (epoxy rebar, cathodic pro-tection etc.).'},
      {number: 4000, short_name: 'Settlement', long_name: 'Settlement', description: 'This defect is used to report settlement in substructure elements.'},
      {number: 6000, short_name: 'Scour', long_name: 'Scour', description: 'This defect is used to report scour in substructure elements.'},
      {number: 7000, short_name: 'Damage', long_name: 'Damage', description: 'This defect is used to capture impact damage that has occurred.'}
    ]

    tables = %w{ defect_definitions }

    tables.each do |table_name|
      data = eval(table_name)
      klass = table_name.classify.constantize
      data.each do |row|
        klass.create!(row)
      end
    end
  end
end