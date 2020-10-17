class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @bookings = policy_scope(Booking).search_by_plant_name(params[:query])

      sort_bookings_by_date(@bookings)
    else
      @bookings ||= policy_scope(Booking)

      sort_bookings_by_date(@bookings)
    end
  end

  def show; end

  def new
    @plant = Plant.find(params[:plant_id])
    @booking = Booking.new
    authorize @booking
  end

  def edit; end

  def create
    @plant = Plant.find(params[:plant_id])
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    authorize @booking
    @booking.plant = @plant
    if @booking.save
      redirect_to bookings_path
    else
      render :new
    end
  end

  def update
    @booking.update(booking_params)
    redirect_to booking_path
  end

  def destroy
    @booking.destroy
    redirect_to plants_path
  end

  private

  def booking_params
    params.require(:booking).permit(:beginning_date, :end_date)
  end

  def set_booking
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def sort_bookings_by_date(bookings)
    @past_bookings = bookings.where("beginning_date < ?", Date.today)
    @future_bookings = bookings.where("beginning_date > ?", Date.today)
    @current_bookings = bookings - @past_bookings - @future_bookings
  end
end

