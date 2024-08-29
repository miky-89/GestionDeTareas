<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Tareas Diarias</title>
    <link rel="stylesheet" type="text/css" href="css/estilos.css">
    <!-- Incluir la biblioteca Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
    <div class="header">
        <!-- Verificar si el nombre del usuario est� presente -->
        <c:if test="${not empty nombreUsuario}">
            <p id="info"></p>
            <p>Tareas completadas: ${tareasCompletadas} de ${tareasTotales}</p>
            <!-- Bot�n para cerrar sesi�n -->
            <form action="tareas" method="post" style="display:inline;">
                <input type="hidden" name="action" value="logout">
                <button type="submit">Cerrar Sesi�n</button>
            </form>
        </c:if>
    </div>
    
    <div class="container">
        <!-- Si no se ha ingresado el nombre, mostrar el formulario para ingresar el nombre -->
        <c:if test="${empty nombreUsuario}">
            <form action="tareas" method="post">
                <input type="text" name="nombreUsuario" placeholder="Ingrese su nombre" required>
                <button type="submit">Ingresar</button>
            </form>
        </c:if>
        
        <!-- Si el nombre del usuario est� presente, mostrar la lista de tareas y el gr�fico -->
        <c:if test="${not empty nombreUsuario}">
            <div class="left-column">
                <canvas id="myChart"></canvas>
            </div>

            <div class="right-column">
                <h1>Lista de Tareas</h1>
                <form action="tareas" method="post">
                    <input type="text" name="descripcion" placeholder="A�adir nueva tarea" required>
                    <button type="submit">A�adir</button>
                </form>
                
                <c:if test="${not empty listaTareas}">
                    <ul>
                        <c:forEach var="tarea" items="${listaTareas}">
                            <!-- Aplicar la clase 'completada' si la tarea est� marcada como completada -->
                            <li class="${tarea.completada ? 'completada' : ''}" style="display: flex; align-items: center; justify-content: space-between;">
                                <form action="tareas" method="post" style="display:inline;">
                                    <input type="hidden" name="descripcion" value="${tarea.descripcion}">
                                    <input type="hidden" name="action" value="completar">
                                    <button type="submit" class="btn-completar ${tarea.completada ? 'checked' : ''}"></button>
                                </form>
                                <span style="flex-grow: 1; text-align: center; margin: 0 10px;">${tarea.descripcion}</span>
                                <form action="tareas" method="post" style="display:inline;">
                                    <input type="hidden" name="descripcion" value="${tarea.descripcion}">
                                    <input type="hidden" name="action" value="eliminar">
                                    <button type="submit" class="btn-eliminar">Eliminar</button>
                                </form>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
            </div>
        </c:if>
    </div>

    <script>
        // Solo mostrar la informaci�n si el nombre del usuario est� presente
        <c:if test="${not empty nombreUsuario}">
            // Obteniendo la fecha actual
            const fecha = new Date();
            
            // Configurando opciones para formatear la fecha en espa�ol
            const opciones = { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric', 
                hour: 'numeric', 
                minute: 'numeric', 
                second: 'numeric' 
            };
            
            // Formateando la fecha en espa�ol
            const fechaFormateada = fecha.toLocaleDateString('es-ES', opciones);

            // Mostrando la fecha y el nombre del usuario en el elemento con id "info"
            document.getElementById('info').innerText = '${nombreUsuario} - ' + fechaFormateada;
        </c:if>
    </script>

    <c:if test="${not empty nombreUsuario}">
        
        
        <script>
            // C�digo para manejar el estilo de "completar"
            document.querySelectorAll('.btn-completar').forEach(button => {
                button.addEventListener('click', function(event) {
                    event.preventDefault(); // Evitar que el formulario se env�e inmediatamente
                    this.classList.toggle('checked');
                    this.closest('form').submit(); // Enviar el formulario manualmente despu�s del cambio de estilo
                });
            });
        </script>

        <script>
            // Crear un gr�fico de tipo 'doughnut'
            const ctx = document.getElementById('myChart').getContext('2d');
            const myChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Completadas', 'Pendientes'],
                    datasets: [{
                        label: 'Tareas',
                        data: [${tareasCompletadas}, ${tareasTotales - tareasCompletadas}],
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(255, 99, 132, 0.2)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                }
            });
        </script>
    </c:if>
</body>
</html>
