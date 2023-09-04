codeunit 50105 RewardsInstallCode
{
    // Set the codeunit to be an install codeunit. 
    Subtype = Install;

    // This trigger includes code for company-related operations. 
    trigger OnInstallAppPerCompany();
    var
        Reward: Record Reward;
    begin
        // If the "Reward" table is empty, insert the default rewards.
        if Reward.IsEmpty() then begin
            InsertDefaultRewards();
        end;
    end;

    // Create and insert a reward level in the "Reward" table.
    procedure InsertRewardLevel(ID: Code[30]; Description: Text[250]; Discount: Decimal; MinimumP: Decimal);
    var
        Reward: Record Reward;
    begin
        Reward.Init();
        Reward."Reward ID" := ID;
        Reward.Description := Description;
        Reward."Discount Percentage" := Discount;
        Reward."Minimum Purchase" := MinimumP;
        Reward.Insert();
    end;

    // Insert the GOLD, SILVER, BRONZE reward levels
    procedure InsertDefaultRewards();
    begin
        InsertRewardLevel('GOLD', 'Gold Level', 20, 50);
        InsertRewardLevel('SILVER', 'Silver Level', 10, 25);
        InsertRewardLevel('BRONZE', 'Bronze Level', 5, 5);
    end;
}

codeunit 50106 RewardsUpgradeCode
{
    // An upgrade codeunit includes AL methods for synchronizing changes to a table definition 
    // in an application with the business data table in SQL Server and migrating existing 
    // data.
    Subtype = Upgrade;

    // "OnUpgradePerCompany" trigger is used to perform the actual upgrade.
    trigger OnUpgradePerCompany();
    var
        Reward: Record Reward;

        // "ModuleInfo" is the current executing module. 
        Module: ModuleInfo;
    begin
        // Get information about the current module.
        NavApp.GetCurrentModuleInfo(Module);

        // If the code needs to be upgraded, the BRONZE reward level will be changed into the
        // ALUMINUM reward level.
        if Module.DataVersion.Major = 1 then begin
            Reward.Get('BRONZE');
            Reward.Rename('ALUMINUM');
            Reward.Description := 'Aluminum Level';
            Reward.Modify();
        end;
    end;
}