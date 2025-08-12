// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/access/Ownable.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
contract BridgeBase is Ownable{
    address tokenAddress;
    event burned(address to,uint amount);
    bool canWithDraw=false;
    mapping(address=>uint) pendingBalance;
    constructor(address _tokenAddress)Ownable(msg.sender){
        tokenAddress=_tokenAddress;
    }
    
    function depositOnOtherSide(address userAccount,uint amount )public{
        //get something triggered
        pendingBalance[userAccount]+=amount;
        canWithDraw=true;

    }
    function  withdraw(uint  amount,IERC20 _tokenAddress)public onlyOwner{
        require(canWithDraw==true);
        require(tokenAddress==address(_tokenAddress));
        _tokenAddress.transfer(msg.sender, amount);


    }
    function burnToken(uint amount ) public onlyOwner{
        require(amount<=pendingBalance[msg.sender],"amount not available in your account");
        pendingBalance[msg.sender]-=amount;
        emit burned(msg.sender ,amount);

    }

}