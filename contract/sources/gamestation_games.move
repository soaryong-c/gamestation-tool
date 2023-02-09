module gamestation::gamestation_games {
    use aptos_framework::event;
    use aptos_framework::resource_account;
    use std::string::{Self, String};
    use std::signer;
    use aptos_framework::account;
    use aptos_std::table::{Self, Table};

    const E_NOT_INITIALIZED: u64 = 1;
    const DOESNT_EXIST: u64 = 2;
    const IS_AUDITED: u64 = 3;

    struct GameList has key {
        games: Table<u64, Game>,
        resource_signer_cap: account::SignerCapability,
        set_game_event: event::EventHandle<Game>,
        game_counter: u64
    }

    struct Game has store, drop, copy {
        game_id: u64,
        address:address,
        title: String,
        description: String,
        image: String,
        url: String,
        audit: bool,
    }

    fun init_module(account: &signer) {
        let resource_signer_cap = resource_account::retrieve_resource_account_cap(account, @source_addr);
        let games_holder = GameList {
            games: table::new(),
            resource_signer_cap,
            set_game_event: account::new_event_handle<Game>(account),
            game_counter: 0
        };
        move_to(account, games_holder);
    }

    public entry fun create_game(account: &signer, title: String, description: String, image:String, url: String) acquires GameList {
        let signer_address = signer::address_of(account);
        let game_list = borrow_global_mut<GameList>(@gamestation);
        let counter = game_list.game_counter + 1;
        let new_game = Game {
            game_id: counter,
            address: signer_address,
            title,
            description,
            image,
            url,
            audit: false
        };
        table::upsert(&mut game_list.games, counter, new_game);
        game_list.game_counter = counter;
        event::emit_event<Game>(
            &mut borrow_global_mut<GameList>(@gamestation).set_game_event,
            new_game,
        );
    }

    public entry fun audit_game(game_id: u64) acquires GameList {
        let game_list = borrow_global_mut<GameList>(@gamestation);
        assert!(table::contains(&game_list.games, game_id), DOESNT_EXIST);
        let game = table::borrow_mut(&mut game_list.games, game_id);
        assert!(game.audit == false, IS_AUDITED);
        game.audit = true;
    }
}