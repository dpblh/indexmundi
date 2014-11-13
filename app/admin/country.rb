ActiveAdmin.register Country do

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
    column :translater do |country|
      text_field_tag country.id, '', class: :translater
    end
    actions

  end

  show do |country|
    attributes_table do
      row :id
      row :translate
      row :name
      row :rus_name
      row :created_at
      row :updated_at
    end

    Country.hash_category_places(country).each do |key, value|
      panel key do
        table_for value, class: :property_position do
          column :property_name, class: :property_name_table do |property_position|
            property_position.property_name.rus_name or property_position.property_name.name
          end
          column :property_position, class: :property_position do |property_position|

            table class: :property_group do

              tr class: :border_bottom do
                td class: :property_data do
                  'Текст'
                end
                td {
                  if property_position.rus_name
                    property_position.rus_name.html_safe
                  elsif property_position.text
                    property_position.text.html_safe
                  end
                }
              end
              tr class: :border_bottom do
                td class: :property_data do
                  'Рейтинг'
                end
                td {
                  property_position.rating if property_position.rating
                }
              end
              tr class: :border_bottom do
                td class: :property_data do
                  'График'
                end
                td {
                  table class: :property_graph_data do

                    tr {
                      td {
                        'Страны'
                      }
                      property_position.graph_positions.each do |graph_position|
                        td {
                          graph_position.year.name
                        }
                      end
                    }
                    tr {
                      td {
                        'Статистика'
                      }
                      property_position.graph_positions.each do |graph_position|
                        td {
                          graph_position.value
                        }
                      end
                    }
                  end
                }
              end

            end
          end
        end
      end

    end

  end

  form do |f|

    f.inputs do

      f.input :translate
      f.input :name
      f.input :rus_name

    end

  end



  # Контроллер перевода
  member_action :translate, method: :put do
    head :fault and return if params[:translate].blank?
    country = Country.find(params[:id])
    country.rus_name = params[:translate]
    country.translate = true
    country.save

    render json: country
  end


end
