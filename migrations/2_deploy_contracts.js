var USD = artifacts.require("./USD.sol");
var LandRegistry = artifacts.require("./LandRegistry.sol")
var AtomicSwap_USD = artifacts.require("./AtomicSwap_USD.sol")
var AtomicSwap_LandRegistry = artifacts.require("./AtomicSwap_LandRegistry")

module.exports = function(deployer) {
  deployer.deploy(USD).then(function(){
    return deployer.deploy(AtomicSwap_USD, USD.address)
  });

  deployer.deploy(LandRegistry).then(function(){
    return deployer.deploy(AtomicSwap_LandRegistry, LandRegistry.address)
  });
};
