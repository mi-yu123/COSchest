class ContactLensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_lens, only: [:edit, :update, :destroy]

  def index
    @contact_lenses = ContactLens.all
  end

  def new
    @contact_lens = ContactLens.new
  end

  def create
    @contact_lens = ContactLens.new(contact_lens_params)
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
end
