require 'rails_helper'

describe 'POST /users', type: :request do
  let!(:user) { FactoryGirl.create(:user, email: 'email@test.com') }
  let!(:params) {{ email: 'newuser@test.com'}}

  it 'should create an user' do
    post '/users', params
    response_body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(response_body["data"]["attributes"]["email"]).to eq(params[:email])
  end

  it "should not create an user with invalid parameters" do
    post '/users'
    expect(response.status).to eq(400)

    post '/users', email: nil
    expect(response.status).to eq(400)  
  end
end

describe "DELETE /users", type: :request do
  let!(:user) { FactoryGirl.create(:user, email: 'delete@me.com')}

  it "should delete a user" do
    user_count = User.count
    delete "/users/#{user.id}", format: :json
    expect(User.count).to eq(user_count - 1)
  end
end