###
#Auth Initializer
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-auth-plugin*
*__Company__: Panjie SW*

Defines ``api.Auth``
*********************************************
###

Q = require 'q'
_ = require 'lodash'
scrypt = require 'scrypt'
jwt = require 'jsonwebtoken'

Auth = (api, next) ->
  config = api.config.auth

  _encodePassword =
    scrypt: (password) ->
      Q.nfcall(scrypt.passwordHash, password, config.maxtime)

  _encodePasswordPromise = (password) ->
    if Q.isPromiseAlike api.AuthImpl.encodePassword
      api.AuthImpl.encodePassword password
    else
      Q.nfcall api.AuthImpl.encodePassword, password

  encodePassword = (password, callback) ->
    if api.AuthImpl and api.AuthImpl.encodePassword
      _encodePasswordPromise(password).nodeify callback
    else
      _encodePassword[scrypt](password).nodeify callback

  _matchPassword =
    scrypt: (passwordHash, password) ->
      Q.nfcall(scrypt.verifyHash, passwordHash, password)

  _matchPasswordPromise = (passwordHash, password) ->
    if Q.isPromiseAlike api.AuthImpl.matchPassword
      api.AuthImpl.matchPassword passwordHash, password
    else
      Q.nfcall api.AuthImpl.matchPassword, passwordHash, password

  matchPassword = (passwordHash, password, callback) ->
    deferred = Q.defer()
    if api.AuthImpl and api.AuthImpl.encodePassword
      unless api.AuthImpl.matchPassword
        deferred.reject(
          new Error('No api.AuthImpl.matchPassword implementation'))
      else
        _matchPasswordPromise(passwordHash, password)
        .then (result) ->
          deferred.resolve result
        .catch (error) ->
          deferred.reject error
    else
      _matchPassword[scrypt](passwordHash, password)
      .then (result) ->
        deferred.resolve result
      .catch (error) ->
        deferred.reject error

    deferred.promise.nodeify callback

  signPayload = (payload, expire=config.jwt.expire) ->
    jwt.sign payload, config.jwt.secret,
      expiresInMinutes: expire
      algorithm: config.jwt.algorithm

  verifyToken = (token, options, callback) ->
    Q.nfcall(jwt.verify, token, config.jwt.secret, options).nodeify callback

  _signUpPromise = (userData, uuid) ->
    if Q.isPromiseAlike api.AuthImpl.signUp
      api.AuthImpl.signUp userData, uuid
    else
      Q.nfcall api.AuthImpl.signUp, userData, uuid

  signUp = (userData, passwordField, needVerify, callback) ->
    deferred = Q.defer()

    userData.verified = !needVerify
    encodePassword(userData[passwordField])
    .then (passwordHash) ->
      userData[passwordField] = passwordHash
      unless api.AuthImpl and api.AuthImpl.signUp
        throw new Error('no api.AuthImpl.signUp implementation.')
      uuid = null
      if config.enableVerification and needVerify
        uuid = uuid.v4()
      return _signUpPromise(userData, uuid)
    .then (data) ->
      unless data.user
        throw new Error("no 'user' field in returned hash of
          'api.AuthImpl.signUp'")
      if config.enableVerification
        unless data.uuid
          throw new Error("Verification is enabled but no 'uuid'
            field in returned hash of 'api.AuthImpl.signUp'.")
        unless api.Mailer
          throw new Error("You need to install ah-nodemailer-plugin
              to be able to send verification mail.")

        options =
          mail:
            to: data.user.email
          locals:
            uuid: data.uuid
          template: if data.options then data.options.template else 'welcome'

        if data.options
          _.defaults options.mail, data.options.mail
          _.defaults options.locals, data.options.locals

        return api.Mailer.send options
      else
        return Q data
    .then (responseOrData) ->
      deferred.resolve true
    .catch (error) ->
      deferred.reject error

    deferred.promise.nodeify callback

  signIn = (login, password, callback) ->
    deferred = Q.defer()
    unless api.AuthImpl and api.AuthImpl.findUser
      deferred.reject Error('no api.AuthImpl.signUp implementation.')

  next()
