pragma solidity 0.6.4;

contract ATM {
    mapping(address => uint256) public balances;

    event Deposit(address sender, uint256 amount);
    event Withdrawal(address receiver, uint256 amount);

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
        balances[msg.sender] += msg.value;
    }

    function depositInEth(uint256 amount) public payable {
        emit Deposit(msg.sender, amount * 1000000000000000000);
        balances[msg.sender] += amount * 1000000000000000000;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        emit Withdrawal(msg.sender, amount);
        balances[msg.sender] -= amount;
    }
}
