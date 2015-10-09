require 'rails_helper'

describe "GET /ping", type: :request do
  it "should ping pong" do
    get "/ping", format: :json
    response_body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(response_body["data"][0]["type"]).to eq("responses")
    expect(response_body["data"][0]["attributes"]["pong"]).to eq(true)
  end
end
