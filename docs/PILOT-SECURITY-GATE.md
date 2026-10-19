# Puerta de seguridad antes del piloto

No cargar correos personales, fincas reales ni coordenadas hasta completar esta lista en una instancia Supabase de prueba.

## 1. Configuración de acceso

- Desactivar el registro público; crear usuarios únicamente por invitación.
- Configurar exclusivamente las URLs exactas del sitio para confirmación y recuperación.
- Activar MFA para todas las cuentas administradoras.
- Mantener `service_role`, contraseña de base de datos y tokens personales fuera del navegador, GitHub y archivos ZIP.
- El navegador solo puede usar la clave `publishable` o la clave pública heredada `anon`.
- Definir un responsable capaz de desactivar inmediatamente una cuenta o cerrar sus sesiones.

## 2. Datos personales y ubicación

- Obtener autorización informada para usar correo personal, identificación del técnico y GPS.
- Informar finalidad, responsable, tiempo de conservación y mecanismo de retiro.
- No almacenar nombres de agricultores o propietarios.
- No publicar asignaciones, ubicaciones, coordenadas ni correos en GitHub.
- Limitar exportaciones y acceso administrativo a quienes realmente lo necesitan.

## 3. Prueba obligatoria de aislamiento

Crear cuatro cuentas de prueba: `admin`, `tecnico-a`, `tecnico-b` y `tecnico-c`.

Para cada técnico verificar:

1. Solo puede leer sus cinco fincas asignadas.
2. No puede consultar una finca ajena aunque conozca su UUID.
3. Solo puede crear y editar lotes dentro de sus fincas.
4. No puede mover un lote a otra finca ni eliminarlo físicamente.
5. No puede crear una jornada para una finca o lote ajenos.
6. No puede asociar una medición con otra jornada, finca, lote, campaña o técnico.
7. No puede modificar una medición ya sincronizada ni fabricar eventos de auditoría.
8. Al cerrar sesión no puede ver datos locales del usuario anterior.

La prueba debe hacerse a través de la misma API pública utilizada por la aplicación; comprobar datos únicamente desde el editor SQL no valida RLS.

## 4. Operación y recuperación

- Ejecutar Security Advisor y resolver hallazgos de nivel error o warning no justificados.
- Programar respaldo lógico cifrado fuera de Supabase mientras se use el plan Free.
- Ensayar una restauración antes del piloto, no solo la creación del respaldo.
- Registrar quién administra Supabase, GitHub y las invitaciones.
- Definir un procedimiento simple: bloquear cuenta, revocar sesiones, preservar evidencia y comunicar el incidente.

## Criterio de salida

El piloto puede recibir datos reales únicamente cuando las ocho pruebas de aislamiento pasen con las tres cuentas, no existan secretos en el repositorio y el responsable del proyecto apruebe la autorización de tratamiento de datos.
