class MyPhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_photo, only: [ :show, :edit, :update, :destroy ]

  def index
    @my_photos = current_user.my_photos.order(posted_at: :desc)
  end

  def show
  end

  def new
    @my_photo = current_user.my_photos.build
  end

  def create
    @my_photo = MyPhoto.new(my_photo_params)
    @my_photo.user = current_user
    if @my_photo.save
      redirect_to my_photos_path, notice: "マイフォトが登録されました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @my_photo.update(my_photo_params)
      redirect_to my_photos_path, notice: "マイフォトが更新されました"
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @my_photo.destroy
    redirect_to my_photos_path, notice: "マイフォトが削除されました"
  end

  private

  def set_my_photo
    @my_photo = current_user.my_photos.find(params[:id])
  end

  def my_photo_params
    params.require(:my_photo).permit(:image, :title, :memo)
  end

  def ensure_correct_user
    @my_photo =MyPhoto.find(params[:id])
    unless @my_photo.user == current_user
      redirect_to my_photos_path, alert: "権限がありません"
    end
  end
end
