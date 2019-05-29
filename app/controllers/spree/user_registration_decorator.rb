module Demo
  module UserRegistrationsControllerDecorator
    def create
      @user = build_resource(spree_user_params)
      resource_saved = resource.save
      yield resource if block_given?
      if resource_saved
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up
          sign_up(resource_name, resource)
          session[:spree_user_signup] = true
          subscriber
          session[:new_user_id] = resource.id
          client = Signet::OAuth2::Client.new(client_options(resource))
          redirect_to client.authorization_uri.to_s
          
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords(resource)
        render :new
      end
    end

    def subscriber
      require 'createsend'
      # if params[:user][:email].present? && params[:user][:name].present? && params[:user][:category_id].present?
      #   cs = CreateSend::CreateSend.new :api_key => '4qCaU7xNe4ebxI9eUl4Ov1He6lVHKYL9fJzA/We1qXbrUR0dTF8b9AJYg8TgcDHfHWQVs2xXmQoHtwv9RB/zeXtGckzfi4KFxx+vB/754+RRPs9vKvupGbux6Ru40MA93/bIvVSmeZxzIxUwPK67CQ=='
      #   options = { :body => {
      #     :EmailAddress => "#{params[:user][:email]}",
      #     :Name => "#{params[:user][:name]}",
      #     :CustomFields =>  [ 
      #                         { :Key => 'Category', :Value => "#{Spree::Category.find(params[:user][:category_id]).name}"}
      #                       ],
      #     :ConsentToTrack => 'Yes'
      #     }.to_json
      #   }
        # clients = cs.post "/subscribers/ac3e570d1cac8fa67d0d29cf1a49b503.json", options
      # end
    end


    def callback
      user = Spree::User.find(session[:new_user_id])
      client = Signet::OAuth2::Client.new(client_options(user))
      client.code = params[:code]
      response = client.fetch_access_token!
  
      session[:authorization] = response
  
      service = Google::Apis::CalendarV3::CalendarService.new
      
      service.authorization = client
      
      calendar = Google::Apis::CalendarV3::Calendar.new({
        summary: 'Campaign'
      })

      response = service.insert_calendar(calendar)
      @calendar = JSON.parse(response.to_json) 
      calendar_id = @calendar["id"]

      event = Google::Apis::CalendarV3::Event.new({
        start: Google::Apis::CalendarV3::EventDateTime.new(date_time: "#{user.follow_datetime.to_datetime.rfc3339}"),
        end: Google::Apis::CalendarV3::EventDateTime.new(date_time: "#{user.follow_datetime.to_datetime.rfc3339}"),
        summary: 'New campaign event!',
        description: "Company Name: Logical Street
                      Contact Name: #{user.name}
                      Phone No: #{user.phone}"
      })

      event.reminders = Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 1),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 30)
        ]
      )

      service.insert_event(calendar_id, event)
      redirect_to after_sign_up_path_for(user)
    end

    private

    def client_options(user)
      {
        client_id: user.salesman.google_client_id,
        client_secret: user.salesman.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: "http://localhost:3000/callback"
      }
    end

  end
end
Spree::UserRegistrationsController.prepend Demo::UserRegistrationsControllerDecorator