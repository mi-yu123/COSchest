class CostumesController < ApplicationController
  before_action :authenticate_user!

  def index
    @costumes = Costume.all
  end

  def new
    @costumes = Costume.new
  end

  def create
    @costume = Costume.new(costume_params)
    if @costume.save
      redirect_to costumes_path, notice: "衣装が登録されました"
    else
      render :new
    end
  end

  def edit
    @costume = Costume.find(params[:id])
    if @costume.update(costume_params)
      redirect_to costumes_path, notice: "衣装が更新されました"
    else
      render :edit
    end
  end

  private

  def costume_params
    params.require(:costume).permit(:image, :character_name, :status, :memo)
  end
end
