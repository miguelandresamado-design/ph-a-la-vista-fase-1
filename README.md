# pH a la vista · Fase 1

Versión navegable independiente para validar el flujo de medición y monitoreo de pH por finca y lote. Todos los perfiles, fincas, coordenadas e históricos son ficticios.

## Estado de esta versión

- Versión: `0.2.1-security`
- Modo: demostración local
- Backend: preparado, no conectado
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

- Activación con tres perfiles ficticios de Colombia.
- Cinco fincas asignadas por técnico.
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
- Cola de sincronización local visible.
- PWA y funcionamiento offline después de la primera carga.

## Seguridad

No existen credenciales ni datos reales. El modelo no incluye nombres de agricultores: únicamente perfiles técnicos, nombres de fincas, ubicación y lotes. `config/app.example.js` documenta la futura configuración, pero no contiene secretos. Nunca debe colocarse una `service_role` en el navegador.

Las migraciones deben ejecutarse en orden. `001_schema.sql` crea el modelo y activa RLS; `002_security_hardening.sql` valida la coherencia entre técnico, país, finca, lote, campaña y jornada, hace inmutables las mediciones sincronizadas, restringe privilegios y genera auditoría desde la base. La interfaz aplica CSP, neutraliza fórmulas en CSV y prepara ámbitos locales separados por usuario. Todo esto debe validarse contra una instancia Supabase de prueba antes de cualquier piloto.

La puerta de salida y las pruebas adversariales están documentadas en `docs/PILOT-SECURITY-GATE.md`.

## GitHub Pages

Subir el contenido de esta carpeta a la raíz del repositorio. `index.html`, `manifest.webmanifest` y `sw.js` deben quedar directamente en la raíz. Las rutas son relativas y compatibles con un repositorio publicado como subdirectorio.

## Pendientes antes de un piloto real

1. Aprobar rangos agronómicos de café.
2. Conectar Supabase Auth y sincronización remota.
3. Probar las políticas RLS con tres usuarios reales de prueba y una cuenta administradora con MFA.
4. Incorporar UUID y decodificación BLE reales del YK-S01.
5. Validar Android Chrome y Bluefy en iPhone.
6. Probar GPS, instalación PWA y reapertura offline en dispositivos físicos.
7. Configurar registro cerrado por invitación, URLs de redirección exactas y procedimiento de baja de usuarios.
8. Definir autorización, retención y eliminación de correo personal y geolocalización.
