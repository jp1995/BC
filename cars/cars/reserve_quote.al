// pageextension 50100 ReserveSalesQuoteLine extends "Sales Quote Subform"
// {
//     actions
//     {
//         addlast("F&unctions")
//         {
//             action(Reserve)
//             {
//                 ApplicationArea = All;
//                 // RunObject = codeunit "Sales Line-Reserve";
//                 // RunPageOnRec = true;
//                 trigger OnAction()
//                 begin
//                     Rec.ShowReservation();
//                 end;
//             }
//         }
//     }
// }

pageextension 50100 "Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Reserved Quantity"; Rec."Reserved Quantity")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(Reserve)
            {
                ApplicationArea = Reservation;
                Caption = '&Reserve';
                Ellipsis = true;
                Image = Reserve;
                Enabled = Rec.Type = Rec.Type::Item;
                ToolTip = 'Reserve the quantity of the selected item that is required on the document line from which you opened this page. This action is available only for lines that contain an item.';

                trigger OnAction()
                begin
                    Rec.Find();
                    Rec.ShowReservation();
                end;
            }
        }
    }
}

codeunit 50100 "Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnAfterCheckSourceTypeSubtype', '', false, false)]
    local procedure AllowSalesQuoteToBeReserved(var ReservationEntry: Record "Reservation Entry"; var IsError: Boolean)
    begin
        if ReservationEntry."Source Type" = Database::"Sales Line" then begin
            if ReservationEntry."Source Subtype" = 0 then
                IsError := false;
        end;
    end;
}