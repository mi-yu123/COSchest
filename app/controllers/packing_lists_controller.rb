class PackingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @packing_lists = current_user.packing_lists.includes(:itemable)
  end

  def new
    @packing_list = current_user.packing_lists.new
    @costumes = current_user.costumes
    @wigs = current_user.wigs
    @contact_lenses = current_user.contact_lenses
  end

  def create
    @packing_list = current_user.packing_lists.build(packing_list_params)
  
    if @packing_list.save
      redirect_to packing_lists_path, flash: { success: '登録しました' }
    else
      @costumes = current_user.costumes
      @wigs = current_user.wigs
      @contact_lenses = current_user.contact_lenses
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @packing_list = current_user.packing_lists.find(params[:id])
    @costumes = current_user.costumes
    @wigs = current_user.wigs
    @contact_lenses = current_user.contact_lenses
  end

  def update
    @packing_list = current_user.packing_lists.find(params[:id])

    if @packing_list.update(packing_list_params)
      redirect_to packing_lists_path, flash: { success: '更新しました' }
    else
      @costumes = current_user.costumes
      @wigs = current_user.wigs
      @contact_lenses = current_user.contact_lenses
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @packing_list = current_user.packing_lists.find(params[:id])
    @packing_list.destroy
    redirect_to packing_lists_path, flash: { success: '削除しました' }
  end

  private

  def packing_list_params
    params.require(:packing_list).permit(:item, :itemable_type, :itemable_id)
  end
end
