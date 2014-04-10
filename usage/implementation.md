---
layout: doc
title: Implementation
nav: impl
prevDoc: /configuration.html
prevTitle: Configuration
nextDoc: /usage/custom-password-crypt.html
nextTitle: Custom Password Crypt
---

## The Flow

This plugin relies on how you implement some of required logic. You need to make a service / interface accessible under actionhero ``api`` object, do the necessary things there and call a callback function / return a promise. Below is how we illustrate this flow.

<p style='text-align:center;'><img src="/img/auth-flow.png"></p>
<p style='text-align:center;'><img src="/img/signup-flow.png"></p>

## Required Implementation
Anywhere in one of your ``initializers``, implement these following methods. There is an [example](https://github.com/panjiesw/ah-auth-plugin/blob/master/sample/initializers/auth_impl.js) of these implementations using in-memory persistance.

### api.AuthImpl.signUp(userData, uuid, callback)
Called when a new user signs up to your app. You can save the ``userData`` and ``uuid`` to your database here. The ``userData`` already contains hashed password the user submitted earlier.

- ``userData``, The user's data submitted during signup process.
- ``uuid``, The unique id generated for activation process.
- ``callback``, The function to call after you've finished doing things here. Have to be called with these following parameters:
    - ``error``, In case any error happened during the process here, pass the error object. Otherwise pass ``null``.
    - ``data``, A hash containing these required field:
        - ``user``, The user's data.
        - ``uuid``, The unique id for activation process.
        - ``options``, The options to pass to ah-nodemailer-plugin, to send verification email. Please refer to [api.Mailer.send](https://github.com/panjiesw/ah-nodemailer-plugin#apimailersendoptions-callback) to see available options.

example:

```javascript
// User and Token is a model of some database.
api.AuthImpl.signUp = function(userData, uuid, callback) {
  User.save(userData);
  Token.save({uuid: uuid});
  var data = {
    user: userData,
    uuid: uuid,
    options: {
      locals: {
        firstName: userData.firstName,
        lastName: userData.lastName
      }
    }
  };

  // No error here, so the first argument of callback is null.
  callback(null, data);
};
```

### api.AuthImpl.findUser(login, callback)
Called when a user signs in. You can do a database query to find the user here.

- ``login``, The login field (username / email depends on your implementation) submitted during the process.
- ``callback``, The function to call after you've finished doing things here. Have to be called with these following parameters:
    - ``error``, In case any error happened during the process here, pass the error object. This includes the case where no user is found. Otherwise pass ``null``.
    - ``user``, The user data for the signed in user.

example:

```javascript
// User is a model for some database.
api.AuthImpl.findUser = function(login, callback) {
  User.find({username: login}, function(err, user) {
    if(err) {
      callback(err);
      return;
    }
    if(!user) {
      callback(new Error('No user is found'));
      return;
    }
    callback(null, user);
  });
};
```

### api.AuthImpl.jwtPayload(user, callback)
Compose the user's payload. Include any substantial user's data you want to be available later in restricted actions.

- ``user``, The user's data. This is basically the same user's data you provide in [api.AuthImpl.findUser](#apiauthimplfinduserlogin-callback) above.
- ``callback``, The function to call after you've finished doing things here. Have to be called with these following parameters:
    - ``error``, In case any error happened during the process here, pass the error object. Otherwise pass ``null``.
    - ``options``, A hash consists of these following fields:
        - ``payload``, The manipulated user's data above.
        - ``expired``, The expire time of the token. Leave this to provide default value as in [JWT Configuration](/configuration.html#apiconfigjwt).

example:

```javascript
api.AuthImpl.jwtPayload = function(user, callback) {
  // Exclude the user's password from soon to be signed jwt payload.
  delete user.password;
  callback(null, {payload: user});
};
```
