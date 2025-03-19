module MyModule::CommunityDAO {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a community project.
    struct CommunityProject has store, key {
        total_funds: u64,
        goal: u64,
    }

    /// Function to create a new community project with a funding goal.
    public fun create_project(owner: &signer, goal: u64) {
        let project = CommunityProject {
            total_funds: 0,
            goal,
        };
        move_to(owner, project);
    }

    /// Function to fund a community project.
    public fun fund_project(contributor: &signer, project_owner: address, amount: u64) acquires CommunityProject {
        let project = borrow_global_mut<CommunityProject>(project_owner);
        let contribution = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(project_owner, contribution);
        project.total_funds = project.total_funds + amount;
    }
}
