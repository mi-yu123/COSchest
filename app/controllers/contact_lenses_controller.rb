class ContactLensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_lens, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @q = current_user.contact_lenses.ransack(params[:q])
    @contact_lenses = @q.result(distinct: true)
  end

  def search
    @q = current_user.contact_lenses.ransack(search_params)
    
    # 使用期限の完全一致検索
    if params.dig(:q, :expiration_date_gteq).present?
      date_str = params[:q][:expiration_date_gteq]
      @contact_lenses = current_user.contact_lenses
        .with_expiration_date(date_str)
        .ransack(name_cont: params.dig(:q, :name_cont))
        .result(distinct: true)
    else
      # 使用期限の条件がない時は通常の検索
      @contact_lenses = @q.result(distinct: true)
    end

    render :index
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

  def search_params
    params.fetch(:q, {}).permit(:name_cont, :expiration_date_gteq) if params[:q].present?
  end
end
