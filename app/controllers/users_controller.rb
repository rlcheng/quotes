class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: '400', status: 400
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    head 204
  end

  private
    def user_params
      params.permit(:email)
    end

end
