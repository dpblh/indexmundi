ActiveAdmin.register PropertyPosition do

  filter :property_name
  filter :text
  filter :rating

  index do
    column :name do |property_position|
      property_position.property_name.name.html_safe
    end
    column :text, sortable: :text do |property_position|
      property_position.text.html_safe if property_position.text
    end
    column :rating, sortable: :rating
    column :country
  end

  controller do
    def scoped_collection
      resource_class.includes(:property_name, :country, :graph_positions)
    end
  end

  # Контроллер перевода
  member_action :translate, method: :put do
    head :fault and return if params[:translate].blank?
    property_position = PropertyPosition.find(params[:id])
    property_position.rus_text = params[:translate]
    property_position.translate = true
    property_position.save

    render json: property_position
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
