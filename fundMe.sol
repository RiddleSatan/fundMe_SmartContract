//SPDX-License-Identifier:MIT

pragma solidity >=0.8.26;

import {PriceConvertor} from "./priceConvertor.sol";

contract FundMe {
    using PriceConvertor for uint256; //this is important line to add inorder to use the function of the library we created which is created

    uint256 minimumUSD = 5e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // function withdraw() public {}
        require(
            msg.value.conversionRate() > minimumUSD, //in this line we can see we didnt pass a value in conversionRate this is because msg.value automaticalllly used  used for the initial argument  of the conversionRate() function if there is another argument that is accepted then we pass the second argument inside the conversionRate() function
            "didnt send enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withDraw() public {
        for (
            uint256 fundersIndex = 0;
            fundersIndex <= funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }

        //resetting a array
        funders = new address[](0); // this reason why we use address cuz solidity is strictly typed and we have to defined the type with the new [] declaration of the array

        //transfer :Limit of 2300 Gas sends an error if fails
        // ## msg.sender is of type Address
        // ## payable(msg.sender) is of type payable address
        payable(msg.sender).transfer(address(this).balance);

        //send :Limit of 2300 Gas
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "there was an error: send failed"); //if sendSuccess is False then the function will revert else it will continue

        //call : no Limit Forwards all the Gas 
        (
            bool callSuccess, /*bytes memory dataReturned*/

        ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }
}
