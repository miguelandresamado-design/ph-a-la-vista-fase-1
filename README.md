# pH a la vista · Fase 1

Versión piloto cerrada para validar el flujo de medición y monitoreo de pH por finca y lote con acceso autenticado.

## Estado de esta versión

- Versión: `0.3.0-pilot-auth`
- Modo: piloto cerrado por invitación
- Backend: Supabase Auth y sincronización manual conectados
- Bluetooth: simulación identificada; conexión real bloqueada hasta validar UUID y paquetes YINMIK YK-S01
- Interpretación de café: rangos provisionales de demostración

## Ejecutar

Desde la carpeta que contiene `index.html`:

```bash
npm test
npm run check
python3 -m http.server 8080
```

Abrir `http://localhost:8080`. No abrir con `file://`.

## Funciones incluidas

- Inicio de sesión con cuenta invitada; registro público deshabilitado.
- Carga de perfil, fincas y lotes filtrada por las políticas RLS de Supabase.
- Almacenamiento local IndexedDB separado por UUID de usuario.
- Fincas y ubicación en modo de solo lectura para el técnico.
- Creación, edición, archivo y reactivación de lotes.
- Conservación del historial cuando se archiva un lote.
- Medición individual manual o simulada.
- Jornadas de 10 o 15 puntos.
- GPS opcional y temperatura.
- Persistencia con IndexedDB.
- Recuperación de jornadas.
- Mediana, promedio y desviación estándar.
- Historial por lote.
- Comparación temporal de hasta tres lotes.
- Comparación espacial de exactamente dos lotes.
- Exportación CSV.
- Cola de sincronización local visible y envío autenticado a Supabase.
- PWA y funcionamiento offline después de la primera carga.

## Seguridad

El repositorio no incluye contraseñas, llaves secretas, correos de usuarios ni nombres de agricultores. `config/app.js` contiene únicamente la URL del proyecto y la llave **publicable** de Supabase, diseñada para usarse en el navegador junto con RLS. Nunca debe colocarse una `service_role`, una secret key ni la contraseña de la base de datos en el navegador o en GitHub.

Las migraciones deben ejecutarse en orden. `001_schema.sql` crea el modelo y activa RLS; `002_security_hardening.sql` valida la coherencia entre técnico, país, finca, lote, campaña y jornada, hace inmutables las mediciones sincronizadas, restringe privilegios y genera auditoría desde la base. La interfaz aplica CSP, neutraliza fórmulas en CSV y prepara ámbitos locales separados por usuario. Todo esto debe validarse contra una instancia Supabase de prueba antes de cualquier piloto.

La puerta de salida y las pruebas adversariales están documentadas en `docs/PILOT-SECURITY-GATE.md`.

## GitHub Pages

Subir el contenido de esta carpeta a la raíz del repositorio. `index.html`, `manifest.webmanifest` y `sw.js` deben quedar directamente en la raíz. Las rutas son relativas y compatibles con un repositorio publicado como subdirectorio.

## Pendientes antes de un piloto real

1. Aprobar rangos agronómicos de café.
2. Probar las políticas RLS con tres usuarios de prueba y una cuenta administradora con MFA.
3. Incorporar UUID y decodificación BLE reales del YK-S01.
4. Validar Android Chrome y Bluefy en iPhone.
5. Probar GPS, instalación PWA y reapertura offline en dispositivos físicos.
6. Validar el procedimiento de invitación, recuperación y baja de usuarios.
7. Definir autorización, retención y eliminación de correo personal y geolocalización.
