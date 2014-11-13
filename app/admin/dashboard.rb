require 'nokogiri'
require 'open-uri'
require 'uri'

ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns {

      column {

        panel 'Панель управления' do

          section {
            strong { link_to 'Сканировать', admin_analysis_path, remote: true, data: { confirm: 'Данные будут потеряны' }}
            strong { link_to 'Остановить', admin_cancel_analysis_path, remote: true }
          }

        end

      }

      column {

        panel 'Логи' do

          section {
            strong { link_to 'Обновить', admin_root_path }
            strong { link_to 'Очистить лог', admin_clear_log_path }
          }

          Log.find_each do |log|
            div class: 'log_'+log.level do
              strong { log.text }
              strong class: :float_right do
                log.created_at.strftime('%F %T')
              end
            end
          end

        end

      }

    }

  end # content

  controller {

    def clear_log
      Log.delete_all
      redirect_to admin_root_url
    end

    def status_info

      if self.class.analysis_thread and self.class.analysis_thread.alive?
        render json: {status_analysis: self.class.analysis_thread['message']}
      else
        head :ok
      end

    end

    def status=(message)
      if self.class.analysis_thread and self.class.analysis_thread.alive?
        self.class.analysis_thread['message'] = message
      end
    end

    def cancel_analysis
      if self.class.analysis_thread and self.class.analysis_thread.alive?
        self.class.analysis_thread.kill
        ActiveRecord::Base.connection.close
        Log.create!(level: :warning, text: 'Анализ остановлен')
      end
      head :ok
    end

    def start_analysis

      if self.class.analysis_thread.nil? or !self.class.analysis_thread.alive?
        self.class.analysis_thread = Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do

            # На всякий случай, ато что то среда падает :DDD
            begin

              #   Очищаем старые данные
              Log.create!(level: :info, text: 'Старт парсинга')
              Log.create!(level: :info, text: 'Удаление старых данных')
              GraphPosition.delete_all
              PropertyPosition.delete_all

              #   Парсим страны. без разницы с какой страницы
              Log.create!(level: :info, text: 'Парсим страны')
              self.status = 'Парсим страны'
              doc = Nokogiri::HTML(open('http://www.indexmundi.com/factbook/compare/zambia.zimbabwe'))

              #   Находим нужный инпут
              doc.css('#c1 > option').each do |option|

                value = option.attribute('value').content

                unless value.blank?

                  country_name = option.content

                  country = Country.find_by_name country_name

                  unless country

                    Country.create!(name: country_name, value_from_compare: value)

                  end


                end

              end

              sleep(rand(3))
            #   Парсим пропертя
              Log.create!(level: :info, text: 'Парсим пропертя')
              count_country = Country.count
              i = 0
              Country.find_each do |country|

                begin
                  i += 1
                  self.status = "Парсим пропертя для #{country.name} #{i} из #{count_country}"

                  doc = Nokogiri::HTML(open("http://www.indexmundi.com/factbook/compare/#{country.value_from_compare}.zimbabwe"))

                  doc.css('section').each do |section|

                    category_name = section.css('h2').first.content

                    category = Category.find_by_name category_name

                    unless category

                      # Создаём категории если ещё не созданы
                      category = Category.create! name: category_name

                    end

                    # Находим одну запись
                    section.css('table > tbody > tr').each do |one_record|

                      property_name = one_record.css('td:nth-child(1)').first.content

                      property = PropertyName.find_by_name property_name

                      unless property

                        #   Создаёт проперту_наме если не существует
                        property = PropertyName.create! name: property_name, category: category

                        # category.property_names << property

                      end

                      property_value = one_record.css('td:nth-child(2)').first.to_s.gsub('<td>', '').gsub('</td>', '')

                      PropertyPosition.create! text: property_value, property_name: property, country: country

                    end

                  end

                rescue Exception => e
                  Log.create! level: :error, text: 'Что то сломалось при парсинге пропертей. Страна ' + country.name, stack_trace: e.backtrace.inspect
                end

                sleep(rand(3))

              end

              sleep(rand(3))
              #   Парсим алиасы для стран
              Log.create!(level: :info, text: 'Парсинг алиасов стран')
              self.status = 'Парсинг алиасов стран'
              doc = Nokogiri::HTML(open('http://www.indexmundi.com/g/'))

              doc.css('#c > option').each do |option|

                country_name = option.content

                country = Country.find_by_name country_name

                if country
                  country.value_from_table = option.attribute('value').content
                  country.save!
                end

              end

              sleep(rand(3))
            # Парсим алиасы пропертей
              Log.create!(level: :info, text: 'Парсинг алиасов пропертей')
              self.status = 'Парсинг алиасов пропертей'
              doc = Nokogiri::HTML(open('http://www.indexmundi.com/g/g.aspx?c=zi&v=105'))

              doc.css('#v > option').each do |option|

                property_name = option.content.gsub(/.+:\s/, '')

                property = PropertyName.find_by_name property_name

                unless property

                  category_name = option.content.gsub(/:\s.+/, '')
                  category = Category.find_by_name category_name
                  property = PropertyName.create! name: property_name, category: category

                end

                property.value_from_table = option.attribute('value').content
                property.save!

              end

              sleep(rand(3))
            # Считывает графики
              Log.create!(level: :info, text: 'Парсим графики')
              i = 0
              count_country = Country.count
              Country.find_each do |country|

                begin

                  if country.value_from_table

                    PropertyName.only_table.find_each do |property_name|

                      self.status = "Парсим графики страна #{country.name} пропери #{property_name.name} #{i} из #{count_country}"

                      doc = Nokogiri::HTML(open("http://www.indexmundi.com/g/g.aspx?c=#{country.value_from_table}&v=#{property_name.value_from_table}"))

                      table = doc.css('#content table table').first

                      unless table.nil?

                        years = table.css('tr > th').map &:content
                        statistic = table.css('tr > td').map &:content

                        years.shift
                        statistic.shift

                        hash = Hash[*years.zip(statistic).flatten]

                        graph_position_entities = []

                        hash.each_key do |key|

                          year = Year.find_by_name key

                          unless year

                            year = Year.create! name: key

                          end

                          property_position = PropertyPosition.where(country: country, property_name: property_name).first

                          unless property_position

                            property_position = PropertyPosition.create! property_name: property_name, country: country

                          end

                          graph_position = GraphPosition.create! year: year, property_position: property_position, value: hash[key].gsub(',', '').to_i

                        end

                        p years.to_s
                        p statistic.to_s

                      end

                    end

                  end

                rescue Exception => e
                  Log.create! level: :error, text: 'Что то сломалось при парсинге графиков. Страна ' + country.name, stack_trace: e.backtrace.inspect
                end

                sleep(rand(3))

              end

              sleep(rand(3))
            # Парсим рейтинг
              Log.create!(level: :info, text: 'Парсим рейтинг')
              count_property_name = PropertyName.only_table.count
              i = 0
              PropertyName.only_table.find_each do |property_name|

                begin

                  self.status = "Парсим рейтинг имя проперти #{property_name.name} #{i} из #{count_property_name}"

                  doc = Nokogiri::HTML(open("http://www.indexmundi.com/g/r.aspx?t=0&v=#{property_name.value_from_table}"))

                  rows = doc.css('#content table tr')

                  rows.shift

                  rows.each do |row|

                    country_name = row.css('td:nth-child(2) a').first.content
                    rating = row.css('td:nth-child(3)').first.content.gsub(',', '').to_i

                    country = Country.find_by_name country_name

                    unless country

                      country = Country.create! name: country_name

                    end

                    property_position = PropertyPosition.where(country: country, property_name: property_name).first

                    unless property_position

                      property_position = PropertyPosition.create! property_name: property_name, country: country

                    end

                    property_position.rating= rating
                    property_position.save!

                  end

                rescue Exception => e
                  Log.create! level: :error, text: 'Что то сломалось при парсинге рейтинга. Пропертя ' + property_name.name, stack_trace: e.backtrace.inspect
                end

                sleep(rand(3))

              end

              Log.create!(level: :info, text: 'Конец парсинга')

            rescue Exception => e
              Log.create!(level: :error, text: 'Что то сломалось при парсинге ', stack_trace: e.backtrace.inspect)
            end

          end
        end
      end

      respond_to do |format|
        format.html { redirect_to admin_root_url }
        format.js { head :ok }
      end

    end

    class << self

      attr_accessor :analysis_thread

    end

  }

end
