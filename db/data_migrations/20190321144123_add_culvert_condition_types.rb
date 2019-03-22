class AddCulvertConditionTypes < ActiveRecord::DataMigration
  def up
    culvert_condition_types = [
        {active: true, code: 'N', name: 'Not applicable', description: 'Used if structure is not a culvert.'},
        {active: true, code: '9', name: 'Excellent', description: 'No deficiencies.'},
        {active: true, code: '8', name: 'Very good', description: 'No noticeable or noteworthy deficiencies which affect the condition of the culvert. Insignificant scrape marks caused by drift.'},
        {active: true, code: '7', name: 'Good', description: 'Shrinkage cracks, light scaling and insignificant spalling which does not expose reinforcing steel. Insignificant damage caused by drift with no misalignment and not requiring corrective action. Some minor scouring has occurred near curtain walls, wingwalls or pipes. Metal culverts have a smooth symmetrical curvature with superficial corrosion and no pitting.'},
        {active: true, code: '6', name: 'Satisfactory', description: 'Deterioration or initial disintegration, minor chloride contamination, cracking with some leaching, or spalls on concrete or masonry walls and slabs. Local minor scouring at curtain walls, wingwalls or pipes. Metal culverts have a smooth curvature, non-symmetrical shape, significant corrosion or moderate pitting.'},
        {active: true, code: '5', name: 'Fair', description: 'Moderate to major deterioration or disintegration, extensive cracking and leaching or spalls on concrete or masonry walls and slabs. Minor settlement or misalignment. Noticeable scouring or erosion at curtain walls, wingwalls or pipes. Metal culverts have significant distortion and deflection in one section, significant corrosion or deep pitting.'},
        {active: true, code: '4', name: 'Poor', description: 'Large spalls, heavy scaling, wide cracks, considerable efflorescence or opened construction joint permitting loss of backfill. Considerable settlement or misalignment. Considerable scouring or erosion at curtain walls, wingwalls or pipes. Metal culverts have significant distortion and deflection throughout, extensive corrosion or deep pitting.'},
        {active: true, code: '3', name: 'Serious', description: 'Any condition described in Code 4 but which is excessive in scope. Severe movement or differential settlement of the segments or loss of fill. Holes may exist in walls or slabs. Integral wingwalls nearly severed from culvert. Severe scour or erosion at curtain walls, wingwalls or pipes. Metal culverts have extreme distortion and deflection in one
    section, extensive corrosion, or deep pitting with scattered perforations.'},
        {active: true, code: '2', name: 'Critical', description: 'Integral wingwalls collapsed, severe settlement of roadway due to loss of fill. Section of culvert may have failed and can no longer support embankment. Complete undermining at curtain walls and pipes. Corrective action required to maintain traffic. Metal culverts have extreme distortion and deflection and deflection throughout with extensive perforations due to corrosion.'},
        {active: true, code: '1', name: 'Imminent failure', description: 'Bridge closed. Corrective action may put back in light service.'},
        {active: true, code: '0', name: 'Failed', description: 'Bridge closed. Replacement necessary.'}

    ]

    culvert_condition_types.each{|condition_type| CulvertConditionType.create!(condition_type)}
  end
end