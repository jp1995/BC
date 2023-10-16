reportextension 50120 SalesOrderReportExt extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Line)
        {
            column(CarNr; Line.CarNr)
            { }

            column(CarNr_Lbl; FieldCaption(CarNr))
            { }
        }

        // addafter(Line)
        // {
        //     dataitem(Line2; "Sales Line")
        //     {
        //     }
        // }

        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Line.CarNr <> '' then CurrReport.Skip();
            end;
        }
    }
}