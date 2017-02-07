var IdentityGuard = artifacts.require('./IdentityGuard.sol');

module.exports = function(deployer) {
  deployer.deploy(IdentityGuard);
};
