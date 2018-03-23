pragma solidity ^0.4.19;
import "./Ownable.sol";
import 'node_modules/zeppelin-solidity/math/SafeMath.sol';
contract Generals is Ownable{
    
    using SafeMath for uint256;

    event NewGeneral(uint GeneralId,
    string name, 
    uint age, 
    uint8 fighting_force,
    uint level,
    uint win_count,
    uint loss_count,
    uint XP,
    uint create_time
    );

    struct General {
        string name;
        uint8 age;
        uint8  fighting_force;//战斗力
        uint16 level ;
        uint8 win_count;
        uint8 loss_count;
        uint8 XP;
        //之后可以加一些别的武将属性
        uint32 readyTime;
    }

    uint cooldownTime = 1 days;

    General[] public generals;
    //垃圾语言毁我青春,判断数字在数组的功能都没有,以下是我最初的想法
    // uint[] public owner_list;//武将 id 列表
    // mapping(address =>  uint[]) public GeneralOwner;
    mapping(uint => address) public GeneralOwner;
    mapping (address => uint) public GeneralOwnerCount;

     function createGeneral(string _name,uint _age) public {
         // 更多请看http://solidity.readthedocs.io/en/develop/units-and-global-variables.html
        //也可以看我的知乎文章:https://zhuanlan.zhihu.com/p/34313807 
        uint _fighting_force = uint8(block.blockhash(block.number-1))%10;

        uint id = generals.push(General(_name,_age,_fighting_force,0,0,0,0,uint32(now + cooldownTime))) - 1;//push返回的是长度,我们用来当数组的索引

        GeneralOwner[id] = msg.sender;
        GeneralOwnerCount[msg.sender]++;
        generals.push(General(_name,_age,_fighting_force,0,0,0,0));
        NewGeneral(id, _name, _age,_fighting_force,0,0,0,0,now);    
        
    }

    function createFreeGeneral(string _name,uint _age)  onlyOwner external{
        uint _fighting_force = uint8(block.blockhash(block.number-1))%10;

        uint id = generals.push(General(_name,_age,_fighting_force,0,0,0,0,uint32(now + cooldownTime))) - 1;//push返回的是长度,我们用来当数组的索引

        GeneralOwner[id] = owner;

        generals.push(General(_name,_age,_fighting_force,0,0,0,0));

        NewGeneral(id, _name, _age,_fighting_force,0,0,0,0,now);    
    }

    //找个函数问题很大,每次都要遍历所有武将,是因为之前改写了判断数字是否在数组的原因,找机会再改过来
    function getGeneral(address _owner) external view returns(uint[]) {
        //memory 别急,找个时间认真讲
      uint[] memory result = new uint[](GeneralOwnerCount[_owner]);//同长度数组
      uint counter = 0;
      for (uint i = 0; i < generals.length; i++) {
      if (GeneralOwner[i] == _owner) {
        result[counter] = i;
        //索引对应武将 id
        counter++;
      }
    }
    return result;
  }   

    uint improve_force = 0.001 ether;
    
  function setImproveForce(uint price) external onlyOwner {
    improve_force = price;
  }

  function improveForce(uint _general_id) payable {
    require(msg.value == improve_force);
    require( generals[_general_id].fighting_force < 20);
    generals[_general_id].fighting_force++;
  }
  //this.balance当前合约存储的以太币
  function getEth()  external onlyOwner {
    owner.transfer(this.balance);
  }

}