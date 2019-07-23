class AddInspectionTeamMemberReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :inspection_team_leader
    add_reference :inspections, :inspection_team_member
    add_reference :inspections, :inspection_team_member_alt
  end
end
