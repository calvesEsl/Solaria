module BaseCrud
  module Edit
    def edit
      @resource = model_class.find(params[:id])

      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def model_class
      controller_name.classify.constantize
    end
  end
end
