class WigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wig, only: [:edit, :update, :destroy]

  def index
    @wigs = Wig.all
  end

  def new
    @wig = Wig.new
  end

  def create
    @wig = Wig.new(wig_params)
    if @wig.save
      redirect_to wigs_path, notice: "ウィッグが登録されました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @wig.update(wig_params)
      redirect_to wigs_path, notice: "ウィッグが更新されました"
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wig.destroy
    redirect_to wigs_path, notice: "ウィッグが削除されました"
  end

  private

  def set_wig
    @wig = Wig.find(params[:id])
  end

  def wig_params
    params.require(:wig).permit(:image, :character_name, :status, :memo)
  end
end
