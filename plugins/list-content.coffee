_ = require('underscore')


compareFilesByFilename = (a, b) ->
  ###
  Compares filenames of each file object. Returns a sorting number.
  ###
  a = a.getFilename()
  b = b.getFilename()
  if a < b then 1 else if a > b then -1 else 0


compareFilesByDate = (a, b) ->
  ###
  Compares UNIX timestamps of each file object. Returns a sorting number.
  ###
  a = a.date.getTime()
  b = b.date.getTime()
  if a > b then -1 else if a < b then 1 else 0


###
Is object a file object?
We consider any object with a `getUrl` method to be a file object.
###
isFile = (object) -> object and object.getUrl?


###
Is file object not an index file?
###
isFileAndIsntIndex = (file) ->
  isFile(file) and file.filepath.relative.search('index.') isnt -1


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
###
all = (predicates...) -> (thing) ->
  rAll = (isPass, predicate) -> if isPass then predicate(thing) else false
  predicates.reduce(rAll, true)


###
Convenience function for sorting, slicing, filtering a list of file objects from
a content tree. `contentTree` can be any tree object or any node of the content
tree. Only immediate values of node are considered. Child nodes are ignored.
###
listContent = (contentTree, predicate, compare, start, end) ->
  predicate = isFileAndIsntIndex unless predicate?
  compare = compareFilesByDate unless compare?
  start = 0 unless start?
  end = Infinity unless end?

  # Convert object tree into array of files.
  # Filter out files we don't care about.
  # Sort the result.
  # Trim to range.
  _.values(contentTree)
    .filter(predicate)
    .sort(compare)
    .slice(start, end)


plugin = (env, end) ->
  env.helpers.listContent = listContent
  env.helpers.searcher = searcher
  env.helpers.all = all
  env.helpers.isFile = isFile
  env.helpers.isFileAndIsntIndex = isFileAndIsntIndex
  env.helpers.compareFilesByFilename = compareFilesByFilename
  env.helpers.compareFilesByDate = compareFilesByDate
  end()


module.exports = plugin