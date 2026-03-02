pageextension 50397 "Customer Card Solar Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            group("Datos Solares")
            {
                Caption = 'Datos Solares';
                field("KW_Instalado"; Rec."KW_Instalado") { ApplicationArea = All; }
                field("Latitud"; Rec."Latitud") { ApplicationArea = All; }
                field("Longitud"; Rec."Longitud") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(DescargarRadiacion)
            {
                Caption = 'Descargar Radiación';
                ApplicationArea = All;
                Image = Sun;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Descarga los datos de radiación solar de OpenMeteo.';

                trigger OnAction()
                var
                    DialogFechas: Page "Fechas Radiacion Dialog";
                    MgtRadiacion: Codeunit "Mgt. Radiacion Solar";
                begin
                    if Rec.KW_Instalado <= 0 then
                        Error('El cliente no tiene KW instalados. Configure este valor antes de descargar.');

                    if (Rec.Latitud = 0) and (Rec.Longitud = 0) then
                        Error('Debe configurar la Latitud y Longitud del cliente.');

                    if DialogFechas.RunModal() = Action::OK then begin
                        MgtRadiacion.DescargarDatos(Rec, DialogFechas.GetStartDate(), DialogFechas.GetEndDate());
                    end;
                end;
            }
        }
    }
}