ActiveAdmin.register Category do

  menu parent: 'Directory'

  permit_params :name, :rus_name, :translate

  config.sort_order = 'name_asc'

  filter :name
  filter :rus_name

  batch_action :destroy, false

  scope :translate
  scope :untranslate

  index do

    column :translate
    column :name, sortable: true
    column :rus_name, sortable: true
    column :translater do |category|
      text_field_tag category.id, '', class: :translater
    end
    actions

  end

  show do |category|
    attributes_table do
      row :id
      row :translate
      row :name
      row :rus_name
      row :created_at
      row :updated_at
    end
  end

  # Контроллер перевода
  member_action :translate, method: :put do
    head :fault and return if params[:translate].blank?
    category = Category.find(params[:id])
    category.rus_name = params[:translate]
    category.translate = true
    category.save

    render json: category
  end


end
