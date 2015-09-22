class MainController < ApplicationController
  def ping
    render json: {
      data: [{
        type: "responses",
        attributes: {
          pong: true
        }
      }]
    }
  end
end