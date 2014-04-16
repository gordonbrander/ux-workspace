_ = require('underscore')


comparePagesByFilename = (a, b) ->
  ###
  Compares filenames of each page object. Returns a sorting number.
  ###
  a = a.getFilename()
  b = b.getFilename()
  if a < b then 1 else if a > b then -1 else 0


comparePagesByDate = (a, b) ->
  ###
  Compares UNIX timestamps of each file object. Returns a sorting number.
  Reverse Chron.
  ###
  a = a.date.getTime()
  b = b.date.getTime()
  if a > b then -1 else if a < b then 1 else 0


id = (thing) -> thing


###
Create predicate function from RegExp and a mapping function.
Tip: use this to filter files by, say, URL or filename.

  isMarkdown = searcher(/.md/, (file) -> file.filepath.relative)
###
searcher = (pattern, a2b) ->
  a2b = a2b or id
  (thing) -> a2b(thing).search(pattern) isnt -1


###
Combine multiple predicates into a single predicate using an AND relationship.
Returns a predicate function.
###
all = (predicates...) -> (thing) ->
  rAll = (isPass, predicate) -> if isPass then predicate(thing) else false
  predicates.reduce(rAll, true)


isntIndex = (page) -> page.filepath.relative.search('index.') is -1


toFilepathRelative = (page) -> page.filepath.relative


withPathMatching = (string) ->
  all(isntIndex, searcher(RegExp(string), toFilepathRelative))


###
Convenience function for sorting, slicing, filtering a list of page objects from
a content tree. `contentTreeGroup` can be any sub-group of a content tree object.

Example:

    listPages(contents._.pages, isntIndex, compareByFilename, 0, 10)
###
listPages = (contentTreeGroup, predicate, compare, start, end) ->
  predicate = isntIndex unless predicate?
  compare = comparePagesByDate unless compare?
  start = 0 unless start?
  end = Infinity unless end?

  # Convert object tree into array of files.
  # Filter out files we don't care about.
  # Sort the result.
  # Trim to range.
  contentTreeGroup
    .filter(predicate)
    .sort(compare)
    .slice(start, end)


plugin = (env, end) ->
  env.helpers.listPages = listPages
  env.helpers.searcher = searcher
  env.helpers.all = all
  env.helpers.isntIndex = isntIndex
  env.helpers.comparePagesByFilename = comparePagesByFilename
  env.helpers.comparePagesByDate = comparePagesByDate
  env.helpers.withPathMatching = withPathMatching
  end()


module.exports = plugin