module BaseCrud
  module Destroy
    def destroy
      resource = resource_class.find(params[:id])
      resource.destroy
      head :no_content
    end
  end
end
