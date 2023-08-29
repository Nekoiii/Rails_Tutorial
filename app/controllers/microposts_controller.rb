class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[ show update destroy ]

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
  end

  def new
  end
  
  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)

    if @micropost.save
      render :show, status: :created, location: @micropost
    else
      render json: @micropost.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    if @micropost.update(micropost_params)
      render :show, status: :ok, location: @micropost
    else
      render json: @micropost.errors, status: :unprocessable_entity
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:content, :user_id)
    end
end
