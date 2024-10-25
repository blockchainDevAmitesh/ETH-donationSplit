// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.27;

contract DonationSplit {
    address private recipient1;
    address private recipient2;

    // asks for recipients addresses at the time of deployment
    constructor(address _recipient1, address _recipient2) {
        require(_recipient1 != address(0) && _recipient2 != address(0), "Invalid recipient address.");
        recipient1 = _recipient1;
        recipient2 = _recipient2;
    }

    // fallback function to receive ethers
    receive() external payable {
        uint totalETH = msg.value;

        (bool transaction1, ) = recipient1.call{ value: totalETH / 2 } ("");
        require(transaction1, "Transfer to recipient1 failed."); // reverts total received ETH to the senders address if transaction1 fails

        (bool transaction2, ) = recipient2.call{ value: totalETH - (totalETH / 2) } ("");
        require(transaction2, "Transfer to recipient2 failed."); // reverts transaction1 and total received ETH to the sender's address if transaction2 fails
    }

    // changing recipient
    function changeRecipient(uint _recipientNumber, address _newRecipient) external {
        require(_newRecipient != address(0), "Invalid recipient address.");
        if (_recipientNumber == 1 && msg.sender == recipient1){
            recipient1 = _newRecipient; // works if owner try to change his address
        } else if (_recipientNumber == 2 && msg.sender == recipient2) {
            recipient2 = _newRecipient; // works if owner try to change his address
        } else {
            if (_recipientNumber != 1 && _recipientNumber != 2) {
                revert ("Please enter the correct recipient."); // will show this if wrong owner number is entered
            } else if (msg.sender != recipient1 && msg.sender != recipient2) {
                revert ("Access Denied: Unauthorized Access."); // will show this if none of the owners try to change recipient
            } else {
                revert ("Something unexpected occurred; please try again."); // will show this if any error occur due to unknown reason
            }
        }
    }
}