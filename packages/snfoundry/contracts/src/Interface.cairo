use starknet::ContractAddress;
use contracts::Primitives::Order;

#[starknet::interface]
pub trait IOpenMark<TState> {
    // fn acceptOffer(self: @TState);
    // fn cancelOrder(self: @TState);

    fn buy(self: @TState, order: Order, signature: Span<felt252>);

    fn verifyOrder(
        self: @TState, order: Order, signer: felt252, signature: Span<felt252>
    ) -> bool;
}


#[starknet::interface]
pub trait IOffchainMessageHash<T> {
    fn get_message_hash(self: @T, order: Order, signer: felt252) -> felt252;
}
