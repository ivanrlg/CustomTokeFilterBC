codeunit 60100 "My Filter Tokens"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', true, true)]
    local procedure TopSalesInvoicesAmount(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
        a: report "Customer - Top 10 List";
    begin
        if StrLen(TextToken) < 3 then
            exit;

        if StrPos(UpperCase('TopInv'), UpperCase(TextToken)) = 0 then
            exit;

        Handled := true;

        SalesInvoiceHeader.SetCurrentKey("Amount");
        SalesInvoiceHeader.SetAscending("Amount", false);
        if SalesInvoiceHeader.FindSet() then begin
            repeat
                Counter += 1;
                TextFilter += '|' + SalesInvoiceHeader."No.";
            until ((SalesInvoiceHeader.Next() = 0) or (Counter = 5));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', true, true)]
    local procedure LastFivePostedInvoice(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
        a: report "Customer - Top 10 List";
    begin
        if StrLen(TextToken) < 3 then
            exit;

        if StrPos(UpperCase('LastFive'), UpperCase(TextToken)) = 0 then
            exit;

        Handled := true;

        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.SetAscending("Posting Date", false);
        if SalesInvoiceHeader.FindSet() then begin
            repeat
                Counter += 1;
                TextFilter += '|' + SalesInvoiceHeader."No.";
            until ((SalesInvoiceHeader.Next() = 0) or (Counter = 5));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveDateFilterToken', '', false, false)]
    local procedure OnResolveDateFilterToken(DateToken: Text; var FromDate: Date; var Handled: Boolean; var ToDate: Date)
    begin
        case UpperCase(DateToken) of
            'YESTERDAY', 'YD':
                begin
                    FromDate := CalcDate('<-1D>', Today);
                    ToDate := FromDate;
                    Handled := true;
                end;
            'TOMORROW', 'TO':
                begin
                    FromDate := CalcDate('<-1D>', Today);
                    ToDate := FromDate;
                    Handled := true;
                end;
            'THISMONTH', 'TM':
                begin
                    FromDate := CalcDate('<CM - 1M + 1D>', Today);
                    ToDate := CalcDate('<CM>', Today);
                    Handled := true;
                end;
            'PREVMONTH', 'PM':
                begin
                    FromDate := CalcDate('<CM - 2M + 1D>', Today);
                    ToDate := CalcDate('<CM - 1M>', Today);
                    Handled := true;
                end;
            'THISYEAR', 'TY':
                begin
                    FromDate := CALCDATE('<-CY>', Today);
                    ToDate := CALCDATE('<CY>', Today);
                    Handled := true;
                end;
            'PREVYEAR', 'PY':
                begin
                    FromDate := CALCDATE('<-CY - 1Y>', Today);
                    ToDate := CALCDATE('<CY - 1Y>', Today);
                    Handled := true;
                end;
        end;
    end;

}