class QuotesController < ApplicationController

  def index
    render json: Quote.all, each_serializer: QuoteSerializer
  end

  def create
    quote = Quote.create(quote_params)
    if quote.save
      render json: quote
    else
      render json: '400', status: 400
    end
  end

  def update
    quote = Quote.find(params[:id])
    if quote.update_attributes(quote_params)
      render json: quote
    else
      render json: '400', status: 400
    end
  end

  def show
    render json: Quote.where(id: params[:id]).first.to_json
  end

  def destroy
    Quote.where(id: params[:id]).first.destroy

    head 204
  end

  private
    def quote_params
      params.permit(:author, :body)
    end
end
