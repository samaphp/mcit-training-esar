pragma solidity ^0.4.19;

contract USD {

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function issueUSD(address to, uint amount) public {
        if(msg.sender == owner) {
            balances[to] += amount;
        }
    }

    function transferUSD(address to, uint amount) public {
        if(balances[msg.sender] >= amount) {
            balances[msg.sender] -= amount;
            balances[to] += amount;
        }
    }

    function getUSDBalance(address account) public view returns (uint balance) {
        return balances[account];
    }

    function approve(address spender, uint amount) public {
        allowed[spender][msg.sender] = amount;
    }

    function transferUSDFrom(address from, address to, uint amount) public {
        if(allowed[msg.sender][from] >= amount && balances[from] >= amount) {
            allowed[msg.sender][from] -= amount;
            balances[from] -= amount;
            balances[to] += amount;
        }
    }
}
