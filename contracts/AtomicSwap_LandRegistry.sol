pragma solidity ^0.4.19;

import "./LandRegistry.sol";

contract AtomicSwap_LandRegistry {

    struct AtomicTxn {
        address from;
        address to;
        uint lockPeriod;
        bytes32 id;
    }

    mapping (bytes32 => AtomicTxn) txns;
    LandRegistry LandRegistryContract;

    event landLocked(address to, bytes32 hash, uint expiryTime, bytes32 id);
    event landUnlocked(bytes32 hash);
    event landClaimed(string secret, address from, bytes32 hash);

    function AtomicSwap_LandRegistry(address landRegistryContractAddress) {
        LandRegistryContract = LandRegistry(landRegistryContractAddress);
    }

    function lock(address to, bytes32 hash, uint lockExpiryMinutes, bytes32 id) {
        LandRegistryContract.transferLandFrom(msg.sender, address(this), id);
        txns[hash] = AtomicTxn(msg.sender, to, block.timestamp + (lockExpiryMinutes * 60), id);
        landLocked(to, hash, block.timestamp + (lockExpiryMinutes * 60), id);
    }

    function unlock(bytes32 hash) {
        if(txns[hash].lockPeriod < block.timestamp) {
            LandRegistryContract.transferLand(txns[hash].from, txns[hash].id);
            landUnlocked(hash);
        }
    }

    function claim(string secret) {
        bytes32 hash = sha256(secret);
        LandRegistryContract.transferLand(txns[hash].to, txns[hash].id);
        landClaimed(secret, txns[hash].from, hash);
    }

    function calculateHash(string secret) returns (bytes32 result) {
        return sha256(secret);
    }
}
