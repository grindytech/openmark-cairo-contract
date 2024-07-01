use starknet::ContractAddress;
use contracts::Primitives::Order;

#[starknet::interface]
pub trait IOpenMark<TState> {
    // fn buy(self: @TState);
    // fn acceptOffer(self: @TState);
    // fn cancelOrder(self: @TState);

    fn verifyOrder(self: @TState, order: Order, signature: ByteArray) -> ContractAddress;
}


#[starknet::interface]
pub trait IOffchainMessageHash<T> {
    fn get_message_hash(self: @T, value: Order) -> felt252;
}