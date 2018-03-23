pragma solidity ^0.4.19;
import "./Generals.sol";


contract QueryOwner is Generals{
    function AmountOf(address owner) public returns(uint) {
        return GeneralOwnerCount[owner];
    }
    
    function ownerOf(uint id) public returns(address){
        return GeneralOwner[id];
    }
}