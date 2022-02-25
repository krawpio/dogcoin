const DogCoin = artifacts.require("DogCoin");

module.exports = function (deployer) {
  deployer.deploy(DogCoin, 10000);
};
