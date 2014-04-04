var actionhero = new actionheroPrototype(),
    api;

describe('Testing Action: Auth', function () {
  before(function(done){
    actionhero.start(function(err, a){
      api = a;
      done();
    });
  });

  after(function(done){
    actionhero.stop(function(err){
      done();
    });
  });

  var userData = {
    username: 'someone',
    email: 'someone@somewhere.com',
    firstName: 'Some',
    lastName: 'Derp',
    password: 'somepassword'
  };

  it('must be able to signup', function (done) {
    api.specHelper.runAction('signup', {data: userData}, function(response, connection) {
      expect(connection.rawConnection.responseHttpCode).to.equal(201);
      done();
    });
  });

  it('must be able to signin / authenticate', function (done) {
    api.specHelper.runAction('authenticate', {login: 'someone', password: 'somepassword'}, function(response, connection) {
      expect(response.error).to.not.exist();
      expect(response.token).to.exist();
      done();
    });
  });

  it('has to return error when signin incorrectly', function (done) {
    api.specHelper.runAction('authenticate', {login: 'someone', password: 'wrongpassword'}, function(response, connection) {
      expect(response.error).to.equal('UnauthorizedError: Invalid credentials');
      expect(connection.rawConnection.responseHttpCode).to.equal(401);
      done();
    });
  });
});
