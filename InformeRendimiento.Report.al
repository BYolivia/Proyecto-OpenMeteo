report 50393 "Informe Rendimiento Solar"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Informe Anual de Rendimiento Solar';

    //Generamos el archivo Excel
    DefaultLayout = Excel;
    ExcelLayout = 'InformeRendimiento.xlsx';

    dataset
    {
        dataitem(Customer; Customer)
        {
            //Solo procesamos clientes que tengan KW instalados
            DataItemTableView = where(KW_Instalado = filter('>0'));

            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(KW_Instalado; KW_Instalado) { }
            column(SumaBaseFacturas; SumaBaseFacturas) { }
            column(SumaRadiacion; SumaRadiacion) { }
            column(PorcentajeRentabilidad; PorcentajeRentabilidad) { }
            column(AnoAnalisis; FiltroAno) { }

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                DatosRad: Record "Datos Radiacion";
            begin
                SumaBaseFacturas := 0;
                SumaRadiacion := 0;
                PorcentajeRentabilidad := 0;

                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetRange("Sell-to Customer No.", Customer."No.");
                SalesInvoiceHeader.SetRange("Posting Date", DMY2Date(1, 1, FiltroAno), DMY2Date(31, 12, FiltroAno));
                if SalesInvoiceHeader.FindSet() then
                    repeat
                        SalesInvoiceHeader.CalcFields(Amount);
                        SumaBaseFacturas += SalesInvoiceHeader.Amount;
                    until SalesInvoiceHeader.Next() = 0;

                DatosRad.Reset();
                DatosRad.SetRange("Customer No.", Customer."No.");
                DatosRad.SetRange("Date", DMY2Date(1, 1, FiltroAno), DMY2Date(31, 12, FiltroAno));
                if DatosRad.FindSet() then
                    repeat
                        SumaRadiacion += DatosRad.Shortwave_Radiation_Sum;
                    until DatosRad.Next() = 0;

                if (SumaBaseFacturas > 0) and (Customer.KW_Instalado > 0) then
                    PorcentajeRentabilidad := SumaRadiacion / SumaBaseFacturas / Customer.KW_Instalado
                else
                    PorcentajeRentabilidad := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Opciones)
                {
                    Caption = 'Filtros del Informe';
                    field(FiltroAno; FiltroAno)
                    {
                        ApplicationArea = All;
                        Caption = 'Año a analizar';
                        ToolTip = 'Introduzca el año con 4 dígitos (Ej: 2023).';
                        MinValue = 2000;
                        MaxValue = 2100;
                    }
                }
            }
        }

        trigger OnInit()
        begin
            FiltroAno := Date2DMY(Today, 3);
        end;
    }

    var
        FiltroAno: Integer;
        SumaBaseFacturas: Decimal;
        SumaRadiacion: Decimal;
        PorcentajeRentabilidad: Decimal;
}