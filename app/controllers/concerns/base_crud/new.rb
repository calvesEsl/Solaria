module BaseCrud
  module New
    def new
      resource_class = controller_name.classify.constantize
      @resource = resource_class.new

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
