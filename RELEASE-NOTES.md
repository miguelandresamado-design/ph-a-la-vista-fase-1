# pH a la vista · Fase 1 · v0.2.0

Iteración del piloto enfocada en el control de usuarios, fincas y lotes.

## Incluye

- Tres perfiles ficticios de Colombia.
- Cinco fincas por técnico y tres lotes por finca.
- Fincas de solo lectura para el técnico.
- Creación y edición de lotes dentro de fincas asignadas.
- Archivo y reactivación sin borrar jornadas ni mediciones.
- Cola local de cambios en lotes para sincronización posterior.
- Medición individual.
- Jornadas de 10 o 15 puntos.
- Persistencia local con IndexedDB.
- Recuperación de jornadas en curso.
- Mediana, promedio y desviación estándar.
- Historial por lote.
- Comparación temporal de máximo tres lotes.
- Comparación espacial de exactamente dos lotes.
- Exportación CSV.
- Cola local de sincronización.
- Manifest, Service Worker e iconos PWA.
- Esquema inicial de Supabase con RLS.

## Simulado o pendiente

- La lectura YK-S01 es simulada y se identifica como tal.
- Supabase no está conectado; la pantalla muestra únicamente operaciones locales pendientes.
- Los rangos de café son provisionales para demostración.
- GPS, Bluefy, Bluetooth real y funcionamiento offline requieren prueba manual en dispositivos.

## Verificación automatizada

- Sintaxis JavaScript: aprobada.
- Pruebas automatizadas de permisos, validación y datos públicos incluidas.
- Archivos principales servidos por HTTP: respuesta 200.
- Datos reales o secretos: no incluidos.
