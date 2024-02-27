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

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => uint256) public escrowAmount;

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
}
