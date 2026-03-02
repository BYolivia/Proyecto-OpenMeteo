page 50396 "Datos Radiacion List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Datos Radiacion";
    Caption = 'Histórico de Radiación';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Código del cliente.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Fecha de la medición.';
                }
                field("Shortwave_Radiation_Sum"; Rec."Shortwave_Radiation_Sum")
                {
                    ApplicationArea = All;
                    ToolTip = 'Radiación total recibida en el día.';
                }
            }
        }
    }
}