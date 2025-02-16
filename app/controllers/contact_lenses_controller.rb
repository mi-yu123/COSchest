class ContactLensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_lens, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @contact_lenses = current_user.contact_lenses
  end

  def new
    @contact_lens = ContactLens.new
  end

  def create
    @contact_lens = ContactLens.new(contact_lens_params)
    @contact_lens.user = current_user
    if @contact_lens.save
      redirect_to contact_lenses_path, notice: "カラコンが登録されました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contact_lens.update(contact_lens_params)
      redirect_to contact_lenses_path, notice: "カラコンが更新されました"
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_lens.destroy
    redirect_to contact_lenses_path, notice: "カラコンが削除されました"
  end

  private

  def set_contact_lens
    @contact_lens = ContactLens.find(params[:id])
  end

  def contact_lens_params
    params.require(:contact_lens).permit(:name, :image, :expiration_date, :quantity, :memo)
  end

  def ensure_correct_user
    @contact_lens = ContactLens.find(params[:id])
    unless @contact_lens.user == current_user
      redirect_to contact_lenses_path, alert: "権限がありません"
    end
  end
end
