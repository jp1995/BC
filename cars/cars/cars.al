table 50110 Cars2
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "CarNr"; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(2; Manufacturer; Text[250])
        {
            NotBlank = true;
        }

        field(3; "Make"; Text[250])
        {
            NotBlank = true;
        }

        field(4; "RegMonth"; Integer)
        {
            MinValue = 1;
            MaxValue = 12;
            NotBlank = true;
        }

        field(5; "RegYear"; Integer)
        {
            MinValue = 1880;
            MaxValue = 2100;
            NotBlank = true;
        }

        field(6; "Mileage"; Decimal)
        {
            MinValue = 0;
            DecimalPlaces = 1;
            NotBlank = true;
        }

        field(7; "Price"; Decimal)
        {
            MinValue = 0;
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; "CarNr")
        {
            Clustered = true;
        }
    }


}

page 50106 "Car Card"
{
    PageType = Card;
    // The page will be part of the "Tasks" group of search results ?
    UsageCategory = Tasks;
    SourceTable = Cars2;

    layout
    {
        area(content)
        {
            group(Car)
            {
                field("CarNr"; Rec.CarNr)
                {
                    // ApplicationArea sets the application area that 
                    // applies to the page field and action controls. 
                    // Setting the property to All means that the control 
                    // will always appear in the user interface.
                    ApplicationArea = All;
                }
                field("Manufacturer"; Rec.Manufacturer)
                {
                    ApplicationArea = All;
                }
                field("Make"; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field("Registration Month"; Rec.RegMonth)
                {
                    ApplicationArea = All;
                }
                field("Registration Year"; Rec.RegYear)
                {
                    ApplicationArea = All;
                }
                field("Mileage"; Rec.Mileage)
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec.Price)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

page 50107 "Car List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Cars2;
    CardPageId = "Car Card";

    layout
    {
        area(content)
        {
            repeater(Cars)
            {
                field("CarNr"; Rec.CarNr)
                {
                    ApplicationArea = All;
                }
                field("Manufacturer"; Rec.Manufacturer)
                {
                    ApplicationArea = All;
                }
                field("Make"; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field("Registration Month"; Rec.RegMonth)
                {
                    ApplicationArea = All;
                }
                field("Registration Year"; Rec.RegYear)
                {
                    ApplicationArea = All;
                }
                field("Mileage"; Rec.Mileage)
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec.Price)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Keskmine vanus")
            {
                ApplicationArea = All;
                //RunObject = codeunit "AvgAge";

                trigger OnAction()
                var
                    Cars: Record Cars2;
                    AvgAge: Codeunit AvgAge;
                    AvgAgeDec: Decimal;
                    FmtdAvgAge: Integer;
                    MessageText: Label 'Average age is: %1';
                begin
                    CurrPage.SetSelectionFilter(Cars);
                    //codeunit.Run(50109, Cars);
                    //Clear(Rec);
                    AvgAgeDec := AvgAge.CalcAvgAge(Cars);
                    FmtdAvgAge := AvgAge.FormatAvgAge(AvgAgeDec);
                    Message(MessageText, FmtdAvgAge);
                end;

            }
        }
    }
}


codeunit 50109 AvgAge
{

    TableNo = "Cars2";

    trigger OnRun()
    var
    // CarCount: Integer;
    // SumOfYears: Integer;
    // AvgRegYear: Decimal;
    // AvgCarAge: Integer;
    // CurrentYear: Integer;
    // MessageText: Text;
    begin
        // CarCount := Rec.Count();
        // CurrentYear := System.Date2DMY(Today, 3);

        // // Rec.CalcSums("Reg aasta")

        // if Rec.FindFirst() then
        //     repeat
        //         SumOfYears += Rec."Reg aasta";
        //     until Rec.Next() = 0;

        // if CarCount > 0 then
        //     AvgRegYear := SumOfYears / CarCount;

        // AvgRegYear := Round(AvgRegYear, 1);
        // AvgCarAge := CurrentYear - AvgRegYear;

        // MessageText := 'Valitud autode keskmine vanus: %1 aastat\Keskmine registreerimise aasta: %2';
        // MessageText := StrSubstNo(MessageText, AvgCarAge, AvgRegYear);

        // Message(MessageText);
    end;

    procedure CalcAvgAge(var Cars: Record Cars2): Decimal
    begin
        Cars.CalcSums(RegYear);
        exit(Cars.RegYear / Cars.Count);
    end;

    procedure FormatAvgAge(AvgAge: Decimal): Integer
    begin
        exit(Round(AvgAge, 1));
    end;
}