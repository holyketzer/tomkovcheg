class ImagesController < InheritedResources::Base
  respond_to :html, only: :destroy

  def destroy
    destroy! do |format|
      format.html { redirect_to :back }
    end
  end
end