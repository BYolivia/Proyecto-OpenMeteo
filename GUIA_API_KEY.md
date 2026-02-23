# Guía de uso de la API OpenMeteo

## Sin registro ni API Key

OpenMeteo ofrece una API **completamente gratuita** para uso no comercial.
No requiere registro, ni API Key, ni ningún tipo de autenticación.

URL base: `https://api.open-meteo.com`

---

## Endpoint para obtener shortwave_radiation_sum

```text
https://api.open-meteo.com/v1/forecast
  ?latitude={LAT}
  &longitude={LON}
  &daily=shortwave_radiation_sum
  &start_date={YYYY-MM-DD}
  &end_date={YYYY-MM-DD}
  &timezone=Europe%2FMadrid
```

**Ejemplo real** para Valencia (lat=39.47, lon=-0.38), enero 2024:

```text
https://api.open-meteo.com/v1/forecast?latitude=39.47&longitude=-0.38&daily=shortwave_radiation_sum&start_date=2024-01-01&end_date=2024-01-31&timezone=Europe%2FMadrid
```

Pega esa URL en el navegador para verificar que devuelve datos antes de programarla en AL.

---

## Construcción de la URL en AL

```al
Url := 'https://api.open-meteo.com/v1/forecast' +
       '?latitude='  + Format(Latitud,  0, 9) +
       '&longitude=' + Format(Longitud, 0, 9) +
       '&daily=shortwave_radiation_sum' +
       '&start_date=' + Format(FechaInicio, 0, '<Year4>-<Month,2>-<Day,2>') +
       '&end_date='   + Format(FechaFin,    0, '<Year4>-<Month,2>-<Day,2>') +
       '&timezone=Europe%2FMadrid';
```

---

## Respuesta JSON de ejemplo

```json
{
  "latitude": 39.47,
  "longitude": -0.38,
  "daily": {
    "time": ["2024-01-01", "2024-01-02"],
    "shortwave_radiation_sum": [5.2, 7.1]
  }
}
```

El campo `shortwave_radiation_sum` devuelve **MJ/m²** por día.
Es el valor que se almacenará en la tabla `Datos_Radiacion`.

---

## Obtener latitud y longitud de una población

OpenMeteo también ofrece una API de geocodificación gratuita:

```text
https://geocoding-api.open-meteo.com/v1/search?name={POBLACION}&count=1&language=es
```

Devuelve `latitude` y `longitude` a partir del nombre de la población,
útil para obtener las coordenadas directamente desde la dirección del cliente.

---

## Referencias

- Documentación oficial: [open-meteo.com/en/docs](https://open-meteo.com/en/docs)
- Variables de radiación solar: sección **"Solar Radiation Variables"** en la documentación.
- API de geocodificación: [open-meteo.com/en/docs/geocoding-api](https://open-meteo.com/en/docs/geocoding-api)
