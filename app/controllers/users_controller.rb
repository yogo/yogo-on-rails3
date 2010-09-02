class UsersController < InheritedResources::Base
  respond_to :html, :json

  protected

  def resource
    @user ||= resource_class.get(params[:id])
  end
  
  def collection
    @users ||= resource_class.paginate(:page => params[:page])
  end
  
  def resource_class
    User
  end
  
end
