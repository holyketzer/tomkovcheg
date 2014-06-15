class RolesController < ApplicationController
  respond_to :html, only: [:index, :show, :edit, :update]
  inherit_resources
  authorize_resource

  #layout 'two_columns', only: [:index, :show]
end