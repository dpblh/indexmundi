ActiveAdmin.register PropertyPosition do

  permit_params :text, :rating, :rus_name

  filter :property_name
  filter :text
  filter :rating

  batch_action :destroy, :priority => 1 do |selection|
    PropertyPosition.where(id: selection).delete_all
    redirect_to collection_path, notice: 'Records are deleted'
  end

  scope :translate
  scope :untranslate

  index do

    selectable_column

    column :translate
    column :text, sortable: :text do |property_position|
      property_position.text.html_safe if property_position.text
    end
    column :rus_text, sortable: :rus_name do |property_position|
      property_position.rus_name.html_safe if property_position.rus_name
    end
    column :translater do |property_position|
      text_area_tag property_position.id, '', class: :translater
    end

    actions
  end

  controller do
    def scoped_collection
      resource_class.only_text.includes(:property_name, :country, :graph_positions)
    end
  end

  # Контроллер перевода
  member_action :translate, method: :put do
    head :fault and return if params[:translate].blank?
    property_position = PropertyPosition.find(params[:id])
    property_position.rus_name = params[:translate]
    property_position.translate = true
    property_position.save

    render json: property_position
  end


end
