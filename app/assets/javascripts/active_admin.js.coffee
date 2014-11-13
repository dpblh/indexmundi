#= require active_admin/base
$(->
  message = $('<div class="alert"></div>')
  $('body').append(message)
  message.hide()

  setInterval( ->
    $.ajax(
      url: '/admin/status_info'
      type: "GET"
      success: (status) ->
        if status.status_analysis
          message.show()
          message.text(status.status_analysis)
        else
          message.text('')
          message.hide()
      error: ->
    )
  ,5000);

  if $('.admin_countries').length
    resource = 'countries'
  else if $('.admin_categories').length
    resource = 'categories'
  else if $('.admin_property_names').length
    resource = 'property_names'
  else if $('.admin_property_positions').length
    resource = 'property_positions'


  $('input[class=translater],textarea[class=translater]').keypress( (e)->
    if e.which == 13
      $.ajax(
        method : 'PUT'
        url : "/admin/#{resource}/#{e.target.name}/translate"
        data :
          translate : e.target.value
        success : (place)->
          $(e.target).parent().prev().html(place.rus_name)
          $(e.target).parents('tr').find('.col-translate .status_tag').removeClass('no').addClass('yes').text('YES')
          $(e.target).parents('tr').next().find('.translater').focus()
        error : ->
          console.log 'fault'
      )
      e.preventDefault
      return false
  )
)
