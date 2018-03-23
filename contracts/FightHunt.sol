pragma solidity ^0.4.19;

import "./Generals.sol";
import "./Ownable.sol";

contract FightHunt is Generals {
    
    uint public random = uint8(block.blockhash(block.number-1))%10;

    modifier isXP(uint id) {
        //其实升级经验要随着等级升高而增加,但我还是写死了,有时间改
        require(generals[id].XP >= 10);
        _;
    }

    function _changelevel(uint _id)  isXP(_id) internal  {
        require(msg.sender == GeneralOwner[_id]);
        generals[_id].level++;
        generals[_id].XP = 0;
    }

    function _hunterCooldown(uint _id) internal {
        GeneralOwner[_id].readyTime = uint(now + cooldownTime);
    }

    modifier is_ready(uint from_id){
        require(GeneralOwner[from_id].readyTime <= now);
    }

    function fight(address to_add,uint from_id,uint to_id) is_ready(from_id) public {
        require(GeneralOwner[from_id] == msg.sender);
        require(GeneralOwner[to_id] == to_add);
        if ((generals[from_id].fighting_force -  generals[to_id].fighting_force)*random >= 40){
                generals[from_id].XP++;
                generals[from_id].win_count++;
                _changelevel(from_id);

                generals[to_id].loss_count++;

                GeneralOwner[to_id] = to_add;
                GeneralOwnerCount[msg.sender]++;
                GeneralOwnerCount[to_add]--;
                
        }else{
                generals[to_id].XP++;
                generals[to_id].win_count++;
                _changelevel(to_id);

                generals[from_id].loss_count++;

                GeneralOwner[from_id] = to_add;
                GeneralOwnerCount[to_add]++;
                GeneralOwnerCount[msg.sender]--;
        }
        _hunterCooldown(from_id)
    }
    function hunt(uint from_id,uint to_id) public{
            require(GeneralOwner[from_id] == msg.sender);
             if ((generals[from_id].fighting_force -  generals[to_id].fighting_force)*random >= 50){
                generals[from_id].XP++;
                generals[from_id].win_count++;
                _changelevel(from_id);

                GeneralOwner[to_id] = owner;
             }else{
                generals[from_id].level--;
                generals[from_id].loss_count++;
             }
             _hunterCooldown(from_id)
        } 
    
    
}
