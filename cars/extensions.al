tableextension 50112 "SalesLineExt" extends "Sales Line"
{
    fields
    {
        field(139; "CarNr"; code[30])
        {
            TableRelation = Cars2.CarNr;

            trigger OnValidate()
            var
                Cars: Record Cars2;
                ErrorMsg: Text;
            begin
                ErrorMsg := 'CarNr already exists in another line';

                if Cars.Get(Rec.CarNr) then begin

                    if CheckIfCarExists(Rec.CarNr) then begin
                        Error('%1', ErrorMsg);
                    end;

                    Rec.Validate("Unit Price", Cars.Price);

                    // Message(format(TestProcedure()));
                end
            end;
        }
    }

    procedure CheckIfCarExists(NrToCheck: Code[30]): Boolean
    begin
        // Rec.Reset(); ?
        Rec.SetRange(CarNr, NrToCheck);
        if Rec.Count > 0 then begin
            exit(true);
        end;
        exit(false);
    end;

    procedure TestProcedure(): Integer
    begin
        Rec.Reset();
        Rec.SetRange("Unit Price", 5000, 10000);
        Rec.SetRange(Description, '%1', 'ATHENS Desk');
        exit(Rec.Count)

    end;

    procedure TestProcedure2(): Boolean
    var
        D1, D2, D3 : Date;
    begin
        D1 := 20220505D;
        D2 := 20220606D;
        D3 := 20220707D;

        Rec.SetFilter("Shipment Date", '5/5/22..6/6/22'); // bad
        Rec.SetFilter("Shipment Date", format(D1)); // bad
        Rec.SetFilter("Shipment Date", '%1|%2..%3', D1, D2, D3); // good
        Rec.SetRange("Shipment Date", D1, D3); // best
    end;
}

pageextension 50111 "Sales Order Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Car"; Rec.CarNr)
            {
                ApplicationArea = All;
                Lookup = true;
            }
        }
    }
}

// Rec.Validate
// Rec.SetRange
// Rec.SetFilter
// Rec.Modify
// Rec.Insert
// Rec.FindFirst
// Rec.FindSet