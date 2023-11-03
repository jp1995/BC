permissionset 50100 APIPermissionSet
{
    Assignable = true;
    Permissions = tabledata "Capital Expenditures" = RIMD,
        tabledata Cars2 = RIMD,
        tabledata Managers = RIMD,
        table "Capital Expenditures" = X,
        table Cars2 = X,
        table Managers = X,
        codeunit AvgAge = X,
        codeunit Subscribers = X,
        page "Capital Expenditures" = X,
        page "Capital Expenditures API" = X,
        page "Capital Expenditures Card" = X,
        page "Car Card" = X,
        page "Car List" = X,
        page Managers = X,
        page ManagersCard = X;
}