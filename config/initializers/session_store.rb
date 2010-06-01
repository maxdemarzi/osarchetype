# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_beta.archety.pe_session',
  :secret      => '13db32a925eb7741bfac8cb8605b40ae8461806749098c660cd1863c5a060b80ce29b24a7f207579c9fcbf9768858fb795525109511dcd5a3d3440b3ee99b094'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
