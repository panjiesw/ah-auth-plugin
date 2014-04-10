---
layout: doc
title: Actions
nav: actions
prevDoc: /usage/custom-password-crypt.html
prevTitle: Custom Password Crypt
nextDoc: /actions.html
nextTitle: Actions
---

In actionhero, ``action`` is the entry point to your API Server. And the point of providing authentication to our API Server is mostly because we want to restrict some API to only accessible to authenticated user. Here is how we do it with ah-auth-plugin.

## Provided Actions
For your convinience, ah-auth-plugin provides two basic actions to authenticate / sign a user in and also register a new user. You can include these in your ``routes.js`` or call it directly by specifying ``?action=`` param in a URL.

### [POST] authenticate
Authenticate / sign a user in, using *authentication flow* described in [Implementation](/implementation.html). The action's name is ``authenticate``.

- **Required Parameters**
    - ``login``, The user's username / email address. Depends on your implementation.
    - ``password``, The user's password.
- **Optional Parameters**
    - ``remember``, Boolean indicating whether to remember this user's login.
        Basically this is only provided for you to implement. For example, because JWT doesn't use ``session``, remembering a user login could mean extending the ``expire`` time of the token beyond the default value.
- **Returns** A JSON Object containing only one field:
    - ``token``, The signed JWT Payload. Save this in your client persistence scheme.

example:

```bash
$ curl -X POST -H "Content-Type: application/json" -d '{"login":"someone", "password":"somepassword"}' http://localhost:8080/api/authenticate
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9...."
}
```

or

```bash
$ curl -X POST -d "login=someone&password=somepassword" http://localhost:8080/api/authenticate
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9...."
}
```

### [POST] signUp
Register a new user, using *signUp flow* described in [Implementation](/implementation.html). The action's name is ``signUp``.

- **Required Parameters**
    - ``data``, A JSON data of the new user.
- **Optional Parameters**
    - None
- **Returns** None

------------------------------------------------------------------------------

## Restricting actions
To restrict an action so only an authenticated user can access it, add a property ``authenticate: true`` to your action module's exports.

```javascript
var action = {};

/////////////////////////////////////////////////////////////////////
// metadata
action.name = 'restricted';
action.description = 'I am accessible only to authenticated user';
action.inputs = {
  'required' : [],
  'optional' : []
};
action.blockedConnectionTypes = [];
action.outputExample = {
  status: 'OK',
  uptime: 1234,
  stats: {}
}
action.authenticate = true

/////////////////////////////////////////////////////////////////////
// functional
action.run = function(api, connection, next){
  connection.response.user = connection.user;
  next(connection, true);
};

/////////////////////////////////////////////////////////////////////
// exports
exports.action = action;
```

As you can see above, if the incoming request is valid and authenticated, a ``connection.user`` object is available for you to use in this request.

The value of ``connection.user`` is the same as the payload you compose using implementation [api.AuthImpl.jwtPayload](/usage/implementation.html#apiauthimpljwtpayloaduser-callback) discussed earlier.

------------------------------------------------------------------------------

## Client Authentication
To authenticate from a client you can call the ``/api/authenticate`` endpoint above. If the authentication is successful, the server will return a JWT Signed Payload. The client then, is responsible of managing the Token, e.g saving it in ``localStorage`` or ``sqlite`` database. This saved Token must be included as ``Authorization`` header in subsequent Restricted API Call to authenticate the request.

```
Authorization: Token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9....
```

example of using ``curl`` after successfully authenticate the user:

```bash
$ curl -X GET -H 'Authorization: Token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9....' http://localhost:8080/api/restricted
{
  "user": {
    "username": "someone"
    "email": "someone@somewhere.com"
    "firstName": "Some"
    "lastName": "Derp"
  }  
}
```

Here is a good read about managing request from an AngularJS client to API Server using JSON Web Token:

- [Cookies vs Tokens. Getting auth right with Angular.JS](http://blog.auth0.com/2014/01/07/angularjs-authentication-with-cookies-vs-token/)
