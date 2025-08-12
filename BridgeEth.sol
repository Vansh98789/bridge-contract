// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/access/Ownable.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
//need to store some money and when money is stored then we would trigger an event to mint token on other side 

contract BridgeEth is Ownable{
    address tokenAddress;
    bool burnOnOther=false;
    mapping(address=>uint) public pendingBalance;
    constructor(address _tokenAddress) Ownable(msg.sender){
        tokenAddress=_tokenAddress;
    }
    event deposited(address from , uint amount);
    function deposit(IERC20 _tokenAddress,uint amount) public payable{
        require(tokenAddress==address(_tokenAddress));
        require(amount>0,"Amount must be greater than 0");
        _tokenAddress.transferFrom(msg.sender, address(this), amount);
        pendingBalance[msg.sender] += amount;
        //in deposite just trigger an event to mint token on other side
        emit deposited(msg.sender,amount);

    }
    function withdraw(IERC20 _tokenAddress,uint amount) public onlyOwner{
        require(burnOnOther==true);
        require(tokenAddress==address(_tokenAddress));
        require(pendingBalance[msg.sender]<=amount,"you do not have enough money left in your contract");
        _tokenAddress.transfer(msg.sender, amount);
        pendingBalance[msg.sender]-=amount;
        burnOnOther=false;

    }
    function burnOnOtherSide(address userAccount,uint amount) public onlyOwner{
        //hadle some event
        pendingBalance[userAccount]+=amount;
        burnOnOther=true;
    }
}