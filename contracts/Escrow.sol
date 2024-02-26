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
    
    function list(uint256 _nftID) public{

        // Tranfer property NFT from seller wallet into escrow
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        // Mark property NFT as listed
        isListed[_nftID] = true;
    }
}
