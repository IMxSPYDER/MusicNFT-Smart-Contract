# **🎵MusicNFT- Blockchain-Based Music Copyright & NFT Minting**

## 📌 Overview
MusicNFT is a decentralized blockchain-based smart contract that allows new music artists to:Register copyright for their music without expensive legal processes.
Mint NFTs for their music, enabling digital ownership, transfers, and monetization.
Prove ownership transparently with immutable blockchain records.

This contract ensures **secure proof of ownership** and **prevents copyright disputes** by storing metadata and ownership records on the Ethereum blockchain.

## 🚀 Features
✔ **Register Copyright** – Store song details on-chain without minting an NFT.  
✔ **Mint Music NFTs** – Convert music into NFTs, enabling digital trade and monetization.  
✔ **Verify Ownership** – Check registered music ownership via blockchain.  
✔ **Prevent Duplicates** – Ensure a song cannot be registered more than once.  
✔ **Retrieve Metadata** – Fetch song details such as artist, title, genre, and timestamp.  

## 📊 User Flowchart
![image](https://github.com/user-attachments/assets/f151db53-8998-43cb-b450-3f3709bd4be2)


---

## 📜 Smart Contract Code Breakdown

### 1️⃣ SPDX License & Solidity Version
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
```
- SPDX-License-Identifier: MIT → Open-source licensing for the contract.
- pragma solidity ^0.8.19 → Uses Solidity version 0.8.19 or later.

### 2️⃣ Importing OpenZeppelin Contracts
```solidity
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```
- ERC721URIStorage, It Enables NFT minting with metadata storage.
- Ownable, It Assigns ownership control to the contract deployer.

#### 3️⃣ Contract Declaration
```solidity
contract MusicNFT is ERC721URIStorage, Ownable{...}
```
- MusicNFT → The contract name.
- ERC721URIStorage → Inherits NFT capabilities.
- Ownable → Enables contract ownership control.
### 4️⃣ State Variables
```solidity
uint256 private _tokenIdCounter;
```
- _tokenIdCounter → Auto-increments for NFT IDs.
 #### Music Metadata Structure
 ```solidity
struct MusicMetadata {
    string title;
    string artist;
    string genre;
    string ipfsHash;
    uint256 timestamp;
    bool isNFT;
}
```
- title → Song name.
- artist → Music creator.
- genre → Music category.
- ipfsHash → Stores the IPFS link to the song.
- timestamp → Date and time of registration.
- isNFT → true if minted as an NFT, false if only copyright registered.

### 5️⃣ Mappings for Storage
```solidity
mapping(uint256 => MusicMetadata) public musicRecords;
mapping(string => bool) private ipfsHashExists;
mapping(string => address) public registeredMusic;
```
- musicRecords → Stores all registered music metadata.
- ipfsHashExists → Prevents duplicate registrations.
- registeredMusic → Maps IPFS hash to the artist’s Ethereum address.

### 6️⃣ Events
```solidity
event MusicNFTMinted(address indexed artist, uint256 tokenId, string ipfsHash);
event MusicCopyrightRegistered(address indexed artist, string ipfsHash, uint256 timestamp);
```
- MusicNFTMinted → Triggered when a music NFT is created.
- MusicCopyrightRegistered → Triggered when a song is registered without an NFT.

### 7️⃣ Constructo
```solidity
constructor() ERC721("MusicNFT", "MNFT") Ownable(msg.sender) {}
```
- ERC721("MusicNFT", "MNFT") → Sets NFT name MusicNFT and symbol MNFT.
- Ownable(msg.sender) → Assigns contract ownership to the deployer.

### 🎵 NFT Minting Function
```solidity
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
```
- ✔ Checks if the song is already registered.
- ✔ Increments _tokenIdCounter to generate a unique token ID.
- ✔ Mints the NFT and assigns it to the artist’s address.
- ✔ Stores metadata in musicRecords.
- ✔ Marks the song as registered in ipfsHashExists.
- ✔ Emits an event (MusicNFTMinted).

### 📝 Copyright Registration (Without NFT)
```solidity
function registerCopyright(
    string memory _title,
    string memory _artist,
    string memory _genre,
    string memory _ipfsHash
) public {
    require(!ipfsHashExists[_ipfsHash], "Music already registered!");

    _tokenIdCounter++;
    uint256 tokenId = _tokenIdCounter;

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
```
- ✔ Allows music copyright registration without minting an NFT.
- ✔ Stores metadata on-chain, proving ownership.
- ✔ Ensures no duplicate registrations.
- ✔ Emits an event (MusicCopyrightRegistered).

### 🔍 Retrieve Music Metadata
```solidity
function getMusicMetadata(uint256 _tokenId) public view returns (MusicMetadata memory) {
    require(musicRecords[_tokenId].timestamp != 0, "Music not registered!");
    return musicRecords[_tokenId];
}
```
- ✔ Allows users to fetch song details by token ID.
- ✔ Ensures that only registered songs can be queried.

### 🔍 Verify Ownership
```solidity
function verifyOwnership(string memory _ipfsHash) public view returns (address) {
    require(registeredMusic[_ipfsHash] != address(0), "No copyright registered for this music!");
    return registeredMusic[_ipfsHash];
}
```
- ✔ Checks if a music piece is registered on-chain.
- ✔ Returns the wallet address of the owner.
- ✔ Ensures artists can prove ownership easily.
