var actionhero = new actionheroPrototype(),
    api;

describe('Testing Initializer: Auth', function () {

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

  it('members must exist', function () {
    expect(api.Auth).to.be.an.object();
    expect(api.Auth.encodePassword).to.be.a.function();
    expect(api.Auth.matchPassword).to.be.a.function();
    expect(api.Auth.signPayload).to.be.a.function();
    expect(api.Auth.verifyToken).to.be.a.function();
    expect(api.Auth.signUp).to.be.a.function();
    expect(api.Auth.signIn).to.be.a.function();
    expect(api.Auth.authenticate).to.be.a.function();
    expect(api.Auth.AuthError).to.be.a.function();
    expect(api.Auth.ImplementationError).to.be.a.function();
    expect(api.Auth.SignupError).to.be.a.function();
    expect(api.Auth.UnauthorizedError).to.be.a.function();
  });

  describe('api.Auth methods', function () {

    var userData = {
      username: 'someone',
      email: 'someone@somewhere.com',
      firstName: 'Some',
      lastName: 'Derp',
      password: 'somepassword'
    };
    var hashedPassword, token;

    it('encodes and matches password', function (done) {
      api.Auth.encodePassword('somepassword', function(err, hashed) {
        expect(err).to.not.exist();
        hashedPassword = hashed;
        api.Auth.matchPassword(hashed, 'somepassword', function(err, result) {
          expect(err).to.not.exist();
          expect(result).to.be.true();
          done();
        });
      });
    });

    it('throws error on unmatched password', function (done) {
      api.Auth.matchPassword(hashedPassword, 'wrongpassword', function(err, result) {
        expect(err).to.exist();
        expect(err.code).to.equal('incorrect_password');
        expect(err.status).to.equal(401);
        expect(result).to.not.exist();
        done();
      });
    });

    it('signs jwt payload', function () {
      token = api.Auth.signPayload({data: 'somedata'});
    });

    it('verifies token', function (done) {
      api.Auth.verifyToken(token, {}, function(err, decoded) {
        expect(err).to.not.exist();
        expect(decoded).to.have.property('data');
        done();
      });
    });

    it('must be able to signUp', function (done) {
      api.Auth.signUp(userData, 'password', true, function(error, response) {
        expect(error).to.not.exist();
        expect(response).to.be.true();
        done();
      });
    });

    it('must be able to signIn', function (done) {
      api.Auth.signIn('someone', 'somepassword', function(err, response) {
        expect(err).to.not.exist();
        expect(response).to.exist();
        done();
      });
    });

    it('must throws error on invalid password', function (done) {
      api.Auth.signIn('someone', 'wrongpassword', function(err, response) {
        expect(err).to.exist();
        expect(err.code).to.equal('incorrect_password');
        expect(err.status).to.equal(401);
        expect(response).to.not.exist();
        done();
      });
    });
  });

});
