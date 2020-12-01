class EventsController < ApplicationController

before_action :set_event, only: [:edit, :update, :show, :destroy]

  def index
    if params[:search][:location].present?
      @events = policy_scope(Event).location_search(params[:search][:location])
    elsif params[:search][:sport].present?
      @events = policy_scope(Event).sport_search(params[:search][:sport])
    elsif params[:search][:date].present?
      @events = policy_scope(Event).date_search(params[:search][:date])
    elsif params[:search][:level].present?
      @events = policy_scope(Event).level_search(params[:search][:level])
     
    else
      @events = policy_scope(Event)
    end
  
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
  end

  def show
    @marker = {
        lat: @event.latitude,
        lng: @event.longitude
      }

    @booking = Booking.new
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path
    else
      render :new
    end
    authorize @event
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :date, :price, :capacity, :level, :sport)
  end

  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end
end
