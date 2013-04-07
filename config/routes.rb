ModMail::Application.routes.draw do

  # Email
  get '/email/:email_id/is_read_image' => 'email#is_read_image'
  post '/email/:email_id/update' => 'email#update'
  get '/p/:image_tag_uri' => 'image_tag#get'

  # Debugging
  match '/p' => 'image_playground#playground'
  match '/d' => 'image_playground#debug'
  match '/external_ip_test' =>  'external_ip#test'

  # Email
  match '/email/'

  # Authentication
  match '/authenticate' => redirect('/auth/google_oauth2')
  match '/auth/google_oauth2/callback' => 'gmail#omniauth_success_callback'

  match 'signin' => 'sessions#create'
  match 'signout' => 'sessions#destroy', as: 'signout'

  # Callbacks
  match "/sendgrid/callback" => "sendgrid#callback"
end
