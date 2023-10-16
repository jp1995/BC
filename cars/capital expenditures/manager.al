enum 50101 Limits
{
    value(0; "0") { }
    value(1; "2500") { }
    value(2; "25000") { }
    value(3; "250000") { }
    value(4; "Above") { }
}

table 50102 Managers
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            NotBlank = true;
        }
        field(2; "User"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(3; "Company"; Text[250])
        {
            TableRelation = Company."Display Name";
            ValidateTableRelation = false;
        }
        field(4; "Approval Limit"; Enum Limits)
        {
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }
}

page 50102 ManagersCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Managers;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field("Approval Limit"; Rec."Approval Limit")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}


page 50103 Managers
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = Managers;
    CardPageId = ManagersCard;

    layout
    {
        area(Content)
        {
            repeater("Managers")
            {
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field("Approval Limit"; Rec."Approval Limit")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}