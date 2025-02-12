// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    struct MusicMetadata {
        string title;
        string artist;
        string genre;
        string ipfsHash;
        uint256 timestamp;
        bool isNFT; // It Tracks whether the music has an NFT
    }

    mapping(uint256 => MusicMetadata) public musicRecords;
    mapping(string => bool) private ipfsHashExists;
    mapping(string => address) public registeredMusic; // Maps IPFS hash to the artist's address

    event MusicNFTMinted(address indexed artist, uint256 tokenId, string ipfsHash);
    event MusicCopyrightRegistered(address indexed artist, string ipfsHash, uint256 timestamp);

    // Constructor Initializes ERC721 and sets contract owner
    constructor() ERC721("MusicNFT", "MNFT") Ownable(msg.sender) {}

    // Function to Mint NFT
    function mintMusicNFT(
        string memory _title,
        string memory _artist,
        string memory _genre,
        string memory _ipfsHash
    ) public {
        require(!ipfsHashExists[_ipfsHash], "Music already registered!");

        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _ipfsHash);

        musicRecords[tokenId] = MusicMetadata({
            title: _title,
            artist: _artist,
            genre: _genre,
            ipfsHash: _ipfsHash,
            timestamp: block.timestamp,
            isNFT: true
        });

        ipfsHashExists[_ipfsHash] = true;
        registeredMusic[_ipfsHash] = msg.sender;

        emit MusicNFTMinted(msg.sender, tokenId, _ipfsHash);
    }

    // Function to Register Copyright (Without Minting NFT)
    function registerCopyright(
        string memory _title,
        string memory _artist,
        string memory _genre,
        string memory _ipfsHash
    ) public {
        require(!ipfsHashExists[_ipfsHash], "Music already registered!");

        _tokenIdCounter++;
        uint256 tokenId = _tokenIdCounter;

        // Store the music details without minting NFT
        musicRecords[tokenId] = MusicMetadata({
            title: _title,
            artist: _artist,
            genre: _genre,
            ipfsHash: _ipfsHash,
            timestamp: block.timestamp,
            isNFT: false
        });

        ipfsHashExists[_ipfsHash] = true;
        registeredMusic[_ipfsHash] = msg.sender;

        emit MusicCopyrightRegistered(msg.sender, _ipfsHash, block.timestamp);
    }

    // Function to Retrieve Music Metadata (For Both NFTs & Copyrighted Music)
    function getMusicMetadata(uint256 _tokenId) public view returns (MusicMetadata memory) {
        require(musicRecords[_tokenId].timestamp != 0, "Music not registered!");
        return musicRecords[_tokenId];
    }

    // Function to Verify Ownership of a Registered Music Piece
    function verifyOwnership(string memory _ipfsHash) public view returns (address) {
        require(registeredMusic[_ipfsHash] != address(0), "No copyright registered for this music!");
        return registeredMusic[_ipfsHash];
    }
}
