page 50104 "Capital Expenditures API"
{
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'test';
    APIPublisher = 'Johan';

    EntityName = 'ce_request';
    EntitySetName = 'ce_requests';

    SourceTable = "Capital Expenditures";
    ODataKeyFields = SystemId;

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(sysid; Rec.SystemId)
                {
                    Caption = 'sysid';
                    Editable = false;
                }
                field(ID; Rec.ID)
                {
                    Caption = 'ID';
                }
                field(Company; Rec.Company)
                {
                    Caption = 'Company';
                }
                field(Requester; Rec.Requester)
                {
                }
                field("BudgetedExpenditure"; Rec."Budgeted Expenditure")
                {
                }
                field("TotalPurchaseCost"; Rec."Total Purchase Cost")
                {
                }
                field("BriefDescription"; Rec."Brief Description")
                {
                }
                field("CompetitiveQuotesReceived"; Rec."Competitive Quotes Received")
                {
                }
                field("PlannedPurchaseDate"; Rec."Planned Purchase Date")
                {
                }
                field(Project; Rec.Project)
                {
                }
                field("ProjectStartDate"; Rec."Project Start Date")
                {
                }
                field("ProjectEndDate"; Rec."Project End Date")
                {
                }
            }
        }
    }
}