module BaseCrud
  module Show
    def show
      resource = resource_class.find(params[:id])
      render json: resource
    end
  end
end
