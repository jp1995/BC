enum 50100 Status
{
    value(0; Open) { }
    value(1; Requested) { }
    value(2; Rejected) { }
    value(3; Approved) { }
}

table 50100 "Capital Expenditures"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ID"; Integer)
        {
            NotBlank = true;
            AutoIncrement = true;
        }

        field(2; Company; Text[250])
        {
            TableRelation = Company."Display Name";
            ValidateTableRelation = false;
        }

        field(3; "Requester"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }

        field(4; "Status"; Enum Status)
        {
        }

        field(5; "Budgeted Expenditure"; Boolean)
        {
        }

        field(6; "Total Purchase Cost"; Decimal)
        {
            MinValue = 0;
            DecimalPlaces = 2;
            NotBlank = true;
        }

        field(7; "Brief Description"; Text[256])
        {
        }

        field(8; "Competitive Quotes Received"; Boolean)
        {
        }

        field(9; "Planned Purchase Date"; Date)
        {
        }

        field(10; Project; Boolean)
        {
        }

        field(11; "Project Start Date"; Date)
        {
        }

        field(12; "Project End Date"; Date)
        {
        }

        field(13; Attachments; Code[30])
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

page 50101 "Capital Expenditures Card"
{
    PageType = Card;
    UsageCategory = Tasks;
    SourceTable = "Capital Expenditures";

    layout
    {
        area(Content)
        {
            group("Status ")
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }

            group("Capital Expenditures")
            {
                Editable = EditLock;

                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    Lookup = true;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Budgeted Expenditure"; Rec."Budgeted Expenditure")
                {
                    ApplicationArea = All;
                }
                field("Total Purchase Cost"; Rec."Total Purchase Cost")
                {
                    ApplicationArea = All;
                }
                field("Brief Description"; Rec."Brief Description")
                {
                    ApplicationArea = All;
                }
                field("Competitive Quotes Received"; Rec."Competitive Quotes Received")
                {
                    ApplicationArea = All;
                }
                field("Planned Purchase Date"; Rec."Planned Purchase Date")
                {
                    ApplicationArea = All;
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = All;
                }
                field("Project Start Date"; Rec."Project Start Date")
                {
                    ApplicationArea = All;
                }
                field("Project End Date"; Rec."Project End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Capital Expenditures"),
                              "No." = FIELD("Attachments");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Request Approval")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status <> Status::Open then begin
                        Error('Item status is not Open.');
                    end;

                    Rec.Validate(Status, Status::Requested);
                    ValidateMandatory();
                    Rec.Modify(true);
                    EditLock := false;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Managers: Record Managers;
        Limit: Integer;
        isManager: Boolean;
    begin
        StatusLock := false;
        if Rec.Status = Status::Open then EditLock := true;
        Limit := GetApprovalLimit();
        isManager := CanManagerEdit(Rec."Total Purchase Cost", Limit);

        if isManager then begin
            EditLock := true;
            StatusLock := true;
        end;
    end;

    procedure GetApprovalLimit(): Integer
    var
        Managers: Record "Managers";
        Limit: Integer;
        LimitValue: Integer;
    begin
        Managers.SetLoadFields(User);
        Managers.SetRange(User, Database.UserID());
        //Message('Found %1 user', Managers.Count); // Should always be 1

        Managers.Next(); // Why?

        if Managers.Count = 1 then begin
            //Message('Current user %1 is a manager with approval limit of %2$', Managers.User, Managers."Approval Limit");
            LimitValue := ConvertLimit(Managers."Approval Limit");
            exit(LimitValue);
        end
        else begin
            Limit := 0;
            exit(Limit);
        end;
    end;

    procedure ConvertLimit(Limit: Enum Limits): Integer
    var
        LimitValue: Integer;
        LimitText: Text;
        EvalBool: Boolean;
    begin
        LimitText := Limit.Names.Get(Limit.Ordinals.IndexOf(Limit.AsInteger()));
        EvalBool := Evaluate(LimitValue, LimitText);
        exit(LimitValue);
    end;

    procedure CanManagerEdit(Cost: Decimal; Limit: Integer): Boolean
    var
    begin
        if (Rec."Total Purchase Cost" <> 0) AND (Limit >= Rec."Total Purchase Cost") then begin
            exit(true);
        end;
    end;

    procedure ValidateMandatory()
    begin
        if Rec.Requester = '' then begin
            Error('"Requester" field must not be empty.');
        end;
        // if Rec.Company = '' then begin
        //     Error('"Company" field must not be empty.');
        // end;
        if Rec."Total Purchase Cost" = 0 then begin
            Error('"Total Purchase Cost" field must not be empty.');
        end;
        if Rec."Brief Description" = '' then begin
            Error('"Description" field must not be empty.');
        end;
        if Rec."Planned Purchase Date" = 0D then begin
            Error('"Planned Purchase Date" field must not be empty.');
        end;
        if Rec.Project = true then begin
            if Rec."Project Start Date" = 0D then begin
                Error('"Project Start Date" field must not be empty.');
            end;
            if Rec."Project End Date" = 0D then begin
                Error('"Project End Date" field must not be empty.');
            end;
        end;
    end;

    var
        EditLock: Boolean;
        StatusLock: Boolean;

}

page 50100 "Capital Expenditures"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Capital Expenditures";
    CardPageId = "Capital Expenditures Card";

    layout
    {
        area(Content)
        {
            repeater("Capital Expenditures")
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Lookup = true;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Budgeted Expenditure"; Rec."Budgeted Expenditure")
                {
                    ApplicationArea = All;
                }
                field("Total Purchase Cost"; Rec."Total Purchase Cost")
                {
                    ApplicationArea = All;
                }
                field("Brief Description"; Rec."Brief Description")
                {
                    ApplicationArea = All;
                }
                field("Competitive Quotes Received"; Rec."Competitive Quotes Received")
                {
                    ApplicationArea = All;
                }
                field("Planned Purchase Date"; Rec."Planned Purchase Date")
                {
                    ApplicationArea = All;
                }
                field(Project; Rec.Project)
                {
                    ApplicationArea = All;
                }
                field("Project Start Date"; Rec."Project Start Date")
                {
                    ApplicationArea = All;
                }
                field("Project End Date"; Rec."Project End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}