ModMail::Application.routes.draw do

  # Tempt Testing
  match '/p' => 'image_playground#playground'
  match '/d' => 'image_playground#debug'
  match '/external_ip_test' =>  'external_ip#test'

  # Authentication
  match '/authenticate' => redirect('/auth/google_oauth2')
  match '/auth/google_oauth2/callback' => 'gmail#omniauth_success_callback'

  match 'signin' => 'sessions#create'
  match 'signout' => 'sessions#destroy', as: 'signout'

  # Callbacks
  match "/sendgrid/callback" => "sendgrid#callback"
end
