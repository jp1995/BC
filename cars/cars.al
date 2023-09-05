table 50110 Cars2
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Auto Nr"; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }

        field(2; Tootja; Text[250])
        {
            NotBlank = true;
        }

        field(3; "Mudel"; Text[250])
        {
            NotBlank = true;
        }

        field(4; "Reg kuu"; Integer)
        {
            MinValue = 1;
            MaxValue = 12;
            NotBlank = true;
        }

        field(5; "Reg aasta"; Integer)
        {
            MinValue = 1880;
            MaxValue = 2100;
            NotBlank = true;
        }

        field(6; "Läbisõit"; Decimal)
        {
            MinValue = 0;
            DecimalPlaces = 1;
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; "Auto Nr")
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
                field("Auto Nr"; Rec."Auto Nr")
                {
                    // ApplicationArea sets the application area that 
                    // applies to the page field and action controls. 
                    // Setting the property to All means that the control 
                    // will always appear in the user interface.
                    ApplicationArea = All;
                }
                field("Tootja"; Rec.Tootja)
                {
                    ApplicationArea = All;
                }
                field("Mudel"; Rec.Mudel)
                {
                    ApplicationArea = All;
                }
                field("Reg kuu"; Rec."Reg kuu")
                {
                    ApplicationArea = All;
                }
                field("Reg aasta"; Rec."Reg aasta")
                {
                    ApplicationArea = All;
                }
                field("Läbisõit"; Rec."Läbisõit")
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
                field("Auto Nr"; Rec."Auto Nr")
                {
                    ApplicationArea = All;
                }
                field("Tootja"; Rec.Tootja)
                {
                    ApplicationArea = All;
                }
                field("Mudel"; Rec.Mudel)
                {
                    ApplicationArea = All;
                }
                field("Reg kuu"; Rec."Reg kuu")
                {
                    ApplicationArea = All;
                }
                field("Reg aasta"; Rec."Reg aasta")
                {
                    ApplicationArea = All;
                }
                field("Läbisõit"; Rec."Läbisõit")
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
        Cars.CalcSums("Reg aasta");
        exit(Cars."Reg aasta" / Cars.Count);
    end;

    procedure FormatAvgAge(AvgAge: Decimal): Integer
    begin
        exit(Round(AvgAge, 1));
    end;
}