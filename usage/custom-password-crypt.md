---
layout: doc
title: Custom Password Crypt
nav: pwd
prevDoc: /usage/implementation.html
prevTitle: Implementation
nextDoc: /usage/actions.html
nextTitle: Actions
---

Beside the required implementation you have to provide, you can also provide optional implementation of password crypt mechanism. The default password crypt is ``scrypt``. If you want to provide your own password crypt logic, you have to provide **both** of methods below.

### api.AuthImpl.encodePassword(password, callback)
Encodes provided raw ``password`` string.

- ``password``, The raw password string to encode.
- ``callback``, The function to call after encoding is finished. Have to be called with these following parameters:
    - ``error``, In case any error happened during the process here, pass the error object. Otherwise pass ``null``.
    - ``cryptedPassword``, The crypted password string.

### api.AuthImpl.matchPassword(cryptedPassword, password, callback)
Match provided ``password`` with its ``cryptedPassword``.

- ``cryptedPassword``, The cryptedPassword string to match.
- ``password``, The raw password string to match.
- ``callback``, The function to call after matching is finished. Have to be called with these following parameters:
    - ``error``, In case any error happened during the process here, pass the error object. Otherwise pass ``null``.
    - ``matched``, Indicates whether the password is match.
