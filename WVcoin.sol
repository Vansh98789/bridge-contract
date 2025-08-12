// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract WVCoin is ERC20,Ownable{
    constructor() ERC20("WVcoin","WVcC") Ownable(msg.sender){
    }
    function mint(address to , uint amount) public onlyOwner{
        _mint(to, amount);
    }
    function burn(address from, uint amount) public onlyOwner {
        _burn(from, amount);
    }
}