module gamestation::gamestation_profile {
    use std::signer;
    use std::string;

    struct Profile has key {
        nickname: string::String,
        image: string::String,
    }

    const ENO_MESSAGE: u64 = 0;

    public entry fun set_profile(account: signer, nickname: string::String, image: string::String)
    acquires Profile {
        let account_addr = signer::address_of(&account);
        if (!exists<Profile>(account_addr)) {
            move_to(&account, Profile {
                nickname,
                image,
            })
        } else {
            let old_profile_holder = borrow_global_mut<Profile>(account_addr);
            old_profile_holder.nickname = nickname;
            old_profile_holder.image = image;
        }
    }
}
