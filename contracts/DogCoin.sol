// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import  "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


uint constant NONE = 2^256;

contract DogCoin is Initializable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {

    event HolderAdded(address indexed holder);
    event HolderRemoved(address indexed holder);

    address[] private holders;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize(uint256 initialSupply) initializer public {
        __ERC20_init("dogcoin", "DOG");
        __Ownable_init();
        __UUPSUpgradeable_init();
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

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
