###
#Auth Middleware Initializer
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-auth-plugin*
*__Company__: PanjieSW*

Defines middleware for Auth plugin.
*********************************************
###

exports.auth_middleware = (api, next) ->
  ###
  Adds ``authenticate`` property to actions and do request verification
  for authenticated token based on its value (if it is truthy
  then the action can't be accessed by unauthenticated user).

  If the verification process is passed, the decoded user payload
  will be available in ``connection.user`` to the actions.
  ###
  authenticationMiddleware = (connection, actionTemplate, callback) ->
    if actionTemplate.authenticate is yes
      check = null
      if connection.rawConnection.req
        check = connection.rawConnection.req
      else
        check = connection['mock']

      if check.headers and check.headers['authorization']
        parts = check.headers['authorization'].split ' '
        if parts.length is 2
          scheme = parts[0]
          credentials = parts[1]
          token = credentials  if /^Token$/i.test(scheme)
          api.Auth.verifyToken(token, {})
          .then (decoded) ->
            connection.user = decoded
            callback connection, yes
          .catch (err) ->
            error = new api.Auth.UnauthorizedError err.message, 'invalid_token'
            connection.error = error
            connection.rawConnection.responseHttpCode = error.status
            callback connection, no
          return
        else
          error = new api.Auth.UnauthorizedError(
            'Format is Authorization: Token [token]', 'credentials_bad_format')
          connection.error = error
          connection.rawConnection.responseHttpCode = error.status
          callback connection, no
          return
      else
        error = new api.Auth.UnauthorizedError(
          'No Authorization header was found', 'credentials_required')
        connection.error = error
        connection.rawConnection.responseHttpCode = error.status
        callback connection, no
        return

    callback connection, yes

  api.actions.preProcessors.push authenticationMiddleware

  next()
