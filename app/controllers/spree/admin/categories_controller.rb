module Spree
  module Admin
    class CategoriesController < Spree::Admin::BaseController
      
      def create
        @category = Spree::Category.new(category_params)
        if @category.save
          flash[:success] = flash_message_for(@category, :successfully_created)
          redirect_to admin_categories_path
        else
          render :new
        end
      end

      def index
        @categories = Spree::Category.all.page(params[:page])
      end

      def show
        redirect_to edit_admin_category_path(@category)
      end

      def new
        @category = Spree::Category.new
      end

      def edit
        @category = Spree::Category.find(params[:id])
      end

      def update
        @category = Spree::Category.find(params[:id])
        if @category.update(category_params)
          flash[:success] = "Category Updated"
          redirect_to admin_categories_path
        else
          render :edit
        end
      end

      def destroy
        @category = Spree::Category.find(params[:id])
        @category.delete

        flash[:success] = "Category has be deleted"

        respond_with(@category) do |format|
          format.html { redirect_to admin_categories_path }
          format.js { render_js_for_destroy }
        end
      end
      
      private
      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
