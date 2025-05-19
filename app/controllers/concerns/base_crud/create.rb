module BaseCrud
  module Create
    extend ActiveSupport::Concern

    def create
      debugger
      @resource = model_class.new(resource_params)
      if @resource.save
        flash[:success] = t('crud.create.success', model: @resource.class.model_name.human)
        redirect_to edit_polymorphic_path(@resource)
      else
        flash.now[:error] = t('crud.create.error', model: @resource.class.model_name.human)
        render :new, status: :unprocessable_entity
      end
    end

    private

    def resource_params
      params.require(model_class.model_name.param_key).permit!
    end

    def model_class
      controller_name.classify.constantize
    end
  end
end
