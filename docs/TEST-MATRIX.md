# Matriz de pruebas · versión 0.2.1-security

| Área | Estado | Evidencia o límite |
|---|---|---|
| Sintaxis JavaScript | Verificada mediante ejecución | `npm run check` sin errores |
| Estadística e interpretación | Verificada mediante ejecución | Pruebas automatizadas aprobadas |
| Datos ficticios y asignaciones | Verificada mediante ejecución | 3 técnicos, 5 fincas por técnico y 3 lotes por finca |
| Privacidad del piloto | Verificada mediante ejecución | El paquete público no contiene campos ni nombres de agricultores o propietarios |
| Administración de lotes | Verificada mediante ejecución | Normalización, validación, duplicados y archivo sin eliminación |
| Permisos RLS de lotes | Verificada estáticamente | Técnico puede insertar y actualizar lotes asignados; no existe política de eliminación |
| CSV | Verificada mediante ejecución | Comillas, comas, saltos y UTF-8 |
| CSV seguro | Verificada mediante ejecución | Neutralización de valores interpretables como fórmulas |
| Gráficos SVG | Verificada mediante ejecución | Escape de nombres no confiables |
| Política del navegador | Verificada estáticamente | CSP y `no-referrer` presentes |
| Aislamiento offline | Preparado, integración pendiente | Ámbitos IndexedDB por usuario y función de borrado |
| Integridad relacional Supabase | Verificada estáticamente | Triggers para jornada y medición; falta ejecución en instancia |
| Auditoría Supabase | Verificada estáticamente | Eventos mediante triggers; falta ejecución en instancia |
| Service Worker | Verificada estáticamente | Caché versionado, lista local y archivos presentes; offline requiere navegador |
| Navegación móvil | Verificación manual requerida | Navegador real |
| Persistencia IndexedDB | Verificación manual requerida | Navegador real |
| Recuperación de jornada | Verificación manual requerida | Cierre y reapertura |
| GPS | Verificación manual requerida | Dispositivo físico y permisos |
| Bluetooth real YK-S01 | Bloqueada | Faltan UUID y protocolo validados |
| Bluefy iPhone | Bloqueada | Requiere iPhone, Bluefy y sensor |
| Supabase/RLS | Bloqueada | Requiere instancia de prueba |
| PWA offline | Verificación manual requerida | Primera carga y desconexión |

## Resultado automatizado

- Validación de sintaxis: aprobada.
- Pruebas: 19 aprobadas, 0 fallidas.
- Navegador automatizado: no disponible porque el entorno no tiene binario Chromium instalado; no se declara validación visual.
