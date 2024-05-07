// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract ERC20 is Ownable, ReentrancyGuard {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        
        _totalSupply = totalSupply_ * (10 ** uint256(decimals_));
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public override {
        _transfer(msg.sender, to, value);
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override {
        require(!_isContract(spender), "ERC20: approve to a contract");
        _approve(msg.sender, spender, amount);
    }

    function transferFrom(address from, address to, uint256 value) public override {
        _spendAllowance(from, msg.sender, value);
        _transfer(from, to, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public override {
        require(!_isContract(spender), "ERC20: increase allowance to a contract");
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override {
        require(!_isContract(spender), "ERC20: decrease allowance to a contract");
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
    }

    function _transfer(address from, address to, uint256 value) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= value, "ERC20: transfer amount exceeds balance");

        _beforeTransfer(from, to, value);

        _balances[from] -= value;
        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: transfer from the zero address");
        require(spender != address(0), "ERC20: transfer to the zero address");
        require(_allowances[owner][spender] >= value, "ERC20: transfer amount exceeds allowance");

        _beforeSpendAllowance(owner, spender, value);

        unchecked {
            _allowances[owner][spender] -= value;
        }
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _beforeApprove(owner, spender, value);

        _allowances[owner][spender] = value;

        emit Approval(owner, spender, value);
    }

    /*
          _beforeTransfer, _beforeSpendAllowance, _beforeApprove: 
          Internal functions called before transferring, spending allowance, 
          and approving to prevent reentrancy attacks. 
          They check if the function has already been called with the same parameters.
     */

    function _beforeTransfer(address from, address to, uint256 value) internal {
        require(!_hasBeenCalled(msg.sender, msg.data), "ERC20: reentrancy detected");
        _setBeenCalled(msg.sender, msg.data);
    }

    function _beforeSpendAllowance(address owner, address spender, uint256 value) internal {
        require(!_hasBeenCalled(msg.sender, msg.data), "ERC20: reentrancy detected");
        _setBeenCalled(msg.sender, msg.data);
    }

    function _beforeApprove(address owner, address spender, uint256 value) internal {
        require(!_hasBeenCalled(msg.sender, msg.data), "ERC20: reentrancy detected");
        _setBeenCalled(msg.sender, msg.data);
    }

    /*  _isContract first checks if there is bytecode present at the specified address (size > 0),
         and then additionally verifies that the codehash of the account is not zero. 
        The codehash is a more reliable indicator of the presence of bytecode at an address.
        refactored the storage of function calls to use a mapping _calledFunctions that tracks 
        whether a function with a specific signature has been called by a specific address. 
        This helps prevent reentrancy attacks by ensuring that each function with specific parameters
        can only be called once.
    */
    function _isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0 && account.codehash != 0;
    }

    mapping(address => mapping(bytes32 => bool)) private _calledFunctions;

    function _hasBeenCalled(address caller, bytes32 funcSig) internal view returns (bool) {
        return _calledFunctions[caller][funcSig];
    }

    function _setBeenCalled(address caller, bytes32 funcSig) internal {
        _calledFunctions[caller][funcSig] = true;
    }
}

