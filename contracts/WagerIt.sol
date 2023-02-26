pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./atm.sol";

contract WagerIt is ATM, Ownable {
    struct Wager {
        string name;
        address add;
        uint256 amount;
        Result resultWager;
    }

    struct Result {
        string name;
        uint256 totalWageredAmount;
    }

    event NewWager(address add, uint256 amount, Result resultBet);

    Wager[] wagers;
    Result[] results;

    address wagerOwner;
    uint256 public totalWageredMoney = 0;

    mapping(address => uint256) public wagersPerAddress;

    constructor(
        string memory _result1,
        string memory _result2,
        address _owner
    ) public payable {
        wagerOwner = _owner;

        results.push(Result(_result1, 0));
        results.push(Result(_result2, 0));
    }

    function getOwner() public view returns (address) {
        return wagerOwner;
    }

    function createResult(string memory _name) public {
        results.push(Result(_name, 0));
    }

    function getTotalWageredAmount(uint256 _resultId)
        public
        view
        returns (uint256)
    {
        return results[_resultId].totalWageredAmount;
    }

    function createWager(string memory _name, uint256 _resultId)
        public
        payable
    {
        require(msg.sender != wagerOwner, "owner can't make a wager");
        require(
            wagersPerAddress[msg.sender] == 0,
            "you have already placed a wager"
        );
        /*
        require(msg.value > 0.01 ether, "Wager More");
        */
        deposit();

        wagers.push(Wager(_name, msg.sender, msg.value, results[_resultId]));

        if (_resultId == 0) {
            results[0].totalWageredAmount += msg.value;
        }
        if (_resultId == 1) {
            results[1].totalWageredAmount += msg.value;
        }

        wagersPerAddress[msg.sender]++;

        totalWageredMoney += msg.value;

        emit NewWager(msg.sender, msg.value, results[_resultId]);
    }

    function resultWinDistribution(uint256 _resultId) public payable onlyOwner {
        uint256 div;

        if (_resultId == 0) {
            for (uint256 i = 0; i < wagers.length; i++) {
                if (
                    keccak256(abi.encodePacked((wagers[i].resultWager.name))) ==
                    keccak256(abi.encodePacked("result1"))
                ) {
                    address payable receiver = payable(wagers[i].add);

                    div =
                        (wagers[i].amount *
                            (10000 +
                                ((getTotalWageredAmount(1) * 10000) /
                                    getTotalWageredAmount(0)))) /
                        10000;

                    (bool sent, bytes memory data) = receiver.call{value: div}(
                        ""
                    );
                    require(sent, "Failed to send Ether");
                }
            }
        } else {
            for (uint256 i = 0; i < wagers.length; i++) {
                if (
                    keccak256(abi.encodePacked((wagers[i].resultWager.name))) ==
                    keccak256(abi.encodePacked("result2"))
                ) {
                    address payable receiver = payable(wagers[i].add);
                    div =
                        (wagers[i].amount *
                            (10000 +
                                ((getTotalWageredAmount(0) * 10000) /
                                    getTotalWageredAmount(1)))) /
                        10000;

                    (bool sent, bytes memory data) = receiver.call{value: div}(
                        ""
                    );
                    require(sent, "Failed to send Ether");
                }
            }
        }

        totalWageredMoney = 0;
        results[0].totalWageredAmount = 0;
        results[1].totalWageredAmount = 0;

        for (uint256 i = 0; i < wagers.length; i++) {
            wagersPerAddress[wagers[i].add] = 0;
        }
    }
}
