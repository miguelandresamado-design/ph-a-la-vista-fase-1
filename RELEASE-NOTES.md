# pH a la vista · Fase 1 · v0.4.0-pilot-bluetooth

Versión conectada a Supabase para iniciar las pruebas controladas de autenticación, aislamiento y sincronización. Todavía no contiene correos ni contraseñas en el repositorio.

## Incluye

- Inicio de sesión cerrado con Supabase Auth.
- Recepción de enlaces de invitación y creación de contraseña.
- Perfil, fincas y lotes filtrados por RLS.
- Almacenamiento offline separado por UUID de usuario.
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
- Sincronización autenticada de lotes, jornadas y mediciones.
- Conservación de cambios locales pendientes al actualizar datos remotos.
- Manifest, Service Worker e iconos PWA.
- Esquema inicial de Supabase con RLS.
- Segunda migración con validación relacional, mediciones inmutables y mínimos privilegios.
- Auditoría generada mediante triggers de base de datos.
- Escape de texto no confiable en gráficos SVG.
- Protección contra fórmulas maliciosas en CSV.
- Política CSP y política de referencia en la aplicación.
- Preparación para separar y eliminar el almacenamiento offline por usuario autenticado.
- Conexión real con YINMIK YK-S01 mediante el servicio FF01 y la característica FF02.
- Recepción por notificaciones y lectura periódica cada 2 segundos para conservar la segunda lectura y las siguientes.
- Compatibilidad prevista con Chrome Android y Bluefy en iPhone, además de entrada manual de respaldo.

## Simulado o pendiente

- Los rangos de café son provisionales para demostración.
- GPS, Bluefy, Bluetooth real y funcionamiento offline requieren revalidación manual en dispositivos después de esta integración.

## Verificación automatizada

- Sintaxis JavaScript: aprobada.
- Pruebas automatizadas de permisos, validación, datos públicos y controles de seguridad incluidas.
- Archivos principales servidos por HTTP: respuesta 200.
- Datos reales o secretos: no incluidos.
