ActiveAdmin.register Surfcamp do
  permit_params :name, :description, :rating, :address, :rooms, :latitude, :longitude
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form(:html => { :multipart => true }) do |f|
    f.inputs "Surfcamp" do
      f.input :name
      f.input :description
      f.input :image, :as => :file
      f.input :rating
      f.input :address
    end
    f.actions
  end
end
