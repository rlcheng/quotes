require 'rails_helper'

describe "/quote#index", type: :request do
  before do
    FactoryGirl.create_list(:quote, 2, author: "Famous Dude",
      body: "Words of wisdom.")
  end

  it "should get all quotes" do
    get "/quotes", {format: :json}
    response_body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(response_body['data'].length).to eq(2)
    expect(response_body['data'][0]['attributes']['author']).to eq("Famous Dude")
    expect(response_body['data'][0]['attributes']['body'])
      .to eq("Words of wisdom.")
    expect(response_body['data'][1]['attributes']['author']).to eq("Famous Dude")
    expect(response_body['data'][1]['attributes']['body'])
      .to eq("Words of wisdom.")
  end
end

describe "/quotes#create", type: :request do
  quote = FactoryGirl.build(:quote, author: "Winston Churchill",
    body: "Attitude is a little thing that makes a big difference.")
  it "should create a quote" do
    post "/quotes", format: :json, author: quote.author,
      body: quote.body
    expect(Quote.last.author).to eq(quote.author)
    expect(Quote.last.body).to eq(quote.body)
  end
  it "should fail to create a quote without author" do
    post "/quotes", format: :json, author: "", body: "#{quote.body}"
    expect(response.status).to eq(400)
  end
  it "should fail to create a quote without body" do
    post "/quotes", format: :json, author: quote.author, body: ""
    expect(response.status).to eq(400)
  end
  it "should fail to create" do
    post "/quotes", format: :json, author: "", body: ""
    expect(response.status).to eq(400)
  end
end

describe "/quotes#update", type: :request do
  let(:quote) { FactoryGirl.create(:quote, author: "Mark Twain",
    body: "The secret of getting ahead is getting started.") }
  it "should update a quote" do
    author = "Mark Twain"
    body = "Get your facts first, then you can distort them as you please."
    patch "/quotes/#{quote.id}", format: :json, author: author, body: body
    quote.reload
    expect(quote.body).to eq(body)
  end
  it "should fail to update if missing author" do
    patch "/quotes/#{quote.id}", format: :json, author: "", body: "blah"
    expect(response.status).to eq(400)
  end
  it "should fail to update if missing body" do
    patch "/quotes/#{quote.id}", format: :json, author: "blah", body: ""
    expect(response.status).to eq(400)
  end
  it "should fail to update" do
    patch "/quotes/#{quote.id}", format: :json, author: "", body: ""
    expect(response.status).to eq(400)
  end
end

describe "/quotes#show", type: :request do
  let(:quote) { FactoryGirl.create(:quote, author: "Winston Churchill",
    body: "If you're going through hell, keep going.") }

  it "should get one quote" do
    get "/quotes/#{quote.id}", {format: :json}
    response_body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(response_body['author']).to eq(quote.author)
    expect(response_body['body']).to eq(quote.body)
  end
end

describe "/quotes#destroy", type: :request do
  let!(:quote) { FactoryGirl.create(:quote, author: "Winston Churchill",
    body: "If you're going through hell, keep going.") }  

  it "should destroy quote" do
    count = Quote.count
    delete "/quotes/#{quote.id}", format: :json
    expect(Quote.count).to eq(count - 1)
  end
end
