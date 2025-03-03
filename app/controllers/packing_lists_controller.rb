class PackingListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_items, only: %i[new create edit update]
  before_action :set_packing_list, only: %i[edit update destroy]

  def index
    @packing_lists = current_user.packing_lists.includes(:itemable)
  end

  def new
    @packing_list = current_user.packing_lists.new
  end

  def create
    @packing_list = current_user.packing_lists.build(packing_list_params)
  
    if @packing_list.save
      redirect_to packing_lists_path, flash: { message: '登録しました' }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @packing_list.update(packing_list_params)
      redirect_to packing_lists_path, flash: { message: '更新しました' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @packing_list.destroy
    redirect_to packing_lists_path, flash: { message: '削除しました' }
  end

  private

  def set_user_items
    @costumes = current_user.costumes
    @wigs = current_user.wigs
    @contact_lenses = current_user.contact_lenses
  end

  def set_packing_list
    @packing_list = current_user.packing_lists.find(params[:id])
  end

  def packing_list_params
    params.require(:packing_list).permit(:item, :packed, :itemable_type, :itemable_id)
  end
end
