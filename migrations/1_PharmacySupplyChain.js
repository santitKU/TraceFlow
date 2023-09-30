var PharmacySupplyChain = artifacts.require("./PharmacySupplyChain.sol");

module.exports = function (deployer) {
  deployer.deploy(PharmacySupplyChain);
};
