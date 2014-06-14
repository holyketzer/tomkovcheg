class ImagesController < ApplicationController
  respond_to :html, only: :destroy
  inherit_resources
  authorize_resource

  def destroy
    destroy! do |format|
      format.html { redirect_to :back }
    end
  end
end