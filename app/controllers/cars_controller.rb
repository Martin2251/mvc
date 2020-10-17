class CarsController < ApplicationController
   skip_before_action :authenticate_user!, only: [:home, :index, :show]
  before_action :set_plant, only: [:show, :edit, :update, :destroy]

  def home; end

  def index
    if params[:query].present?
      @cars = Car.search_car(params[:query])
    else
      @cars = policy_scope(Cars)
    end

    # @plants = Plant.geocoded
    # @markers = @plants.map do |plant|
    #   {
    #     lat: plant.latitude,
    #     lng: plant.longitude
    #   }
    # end
  end

  def show
    @booking = Booking.new
    @review = Review.new
  end

  def new
    @car = Cars.new
    authorize @car
  end

  def edit; end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    authorize @car
    if @car.save
      redirect_to car_path(@car)
    else
      render :new
    end
  end

  def update
    @car.update(car_params)
    if @car.save
      redirect_to car_path(@car)
    else
      render :edit
    end
  end

  def destroy
    @car.destroy
    redirect_to cars_path
  end

  private

  def car_params
    params.require(:car).permit(:name, :species, :category, :price, :address, :description, photos: [])
  end

  def set_car
    @car = Car.find(params[:id])
    authorize @car
  end
end
