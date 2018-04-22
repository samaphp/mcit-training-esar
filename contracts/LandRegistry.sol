pragma solidity ^0.4.19;

contract LandRegistry {

    struct Land {
        address owner;
    }
    
    mapping (bytes32 => Land) land_records;
    mapping (address => mapping (address => bytes32)) allowed;
    address owner;
    
    function LandRegistry() {
        owner = msg.sender;
    }
    
    function issueLand(address to, bytes32 id) {
        if(msg.sender == owner) {
            land_records[id].owner = to;
        } 
    }
    
    function transferLand(address to, bytes32 id) {
        if(land_records[id].owner == msg.sender) {
            land_records[id].owner = to;
        }
    }
    
    function getOwner(bytes32 id) view returns (address owner) {
        return land_records[id].owner;
    }
    
    function approve(address transferer, bytes32 id) {
        allowed[transferer][msg.sender] = id;
    }
    
    function transferLandFrom(address from, address to, bytes32 id) {
        if(allowed[msg.sender][from] == id && land_records[id].owner == from) {
            land_records[id].owner = to;
        }
    }
}