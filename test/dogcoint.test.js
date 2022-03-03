const truffleAssert = require('truffle-assertions');


const DogCoin = artifacts.require("./contract/DogCoin.sol");

contract("DogCoin", accounts => {
  it("should have initial values", async () => {
    const dogCoinInstance = await DogCoin.deployed();
    let supply = await dogCoinInstance.totalSupply();
    let senderBalance = await dogCoinInstance.balanceOf(accounts[0]);
    let holderExists = await dogCoinInstance.holderExists(accounts[0]);

    assert.equal(supply, 10000);
    assert.equal(senderBalance, 10000);
    assert.equal(holderExists, true);
  });

  it("should add holder when transfer to new holder account", async () => {
    const dogCoinInstance = await DogCoin.deployed();
    let tx = await dogCoinInstance.transfer(accounts[1], 100)
    truffleAssert.eventEmitted(tx, 'HolderAdded', (event) => {
      return event.holder === accounts[1];
    });
    truffleAssert.eventNotEmitted(tx, 'HolderRemoved');
    let newHolderExists = await dogCoinInstance.holderExists(accounts[1]);

    assert.equal(newHolderExists, true);
  });
});

contract("DogCoin", accounts => {
  it("should remove holder when balance is set to 0", async () => {
    const dogCoinInstance = await DogCoin.deployed();
    await dogCoinInstance.transfer(accounts[1], 100)
    let tx = await dogCoinInstance.transfer(accounts[2], 100, {from: accounts[1]})

    truffleAssert.eventEmitted(tx, 'HolderRemoved', (event) => {
      return event.holder === accounts[1];
    });
    truffleAssert.eventEmitted(tx, 'HolderAdded', (event) => {
      return event.holder === accounts[2];
    });
    let previousHolderExists = await dogCoinInstance.holderExists(accounts[1]);
    let newHolderExists = await dogCoinInstance.holderExists(accounts[2]);

    assert.equal(newHolderExists, true);
    assert.equal(previousHolderExists, false);
  });
});
