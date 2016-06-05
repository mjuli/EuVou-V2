module ApplicationHelper
	 def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

  def icon(shape)
    "<span class='glyphicon glyphicon-#{shape}'></span>".html_safe
  end

  def active_menu(target_controller)
    "class=#{controller_name == target_controller ? 'active' : ''}"
  end

	def user_email(event)
		event.user.present? ? event.user.email : "an anonymous user"
  end

  def user_roles(user)
    user.roles.map(&:name).join(', ').titleize
  end

	def link_to_provider(user)
    provider = user.identities.map(&:provider).join(', ')
    provider = case provider
    when 'facebook' then link_to(
			if user == current_user
        user.name
      else
        user.name
			end, edit_user_registration_path)

    when 'twitter' then link_to( if user == current_user
			'Ir para o Twitter'
			else
				user.name
			end, 'http://twitter.com' )
		#when 'foursquare' then link_to( 'Go to Foursquare', 'http://foursquare.com' )
		#when 'google'    then link_to( 'Go to Google', 'http://google.com')
    end

  end

end
