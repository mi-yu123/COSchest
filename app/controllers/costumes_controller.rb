class CostumesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_costume, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @costumes = current_user.costumes
  end

  def new
    @costume = Costume.new
  end

  def create
    @costume = Costume.new(costume_params)
    @costume.user = current_user
    if @costume.save
      redirect_to costumes_path, notice: "衣装が登録されました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @costume.update(costume_params)
      redirect_to costumes_path, notice: "衣装が更新されました"
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @costume.destroy
    redirect_to costumes_path, notice: "衣装が削除されました"
  end

  private

  def set_costume
    @costume = Costume.find(params[:id])
  end

  def costume_params
    params.require(:costume).permit(:image, :character_name, :status, :memo)
  end

  def ensure_correct_user
    @costume =Costume.find(params[:id])
    unless @costume.user == current_user
      redirect_to costumes_path, alert: "権限がありません"
    end
  end
end
