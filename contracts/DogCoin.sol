// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

uint constant NONE = 2^256;


contract DogCoin is ERC20 {

    event HolderAdded(address indexed holder);
    event HolderRemoved(address indexed holder);

    address[] private holders;

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor(
        uint256 initialSupply
    ) ERC20('dogcoin', 'DOG') {
        _mint(msg.sender, initialSupply);
    }

    function _afterTokenTransfer(address from, address to, uint) internal override {
        _removeHolder(from);
        _addHolder(to);
    }


    function _addHolder(address holder) private {
        if ((_findIndex(holder) == NONE) && (balanceOf(holder) > 0)) {
            holders.push(holder);
            emit HolderAdded(holder);
        }
    }

    function _removeHolder(address holder) private {
        if ((_findIndex(holder) != NONE) && (balanceOf(holder) == 0)) {
            delete holders[_findIndex(holder)];
            emit HolderRemoved(holder);
        }
    }

    function _findIndex(address to) private view returns (uint) {
        for (uint i = 0; i < holders.length; i++) {
            if (holders[i] == to) {
                return i;
            }
        }
        return NONE;
    }

    function holderExists(address holder) public view returns(bool){
        return _findIndex(holder) != NONE;
    }
}
