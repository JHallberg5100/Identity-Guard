var IdentityGuard = artifacts.require('./IdentityGuard.sol');
var IdentityBlok = artifacts.require('./IdentityBlok.sol');

module.exports = function(deployer) {
  deployer.deploy(IdentityGuard);
  deployer.deploy(IdentityBlok);
};
