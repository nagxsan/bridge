// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH is Ownable {

    address private tokenAddress;
    event Lock(address indexed depositor, uint256 amount);
    
    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function lock(address _tokenAddress, uint256 _amount) public {
        require(tokenAddress == _tokenAddress);
        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= _amount);
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);
        emit Lock(msg.sender, _amount);
    }

    function unlock(address _tokenAddress, address _to, uint256 _amount) public onlyOwner {
        require(tokenAddress == _tokenAddress);
        IERC20(tokenAddress).transfer(_to, _amount);
    }

}