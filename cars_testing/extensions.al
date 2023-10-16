tableextension 50100 "CarsExt" extends "Cars2"
{
    fields
    {
        field(8; "Owner"; Text[100])
        {

        }
    }
}

pageextension 50101 "CarsListExt" extends "Car List"
{

    layout
    {
        addafter(Price)
        {
            field("Owner"; Rec.Owner)
            {
                ApplicationArea = All;

            }
        }
    }

    // trigger OnOpenPage()
    // var
    //     TestUnit: Codeunit TestOwnerInsertion;
    // begin
    //     TestUnit.InsertRecord();
    // end;
}

codeunit 50103 TestOwnerInsertion
{
    Subtype = Test;

    [Normal]
    procedure InsertRecord()
    var
        Cars: Record "Cars2";
    begin
        Cars.SetRange(CarNr, 'ABC 123');
        if Cars.FindFirst() then begin
            Cars."Owner" := 'Owner1';
            Cars.Modify();
        end;
    end;

    [Test]
    procedure AssertRecord()
    var
        Cars: Record "Cars2";
    begin
    end;

}