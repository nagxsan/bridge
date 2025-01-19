// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

interface IWMumCoin {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract BridgeBase is Ownable {

    address private tokenAddress;
    event Burn(address indexed burner, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function mint(address _tokenAddress, address _to, uint256 _amount) public onlyOwner {
        require(tokenAddress == _tokenAddress);
        IWMumCoin(tokenAddress).mint(_to, _amount);
        IERC20(tokenAddress).transfer(_to, _amount);
    }

    function burn(address _tokenAddress, uint256 _amount) public {
        require(tokenAddress == _tokenAddress);
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= _amount);
        IWMumCoin(tokenAddress).burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
    }

}