// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Shop {
	address private owner;
	
	struct SoldItem {
		uint quantity;
		uint blocktime;
	}
	
	mapping(uint => uint) public items;
	mapping(address => mapping(uint => SoldItem)) public clientPurchases;
	mapping(uint => address) public clients;
	uint totalClients = 0;

	constructor() {
		owner = msg.sender;
	}

	function addItem(uint _id, uint _quiantity) public {
		require(msg.sender == owner, "Not owner");
		items[_id] += _quiantity;
	}

	function listItems(uint _id) public view returns(uint){
		return items[_id];
	}

	function buyItem(uint _id) public {
		require(msg.sender != owner, "Not client");
		require(clientPurchases[msg.sender][_id].quantity == 0, "Client already has this product");
		require(items[_id] > 0, "No items to sell");
		clientPurchases[msg.sender][_id].quantity ++;
		clientPurchases[msg.sender][_id].blocktime = block.number;
		items[_id] --;
		clients[totalClients] = msg.sender;
		totalClients ++;
	}

	function returnItem(uint _id) public {
		require(msg.sender != owner, "Not client");
		require(clientPurchases[msg.sender][_id].quantity > 0, "No items to return");
		if(block.number - clientPurchases[msg.sender][_id].blocktime <= 100) {
			delete clientPurchases[msg.sender][_id];
			items[_id] ++;
		}
	}
	
	function listClientItems(address _client, uint _id) public view returns(uint){
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