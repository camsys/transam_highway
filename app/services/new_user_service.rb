#------------------------------------------------------------------------------
#
# NewUserService
#
# Contains business logic associated with creating new users
#
#------------------------------------------------------------------------------

class NewUserService

  def build(form_params)

    user = User.new(form_params)
    # Set up a default password for them
    user.password = SecureRandom.base64(8)
    # Activate the account immediately
    user.active = true
    # Override opt-in for email notifications
    user.notify_via_email = true

    return user
  end

  # Steps to take if the user was valid
  def post_process(user, assume_user_exists=false)

    user.update_user_organization_filters unless Rails.application.config.try(:user_organization_filters_ignored).present?


    if user.has_role? :manager
      if user.organization_ids.include? HighwayAuthority.first.id
        user.viewable_organizations = Organization.all
      else
        user.viewable_organizations.clear
        user.viewable_organizations << HighwayAuthority.first

        user.organizations.each do |org|
          user.viewable_organizations << org unless user.viewable_organizations.include? org
          typed_org = Organization.get_typed_organization(org)
          typed_org.highway_consultants.each do |consultant|
            user.viewable_organizations << consultant unless user.viewable_organizations.include? consultant
          end
        end
      end
    else
      user.viewable_organizations = user.organizations
      user.viewable_organizations << HighwayAuthority.first unless user.viewable_organization_ids.include? HighwayAuthority.first.id
    end
    user.save!

    UserMailer.send_email_on_user_creation(user).deliver unless assume_user_exists
  end
end
