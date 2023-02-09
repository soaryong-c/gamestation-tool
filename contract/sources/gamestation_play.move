module gamestation::gamestation_play {
    use std::signer;
    use aptos_std::table::{Self, Table};

    struct PlayTable has key {
        plays: Table<u64, u64>,
    }

    public entry fun set_score(account: signer, game_id: u64, score: u64)
    acquires PlayTable {
        let account_addr = signer::address_of(&account);
        if (!exists<PlayTable>(account_addr)) {
            move_to(&account, PlayTable {
                plays: table::new(),
            })
        };
        let play_table = borrow_global_mut<PlayTable>(account_addr);
        table::upsert(&mut play_table.plays, game_id, score);
    }
}
