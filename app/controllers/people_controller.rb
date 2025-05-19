class PeopleController < ApplicationController
  include BaseCrud::Base

  def index
    @people = Person.all.page(params[:page])
  end
end
