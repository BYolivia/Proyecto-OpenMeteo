page 50395 "Fechas Radiacion Dialog"
{
    PageType = StandardDialog;
    Caption = 'Seleccionar Fechas de Descarga';

    layout
    {
        area(Content)
        {
            group(Fechas)
            {
                Caption = 'Rango de Fechas';
                InstructionalText = 'Indique el periodo del que desea obtener la radiación solar.';

                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha Desde';
                    ToolTip = 'Fecha de inicio para la descarga de datos.';

                    trigger OnValidate()
                    begin
                        if (EndDate <> 0D) and (StartDate > EndDate) then
                            Error('La Fecha Desde no puede ser posterior a la Fecha Hasta.');
                    end;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha Hasta';
                    ToolTip = 'Fecha de fin para la descarga de datos.';

                    trigger OnValidate()
                    begin
                        if (StartDate <> 0D) and (EndDate < StartDate) then
                            Error('La Fecha Hasta no puede ser anterior a la Fecha Desde.');
                    end;
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;

    procedure GetStartDate(): Date
    begin
        exit(StartDate);
    end;

    procedure GetEndDate(): Date
    begin
        exit(EndDate);
    end;
}