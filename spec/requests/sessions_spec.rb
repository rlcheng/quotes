require 'rails_helper'

describe 'sessions created', type: :request do
  before :each do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  it 'creates a session and add user' do
    session_count = Session.count
    user_count = User.count
    get '/auth/github/callback'
    expect(Session.count).to eq(session_count + 1)
    expect(User.count).to eq(user_count + 1)

    response_body = JSON.parse(response.body)
    expect(response_body['data']['attributes']['oauth_token']).to_not be_nil
    expect(response_body['data']['attributes']['user_id']).to eq(1)
  end

end

describe 'sessions create failed', type: :request do
  before :each do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
  end

  it 'does not add a session or add user' do
    session_count = Session.count
    user_count = User.count    
    get '/auth/github/callback'
    expect(Session.count).to eq(session_count)
    expect(User.count).to eq(user_count)
    expect(response.status).to eq(302)
  end

  it 'renders status 400' do
    get '/auth/failure'
    expect(response.status).to eq(400)
  end
end

describe 'session destroy', type: :request do
  session = Session.create(user_id: 1, oauth_token: "mock_token")

  it 'deletes a session' do
    session_count = Session.count
    delete "/sessions/#{session.id}"
    expect(Session.count).to eq(session_count - 1)
    expect(response.status).to eq(204)
  end
end
