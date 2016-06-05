class EventsController < ApplicationController
  require 'net/http'
	before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  respond_to :json
  # GET /events
  # GET /events.json
  def index
    @events = Event.search(params[:search])
    @categories = Category.order(name: :asc)

    respond_to do |format|
      format.html # user_show.html.erb
      format.json {render json: @events.as_json}
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
		authorize_action_for @event
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
		@event.user = current_user
    @event.lat, @event.lon = lat_lon(@event.address)
		
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
		authorize_action_for @event
    
    respond_to do |format|
      if @event.update(event_params)  
        @event.lat, @event.lon = lat_lon(@event.address)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
		authorize_action_for @event
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Generates coordinates based on
    def lat_lon(address)
      # Escape any non_ASCII characters and convert the string into a URI object.
      encoded_url = URI.escape(
        'https://maps.googleapis.com/maps/api/geocode/json?address=' + address
      )
      url = URI.parse((encoded_url))

      # Make the request to retrieve the JSON string
      response = open(url).read

      # Convert the JSON string into a Hash object
      result = JSON.parse(response)

      # Extract the latitude and longitude and return them
      lat = result['results'][0]['geometry']['location']['lat']
      lon = result['results'][0]['geometry']['location']['lng']
      return lat, lon
    end
  
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
			params.require(:event).permit(:title, :category_id, :description, :date, :image, :user_id, :street, :number, :city, :zip_code, :country, :local, :lat, :lon)
    end
    
end
