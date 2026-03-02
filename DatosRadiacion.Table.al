table 50399 "Datos Radiacion"
{
    DataClassification = CustomerContent;
    Caption = 'Datos de Radiación';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Cód. Cliente';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(2; "Date"; Date)
        {
            Caption = 'Fecha';
            DataClassification = CustomerContent;
        }
        field(3; "Shortwave_Radiation_Sum"; Decimal)
        {
            Caption = 'Suma Radiación Onda Corta';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Date")
        {
            Clustered = true;
        }
    }
}