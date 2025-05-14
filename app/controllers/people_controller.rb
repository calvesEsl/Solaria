class PeopleController < ApplicationController
  def index
    @people = Person.all.page(params[:page])
  end
end
