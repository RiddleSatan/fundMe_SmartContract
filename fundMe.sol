//SPDX-License-Identifier:MIT

pragma solidity >=0.8.26;

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(
//     uint80 _roundId
//   ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

//   function latestRoundData()
//     external
//     view
//     returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
// }

// or we can import it from github

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 minimumUSD = 5e18;

    function fund() public payable {
        // function withdraw() public {}
        require(
            conversionRate(msg.value) > minimumUSD,
            "didnt send enough ETH"
        );
    }

    function getPrice() public view returns (uint256) {
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (
            ,
            /* uint80 roundID */
            int256 price, /*uint startedAt*/
            ,
            ,

        ) = /*uint timeStamp*/
            /*uint80 answeredInRound*/
            priceFeed.latestRoundData();
        return uint256(price * 1e18); //1 ETH = 1e9 Gwei  = 1e18 Wei
    }

    function conversionRate(uint256 _ethAmt) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmtinUSD = (ethPrice * _ethAmt) / 1e18;
        return ethAmtinUSD;
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
