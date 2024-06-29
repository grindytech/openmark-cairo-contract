use starknet::ContractAddress;
use core::pedersen::PedersenTrait;
use core::hash::{HashStateTrait, HashStateExTrait};

pub const ETH_CONTRACT_ADDRESS: felt252 =
    0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7;

pub const STARKNET_DOMAIN_TYPE_HASH: felt252 =
    selector!("StarkNetDomain(name:felt,version:felt,chainId:felt)");

#[derive(Drop, Copy, Hash)]
pub struct StarknetDomain {
    name: felt252,
    version: felt252,
    chain_id: felt252,
}

pub const ORDER_STRUCT_TYPE_HASH: felt252 =
    selector!(
        "Order(nftContract:ContractAddress,tokenId:u64,price:u256,salt:felt252,expiry:u256,option:u32)"
    );

#[derive(Copy, Drop, Serde, Hash)]
pub struct Order {
    nftContract: ContractAddress,
    tokenId: u64,
    price: u256,
    salt: felt252,
    expiry: u256,
    option: OrderType,
}

#[derive(Copy, Drop, Serde, Hash)]
pub enum OrderType {
    Buy,
    Offer,
}

trait IStructHash<T> {
    fn hash_struct(self: @T) -> felt252;
}

impl StructHashStarknetDomain of IStructHash<StarknetDomain> {
    fn hash_struct(self: @StarknetDomain) -> felt252 {
        let mut state = PedersenTrait::new(0);
        state = state.update_with(STARKNET_DOMAIN_TYPE_HASH);
        state = state.update_with(*self);
        state = state.update_with(4);
        state.finalize()
    }
}

impl StructHashSimpleStruct of IStructHash<Order> {
    fn hash_struct(self: @Order) -> felt252 {
        let mut state = PedersenTrait::new(0);
        state = state.update_with(ORDER_STRUCT_TYPE_HASH);
        state = state.update_with(*self);
        state = state.update_with(3);
        state.finalize()
    }
}


#[test]
#[available_gas(2000000)]
fn test_valid_hash() {
    // This value was computed using StarknetJS
    let message_hash = 0x1e739b39f83b38f182edaed69f730f18eff802d3ef44be91c3733cdcab6de2f;
    let simple_struct = SimpleStruct { some_felt252: 712, some_u128: 42 };
    set_caller_address(contract_address_const::<420>());
    assert(simple_struct.get_message_hash() == message_hash, 'Hash should be valid');
}