pragma solidity ^0.8.25;

// import ERC-20
import {ERC20} from "./ERC20.sol";

contract PoolStack{
    // pool data
    address internal owner;
    string[2] internal tokens; 
    string internal time;
    uint8 internal rate;
    uint256 internal totalStacked;
    uint256 internal duration;

    //user data
    struct data{
        uint256 reward;
        uint256 balance;
        uint256 durationStack;
    }

    mapping(address => data) internal stackData;

    //event for deposit
    event Deposit(address indexed _from, address indexed _to, uint256 _amount);
    //event for without
    event Without(address indexed _from, address indexed _to, uint256 _amount);

    constructor(string[2] memory _tokens, uint8 _rate, string memory _time, uint256 _duration) payable{
        owner = msg.sender;
        tokens = _tokens;
        rate = _rate;
        time = _time;
        duration = _duration;
    }

    function getTime() external view returns(string memory){
        return time;
    }

    function getRate() external view returns(uint8){
        return rate;
    }

    function getTotalStaking() external view returns(uint256){
        return totalStacked;
    }

    //function to check balance's address user in pool
    function getBalanceAddress(address _owner) external view returns(uint256){
        require(_owner != address(0));
        require(stackData[owner].balance > 0);
        return stackData[_owner].balance;
    }
    
    //function to check reward's address user in pool
    function getRewardAddress(address _owner) external view returns(uint256){
        require(_owner != address(0));
        require(stackData[owner].balance > 0);
        return stackData[_owner].reward;
    }

    function goStackERC20(address payable _from, uint256 _amount) external returns(bool){
        require(_from != address(0));
        require(_amount > 0);
        // add data in user struct
        stackData[_from].balance += _amount;
        stackData[_from].durationStack = duration - block.timestamp;
        // compute users's rewards
        stackData[_from].reward = _computeReward(_from);
        totalStacked += _amount;

        emit Deposit(_from, address(this), _amount);
        return true;
    }

    function goStackETH(address payable _from, uint256 _amount) external returns(bool){
        require(_from != address(0));
        require(_amount > 0);
        payable(address(this)).transfer(_amount);
        totalStacked += _amount;

        emit Deposit(_from, address(this), _amount);
        return true;
    }

    //function withoutERC20(address payable _to) external returns(bool){
     //   require(_to != address(0));
     //   require(stackData[_to].balance > 0);
    //}

    function withoutETH(address payable _to) external returns(bool){
        require(_to != address(0));
        require(stackData[_to].balance > 0);
        uint256 amount = stackData[_to].balance;
        stackData[_to].balance -= amount;
        stackData[_to].reward = 0;
        stackData[_to].durationStack = 0;
        totalStacked -= amount;
        _to.transfer(amount);
        
        emit Without(address(this), _to, amount);
        return true;
    }

    function claimRewardETH(address payable _owner) external returns(bool){
        uint256 amount = _claimRewardETH(_owner);
        _owner.transfer(amount);

        emit Without(address(this), _owner, amount);
        return true;
    }

    receive() external payable{
        stackData[msg.sender].balance += msg.value;
        stackData[msg.sender].durationStack = duration - block.timestamp;
        // compute users's rewards
        stackData[msg.sender].reward = _computeReward(msg.sender);
    }

    //subFunction to deposit ETH
    function _computeReward(address _owner) internal view returns(uint256){
        return (stackData[_owner].balance * rate * stackData[_owner].durationStack)/100;
    }

    // sub function to claim reward
    function _claimRewardETH(address payable _owner) internal returns(uint256){
        require(_owner != address(0));
        require(stackData[_owner].reward > 0);
        uint256 amount = stackData[_owner].reward;
        stackData[_owner].reward -= amount;
        return amount;
    }
}
