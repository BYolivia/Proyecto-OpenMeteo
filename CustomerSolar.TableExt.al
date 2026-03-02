tableextension 50398 "Customer Solar Ext" extends Customer
{
    fields
    {
        field(50399; "KW_Instalado"; Decimal)
        {
            Caption = 'KW Instalado';
            DataClassification = CustomerContent;
        }
        field(50398; "Latitud"; Decimal)
        {
            Caption = 'Latitud';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 6;
        }
        field(50397; "Longitud"; Decimal)
        {
            Caption = 'Longitud';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 6;
        }
    }
}