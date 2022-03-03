const DogCoin = artifacts.require("DogCoin");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function (deployer) {
  await deployProxy(DogCoin, [10000], { deployer, kind:'uups'});
};
