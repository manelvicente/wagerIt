pragma solidity 0.6.4;

import "./wagerIt.sol";

contract WagerItFactory {
    event WagerCreated(address newContract);

    mapping(uint256 => address) public deployedWagers;

    address factoryOwner;
    uint256 wagerCounter = 0;

    constructor() public {
        factoryOwner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return factoryOwner;
    }

    function createMyWager(
        string memory _resultOption1,
        string memory _resultOption2
    ) public returns (WagerIt) {
        WagerIt wagerIt = new WagerIt(
            _resultOption1,
            _resultOption2,
            msg.sender
        );
        emit WagerCreated(address(wagerIt));

        wagerCounter++;
        deployedWagers[wagerCounter] = address(wagerIt);

        return wagerIt;
    }
}
