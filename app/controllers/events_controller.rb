class EventsController < ApplicationController
	before_action :authenticate_user!, only: [ :new, :edit, :create, :update, :destroy ]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
		@events = Event.order(created_at: :desc)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
		@event.address.build!
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
				@event.update(:adress_params)
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
    def set_event
      @event = Event.find(params[:id])
			@event.address.build if @event.address.empty?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
			params.require(:event).permit(:title, :description, :date, {images: []}, address_attributes: [:id, :street, :number, :district, :zip_code, :city, :estate, :country])
    end
end