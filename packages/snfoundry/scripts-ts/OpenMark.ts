import { typedData } from "starknet";

const types = {
  StarkNetDomain: [
    { name: "name", type: "felt" },
    { name: "version", type: "felt" },
    { name: "chainId", type: "felt" },
  ],
  Order: [
    { name: "nftContract", type: "felt" },
    { name: "tokenId", type: "u128" },
    { name: "price", type: "u256" },
    { name: "salt", type: "felt" },
    { name: "expiry", type: "u256" },
    { name: "option", type: "u32" },
  ],
};

interface Order {
  nftContract: string,
  tokenId: string,
  price: string,
  salt: string,
  expiry: string,
  option: string,
}

function getDomain(chainId: string): typedData.StarkNetDomain {
  return {
    name: "dappName",
    version: "1",
    chainId,
  };
}

function getTypedDataHash(myStruct: Order, chainId: string, owner: bigint): string {
  return typedData.getMessageHash(getTypedData(myStruct, chainId), owner);
}

// Needed to reproduce the same structure as:
// https://github.com/0xs34n/starknet.js/blob/1a63522ef71eed2ff70f82a886e503adc32d4df9/__mocks__/typedDataStructArrayExample.json
function getTypedData(myStruct: Order, chainId: string): typedData.TypedData {
  return {
    types,
    primaryType: "Order",
    domain: getDomain(chainId),
    message: { ...myStruct },
  };
}

const order: Order = {
  nftContract: "1",
  tokenId: "2",
  price: "3",
  salt: "4",
  expiry: "5",
  option: "0",
};

console.log(`test test_valid_hash ${getTypedDataHash(order, "393402133025997798000961", 420n)};`);
