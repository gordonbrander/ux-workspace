###
Given a string (possibly) containing HTML, return a new string with all tags
removed.
###
stripHtml = (string) -> string.replace(/<[^>]+>/g, '')

plugin = (env, end) ->
  env.helpers.stripHtml = stripHtml
  end()

module.exports = plugin