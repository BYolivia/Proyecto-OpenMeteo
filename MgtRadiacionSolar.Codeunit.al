codeunit 50394 "Mgt. Radiacion Solar"
{
    procedure DescargarDatos(Cust: Record Customer; StartDate: Date; EndDate: Date)
    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonText: Text;
        Url: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        JDaily: JsonObject;
        JTimeArray: JsonArray;
        JRadArray: JsonArray;
        i: Integer;
        DateText: Text;
        CurrentDate: Date;
        RadValue: Decimal;
        DatosRadiacion: Record "Datos Radiacion";
        StartDateTxt: Text;
        EndDateTxt: Text;
    begin
        //Formateamos las fechas
        StartDateTxt := Format(StartDate, 0, '<Year4>-<Month,2>-<Day,2>');
        EndDateTxt := Format(EndDate, 0, '<Year4>-<Month,2>-<Day,2>');

        //Construimos la URL de OpenMeteo
        Url := StrSubstNo('https://archive-api.open-meteo.com/v1/archive?latitude=%1&longitude=%2&start_date=%3&end_date=%4&daily=shortwave_radiation_sum&timezone=Europe/Madrid',
            Format(Cust.Latitud, 0, 9),
            Format(Cust.Longitud, 0, 9),
            StartDateTxt, EndDateTxt);

        //Realizamos la petición GET
        if not HttpClient.Get(Url, ResponseMessage) then
            Error('Fallo al conectar con OpenMeteo. Revise su conexión a Internet.');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('La API devolvió un error HTTP %1', ResponseMessage.HttpStatusCode());

        ResponseMessage.Content().ReadAs(JsonText);

        //Leemos la respuesta JSON
        if not JObject.ReadFrom(JsonText) then
            Error('Error al procesar el texto JSON devuelto por la API.');

        if JObject.Get('daily', JToken) then begin
            JDaily := JToken.AsObject();

            JDaily.Get('time', JToken);
            JTimeArray := JToken.AsArray();

            JDaily.Get('shortwave_radiation_sum', JToken);
            JRadArray := JToken.AsArray();

            //Insertamos los datos
            for i := 0 to JTimeArray.Count() - 1 do begin
                // Obtener fecha
                JTimeArray.Get(i, JToken);
                DateText := JToken.AsValue().AsText();
                Evaluate(CurrentDate, DateText, 9);

                JRadArray.Get(i, JToken);
                if not JToken.AsValue().IsNull() then begin
                    RadValue := JToken.AsValue().AsDecimal();

                    if not DatosRadiacion.Get(Cust."No.", CurrentDate) then begin
                        DatosRadiacion.Init();
                        DatosRadiacion."Customer No." := Cust."No.";
                        DatosRadiacion."Date" := CurrentDate;
                        DatosRadiacion.Shortwave_Radiation_Sum := RadValue;
                        DatosRadiacion.Insert();
                    end else begin
                        DatosRadiacion.Shortwave_Radiation_Sum := RadValue;
                        DatosRadiacion.Modify();
                    end;
                end;
            end;

            Message('¡Descarga completada con éxito! Se han sincronizado %1 días de radiación.', JTimeArray.Count());
        end else
            Error('El formato JSON no es el esperado (falta el nodo "daily").');
    end;
}