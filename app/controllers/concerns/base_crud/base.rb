module BaseCrud
  module Base
    extend ActiveSupport::Concern

    include BaseCrud::Show
    include BaseCrud::Create
    include BaseCrud::Update
    include BaseCrud::Destroy
    include BaseCrud::New
    include BaseCrud::Edit
  end
end