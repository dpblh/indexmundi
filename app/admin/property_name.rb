ActiveAdmin.register PropertyName do

  menu parent: 'Directory'

  permit_params :name, :rus_name, :category_id, :translate

  config.sort_order = 'name_asc'

  filter :name
  filter :rus_name
  filter :category

  batch_action :destroy, false

  scope :translate
  scope :untranslate

  index do

    column :translate
    column :name, sortable: true
    column :rus_name, sortable: true
    column :translater do |property_name|
      text_field_tag property_name.id, '', class: :translater
    end
    actions

  end

  show do |property_name|
    attributes_table do
      row :id
      row :translate
      row :category
      row :name
      row :rus_name
      row :created_at
      row :updated_at
    end
  end

  form do |f|

    f.inputs do

      f.input :category
      f.input :name
      f.input :rus_name
      f.input :translate

    end

    f.actions

  end

  # Контроллер перевода
  member_action :translate, method: :put do
    head :fault and return if params[:translate].blank?
    property_name = PropertyName.find(params[:id])
    property_name.rus_name = params[:translate]
    property_name.translate = true
    property_name.save

    render json: property_name
  end


end
