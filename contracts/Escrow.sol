//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// For the ERC721 NFT token
interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) external;
}

// Escrow contract to hold property NFTs during sale process
contract Escrow {
    address public lender;
    address public inspector;
    address payable public seller;
    address public nftAddress;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this function");
        _;
    }

    modifier onlyBuyer(uint256 _nftID) {
        require(msg.sender == buyer[_nftID], "Only buyer can call this function");
        _;
    }

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this function");
        _;
    }

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => uint256) public escrowAmount;
    mapping(uint256 => bool) public inspectionPassed;
    mapping(uint256 => mapping(address => bool)) public approval;

    constructor(
        address _lender,
        address _inspector,
        address payable _seller,
        address _nftAddress
    ) {
        lender = _lender;
        inspector = _inspector;
        seller = _seller;
        nftAddress = _nftAddress;
    }
    
    // List property NFT for sale
    function list(uint256 _nftID, uint256 _purchasePrice, address _buyer, uint256 _escrowAmount) public payable onlySeller{

        // Tranfer property NFT from seller wallet into escrow
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        // Mark property NFT as listed
        isListed[_nftID] = true;

        // Set the purchase price for the property NFT
        purchasePrice[_nftID] = _purchasePrice;

        // Set the buyer for the property NFT
        buyer[_nftID] = _buyer;

        // Set the escrow amount for the property NFT
        escrowAmount[_nftID] = _escrowAmount;
    }

    // Put deposit into escrow
    function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID){
        require(msg.value >= escrowAmount[_nftID], "Deposit amount must be greater than or equal to escrow amount");
    }

    // Update inspection status
    function updateInspectionStatus(uint256 _nftID, bool _status) public onlyInspector{
        inspectionPassed[_nftID] = _status;
    }

    // Approve the release of escrow
    function approveSale(uint256 _nftID) public{
        approval[_nftID][msg.sender] = true;
    }

    // Receive function to allow smart contract to receive ether
    receive() external payable {}

    // Getter function to check escrow balance
    function getBalance() public view returns (uint256){
        return address(this).balance;
    }

    // Finalize sale and transfer property NFT to buyer
    function finalizeSale(uint256 _nftID) public{
        require(inspectionPassed[_nftID], "Inspection must pass before finalizing sale");
        require(approval[_nftID][buyer[_nftID]], "Buyer must approve the release of escrow");
        require(approval[_nftID][seller], "Seller must approve the release of escrow");
        require(approval[_nftID][lender], "Lender must approve the release of escrow");
        require(address(this).balance >= purchasePrice[_nftID], "Insufficient funds in escrow");

        // Mark property NFT as not listed
        isListed[_nftID] = false;

        // Transfer escrow amount to seller
        (bool success, ) = payable(seller).call{value: address(this).balance}("");
        require(success);

        // Tranfer property NFT from escrow into buyer wallet
        IERC721(nftAddress).transferFrom(address(this), buyer[_nftID], _nftID);

    }

    // Cancel sale and refund deposit to buyer
    function cancelSale(uint256 _nftID) public{
        if(inspectionPassed[_nftID]){
            payable(buyer[_nftID]).transfer(address(this).balance);
        }
        else{
            payable(seller).transfer(address(this).balance);
        }
    }
}