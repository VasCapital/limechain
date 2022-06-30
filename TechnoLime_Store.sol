// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

//creating the Store contract
contract Store {
	address private owner;
	
	struct SoldProduct {
		uint quantity;
		uint blocktime;
	}
	
	mapping(uint => uint) public Products;
	mapping(address => mapping(uint => SoldProduct)) public clientPurchases;
	mapping(uint => address) public clients;
	uint totalClients = 0;

//setting up the construtor and the MAIN functions bellow
	constructor() {
		owner = msg.sender;
	}

	function addProduct(uint _id, uint _quiantity) public {
		require(msg.sender == owner, "Not the owner!");
		Products[_id] += _quiantity;
	}

	function listProducts(uint _id) public view returns(uint){
		return Products[_id];
	}

	function buyProduct(uint _id) public {
		require(msg.sender != owner, "Non existing client");
		require(clientPurchases[msg.sender][_id].quantity == 0, "Client dublicate of products");
		require(Products[_id] > 0, "Nothing to sell");
		clientPurchases[msg.sender][_id].quantity ++;
		clientPurchases[msg.sender][_id].blocktime = block.number;
		Products[_id] --;
		clients[totalClients] = msg.sender;
		totalClients ++;
	}

	function returnProduct(uint _id) public {
		require(msg.sender != owner, "Non existing client");
		require(clientPurchases[msg.sender][_id].quantity > 0, "Nothing to return");
        //enabling the return of the products if they are not satisfied (within a certain period in blocktime: 100 blocks).
		if(block.number - clientPurchases[msg.sender][_id].blocktime <= 100) { 
			delete clientPurchases[msg.sender][_id];
			Products[_id] ++;
		}
	}
	
	function listClientProducts(address _client, uint _id) public view returns(uint){
		return clientPurchases[_client][_id].quantity;
	}

	function listClients() public view returns(address[] memory) {
		address[] memory clientsInStore = new address[](totalClients);
		for(uint i; i < totalClients; i++) {
			clientsInStore[i] = clients[i];
		}

		return clientsInStore;
	}
}