strava_access_token = ENV["STRAVA_ACCESS_TOKEN"]
StravaClient = Strava::Api::Client.new(access_token: strava_access_token)

class RoutesController < ApplicationController
  before_action :set_route, only: %i[ show edit update destroy ]

  def create_route(route)
    gpx = Base64.encode64(StravaClient.export_route_gpx(route['id']))
    return Route.create(name: route['name'], route_updated_at: route['updated_at'], route_id: route['id'], gpx: gpx)
  end

  def custom
    @routes = JSON.parse(File.read(Rails.root.join('archive', 'strava-routes.json')))
    @routes.each do |route|
      if not Route.exists?(name: route['name'])
        # Route.create(name: route['name'], route_updated_at: route['updated_at'], route_id: route['id'], gpx: data)
        create_route(route)
      end

      saved_route = Route.find_by(name: route['name'])
      current_route_updated_at = Time.parse(route['updated_at']).iso8601

      if current_route_updated_at != saved_route.route_updated_at.iso8601
        saved_route.destroy
        saved_route = create_route(route)
        saved_route.update(process: true)
      end

      if saved_route.process # we do stuff in Garmin Connect or wherever

        # ... then we remove the process flag
        saved_route.update(process: false)
      end
    end
  end

  # GET /routes or /routes.json
  def index
    @routes = Route.all
  end

  # GET /routes/1 or /routes/1.json
  def show
  end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit
  end

  # POST /routes or /routes.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: "Route was successfully created." }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routes/1 or /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html { redirect_to @route, notice: "Route was successfully updated." }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1 or /routes/1.json
  def destroy
    @route.destroy!

    respond_to do |format|
      format.html { redirect_to routes_path, status: :see_other, notice: "Route was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def route_params
      params.require(:route).permit(:name, :route_updated_at, :json)
    end
end
