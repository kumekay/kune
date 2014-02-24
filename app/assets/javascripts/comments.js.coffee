jQuery ->
  # Delete a comment
  $(document)
    .on "ajax:success", (evt, data, status, xhr) ->
       $("#comment-#{data.id}").hide('fast')
      