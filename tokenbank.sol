// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);
}


contract tokenbank {

    address private owner; 
    mapping(address => mapping(address => uint)) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(address _owner){
        owner = _owner;
    }

    function deposite(address token, uint256 amount) external  {
        uint allowanceAmount = IERC20(token).allowance(msg.sender, address(this));
        IERC20(token).transferFrom(msg.sender,address(this),amount);

        if (amount < allowanceAmount) {
            revert ();
        }

        if (!IERC20(token).transferFrom(msg.sender, address(this), amount)) {
            revert ();
        }

        balances[token][msg.sender] += amount;
    }

    function withdraw(address token, uint amount) external {
        if(msg.sender == owner){
            require(amount < balances[token][address(this)],"go away");
            balances[token][address(this)] -= amount;
            IERC20(token).transfer(msg.sender , amount);
        }else{
            require(amount < balances[token][msg.sender],"go away");
            balances[token][msg.sender] -= amount;
            IERC20(token).transfer(msg.sender , amount);
        }


    }
}