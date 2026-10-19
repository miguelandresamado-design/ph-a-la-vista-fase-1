# pH a la vista · Fase 1 · v0.2.1-security

Versión de endurecimiento previa al piloto. Todavía no contiene usuarios ni datos reales.

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
- Segunda migración con validación relacional, mediciones inmutables y mínimos privilegios.
- Auditoría generada mediante triggers de base de datos.
- Escape de texto no confiable en gráficos SVG.
- Protección contra fórmulas maliciosas en CSV.
- Política CSP y política de referencia en la aplicación.
- Preparación para separar y eliminar el almacenamiento offline por usuario autenticado.

## Simulado o pendiente

- La lectura YK-S01 es simulada y se identifica como tal.
- Supabase no está conectado; la pantalla muestra únicamente operaciones locales pendientes.
- Los rangos de café son provisionales para demostración.
- GPS, Bluefy, Bluetooth real y funcionamiento offline requieren prueba manual en dispositivos.

## Verificación automatizada

- Sintaxis JavaScript: aprobada.
- Pruebas automatizadas de permisos, validación, datos públicos y controles de seguridad incluidas.
- Archivos principales servidos por HTTP: respuesta 200.
- Datos reales o secretos: no incluidos.
