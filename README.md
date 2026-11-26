# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

- **URL exacta de la API:** `https://jsonplaceholder.typicode.com/todos`
- **Parámetro userId configurado:** `userId = 2` (se realizan consultas a `https://jsonplaceholder.typicode.com/todos?userId=2`).
- **Campos recibidos desde la API:** `userId`, `id`, `title`, `completed`.
- **Valores completados por defecto en TaskFlow:**
  - `description`: `"Sin descripción (API)"` (la API remota no provee este campo).
  - `priority`: `"Sin prioridad (API)"` (la API remota no provee este campo).
- **Persistencia de cambios:** Marcar o desmarcar una tarea como completada actualiza únicamente la copia en memoria local (`RemoteTaskRepository`). La API de prueba JSONPlaceholder no persiste cambios permanentes en el servidor remoto, por lo que al reiniciar la aplicación se volverán a cargar los datos originales del servidor.

## Estados de la interfaz

TaskFlow maneja cuatro estados asíncronos en la pantalla principal (`TaskListScreen`):

1. **Estado de Carga (`isLoading = true`)**:
   - **UI**: Muestra un indicador giratorio `CircularProgressIndicator` en el centro de la pantalla.
   - **Disparador**: Se activa cuando `loadTasks()` inicia la consulta asíncrona a la API.

2. **Estado de Éxito (Lista con datos)**:
   - **UI**: Renderiza la lista de tareas con `ListView.builder` y habilita el gesto de deslizar hacia abajo (`RefreshIndicator`) y el botón de recarga en el `AppBar`.
   - **Disparador**: Se activa cuando la respuesta HTTP devuelve datos correctamente (`statusCode == 200`).

3. **Estado de Error (`errorMessage != null`)**:
   - **UI**: Muestra el mensaje *"No se pudieron cargar las tareas."* centrado en pantalla junto a un botón **"Reintentar"**.
   - **Cómo provocarlo**: Desactivando la conexión a internet en el dispositivo/emulador o ingresando una URL o endpoint incorrecto en Dio.
   - **Recuperación**: Al presionar **"Reintentar"**, se invoca `context.read<TasksViewModel>().loadTasks()`. Una vez restablecida la conexión, la app recupera la lista de tareas de forma dinámica **sin necesidad de reiniciar la aplicación**.

4. **Estado Vacío (`isEmpty = true`)**:
   - **UI**: Muestra el mensaje *"Todavía no hay tareas para mostrar."* centrado junto a un botón **"Actualizar"**.
   - **Cómo provocarlo**: Consultando un `userId` que no tenga tareas asignadas o configurando una lista vacía `[]` en el repositorio.
   - **Recuperación**: Presionar el botón **"Actualizar"** vuelve a consultar la fuente de datos.

## Formulario de Tareas y Selección de Fecha

Se ha implementado la pantalla `TaskFormScreen` accesible mediante el botón flotante `+ Nueva tarea` (`/new`):

- **Modelo de borrador (`TaskDraft`)**: Almacena de forma temporal los datos ingresados: `title`, `description`, `priority` y `dueDate` (opcional).
- **Validaciones personalizadas**:
  - `title`: Requerido. Muestra *"Por favor, ingresa un título para la tarea."* si está vacío, o *"El título debe tener al menos 3 caracteres."* si tiene menos de 3 letras.
- **Selector de fecha (`showDatePicker`)**: Permite seleccionar una fecha límite opcional mediante un calendario nativo. Si no se selecciona ninguna fecha, el borrador mantiene `dueDate = null` y se guarda con la etiqueta `"Sin fecha límite"`.
- **Retorno de datos**: Al presionar **"Guardar borrador"**, se ejecuta `context.pop(draft)` devolviendo el borrador a `TaskListScreen`, la cual muestra una notificación flotante (`SnackBar`) con el título y la fecha límite seleccionada.