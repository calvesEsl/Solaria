module BaseCrud
  module Update
    extend ActiveSupport::Concern

    def update
      debugger
      @resource = model_class.find(params[:id])

      if @resource.update(resource_params)
        flash.now[:success] = t('crud.update.success', model: @resource.class.model_name.human)
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @resource, status: :ok }
        end
      else
        flash.now[:error] = t('crud.update.error', model: @resource.class.model_name.human)
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def model_class
      controller_name.classify.constantize
    end
  end
end
