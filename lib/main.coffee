# require npm modules
request = require 'request'
semcmp = require 'semver-compare'

getBaseApiUrl = (repo) -> 'https://api.github.com/repos/'+repo+'/releases/latest'

module.exports = (options, callback) ->

  # get options
  repo = options.repo
  currentVersion = options.currentVersion

  # check if required options are defined
  error 'no repository specified' if repo is undefined
  error 'no current version given' if currentVersion is undefined

  apiUrl = getBaseApiUrl repo

  # request options
  reqOpts =
    url: apiUrl
    headers:
      'User-Agent': options.useragent or 'github-version-checker'

  request reqOpts, (error, response, body) ->
    throw error if error

    # parse the response body into an object
    release = JSON.parse body

    found = false

    if release.tag_name
      tag = release.tag_name.replace(/[^0-9$.,]/g, '')
      if semcmp(currentVersion, tag) is -1
        found = true
        callback release

    callback null if not found

# error method
error = (cause) ->
  throw 'Error! ' + cause
