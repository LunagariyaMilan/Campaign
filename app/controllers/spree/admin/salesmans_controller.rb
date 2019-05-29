module Spree
  module Admin
    class SalesmansController < Spree::Admin::BaseController
      def create
        @salesman = Spree::Salesman.new(salesman_params)
        if @salesman.save
          flash[:success] = flash_message_for(@salesman, :successfully_created)
          redirect_to admin_salesmans_path
        else
          render :new
        end
      end

      def index
        @salesmans = Spree::Salesman.all.page(params[:page])
      end

      def show
        redirect_to edit_admin_salesman_path(@category)
      end

      def new
        @salesman = Spree::Salesman.new
      end

      def edit
        @salesman = Spree::Salesman.find(params[:id])
      end

      def update
        @salesman = Spree::Salesman.find(params[:id])
        if @salesman.update(salesman_params)
          flash[:success] = "Salesman Updated"
          redirect_to admin_salesmans_path
        else
          render :edit
        end
      end

      def destroy
        @salesman = Spree::Salesman.find(params[:id])
        @salesman.delete

        flash[:success] = "Salesman has be deleted"

        respond_with(@salesman) do |format|
          format.html { redirect_to admin_salesmans_path }
          format.js { render_js_for_destroy }
        end
      end
      
      private
      def salesman_params
        params.require(:salesman).permit(:name, :google_client_id, :google_client_secret, :google_calander_id)
      end

    end
  end
end