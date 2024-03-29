ModMail::Application.routes.draw do

  root to: "static#index"
  match '/welcome' => 'static#welcome'
  match '/confirmation' => 'static#confirmation'

  # Email
  get '/email/:email_id/is_read_image' => 'email#is_read_image'
  match '/email/:email_id/rewrite' => 'email#rewrite'
  get '/p/:image_tag_uri' => 'redirect_mapping#get'
  get '/dbit/:key' => 'dirty_bit#get'

  # Debugging
  match '/p' => 'image_playground#playground'
  match '/d' => 'image_playground#debug'
  match '/external_ip_test' =>  'external_ip#test'
  match '/w' => 'testing#work'
  match '/s' => 'testing#send_email'

  # Authentication
  match '/authenticate' => redirect('/auth/google_oauth2')
  match '/auth/google_oauth2/callback' => 'gmail#omniauth_success_callback'

  match 'signin' => 'sessions#create'
  match 'signout' => 'sessions#destroy', as: 'signout'

  # Callbacks
  match "/sendgrid/callback" => "sendgrid#callback"

  # TODO -- Route for the landing page
end
