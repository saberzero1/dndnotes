class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_related, only: [:show, :edit]
  load_and_authorize_resource

  # GET /locations
  # GET /locations.json
  def index
    @q = current_user.locations.ransack(params[:q])
    @locations = @q.result(distinct: true)
    render 'shared/notes/index', locals: { type_class: Location, objects: @locations, new_path: new_location_path }
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @link = current_user.links.build
    render 'shared/notes/show', layout: 'page', locals: { object: @location, edit_path: edit_location_path(@location) }
  end

  # GET /locations/new
  def new
    @location = current_user.locations.build
    render 'shared/notes/new', locals: { object: @location, url: locations_path(referrer_id: params[:referrer_id], referrer_type: params[:referrer_type]) }
  end

  # GET /locations/1/edit
  def edit
    render 'shared/notes/edit', locals: { object: @location }
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = current_user.locations.build(location_params)

    respond_to do |format|
      if @location.save
        if params[:referrer_id] && params[:referrer_type] 
          @location.incoming_links.build(origin_id: params[:referrer_id], origin_type: params[:referrer_type], user_id: current_user.id).save
        end
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    def set_related
      @campaigns = @location.related('campaigns')
      @locations = @location.related('locations')
      @quests = @location.related('quests')
      @notes = @location.related('notes')
      @groups = @location.related('groups')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :description, :content, :referrer_id, :referrer_type)
    end
end
