class CatRentalRequestsController < ApplicationController
  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat)
    else
      # tried using flash.now with render :new but it was not refreshing the page and the errors
      # were not showing up. Had to resort to using flash with redirect_to
      flash[:errors] = @cat_rental_request.errors.full_messages
      redirect_to new_cat_rental_request_url
    end
  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end

  def current_cat_rental_request
    @cat_rental_request ||= CatRentalRequest.includes(:cat).find_by(id: params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end
end