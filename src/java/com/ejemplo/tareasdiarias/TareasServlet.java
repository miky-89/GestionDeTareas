package com.ejemplo.tareasdiarias;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/tareas")
public class TareasServlet extends HttpServlet {
    private List<Tarea> listaTareas = new ArrayList<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtenemos el nombre de usuario de la sesión
        String nombreUsuario = (String) request.getSession().getAttribute("nombreUsuario");

        // Si no hay un nombre de usuario en la sesión, redirigir al formulario de ingreso de nombre
        if (nombreUsuario == null || nombreUsuario.isEmpty()) {
            request.getRequestDispatcher("tareas.jsp").forward(request, response);
            return;
        }

        // Calcular el número de tareas completadas
        int tareasCompletadas = (int) listaTareas.stream().filter(Tarea::isCompletada).count();
        int tareasTotales = listaTareas.size();

        // Configurar las tareas y el informe como atributos de la solicitud
        request.setAttribute("listaTareas", listaTareas);
        request.setAttribute("tareasCompletadas", tareasCompletadas);
        request.setAttribute("tareasTotales", tareasTotales);
        request.setAttribute("nombreUsuario", nombreUsuario);  // Pasar el nombre de usuario a la JSP

        // Redirigir a la página JSP
        request.getRequestDispatcher("tareas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombreUsuario = request.getParameter("nombreUsuario");

        // Si el nombre de usuario está presente en la solicitud, guardarlo en la sesión
        if (nombreUsuario != null && !nombreUsuario.trim().isEmpty()) {
            request.getSession().setAttribute("nombreUsuario", nombreUsuario);
        }

        String action = request.getParameter("action");
        String descripcion = request.getParameter("descripcion");

        if ("eliminar".equals(action)) {
            // Eliminar la tarea de la lista
            listaTareas.removeIf(tarea -> tarea.getDescripcion().equals(descripcion));
        } else if ("completar".equals(action)) {
            // Marcar la tarea como completada o incompleta
            listaTareas.stream()
                       .filter(tarea -> tarea.getDescripcion().equals(descripcion))
                       .forEach(tarea -> tarea.setCompletada(!tarea.isCompletada()));
        } else if ("logout".equals(action)) {
            // Invalidar la sesión para cerrar la sesión del usuario
            request.getSession().invalidate();
            // Redirigir al usuario para que vuelva a ingresar su nombre
            response.sendRedirect("tareas");
            return;
        } else {
            if (descripcion != null && !descripcion.trim().isEmpty()) {
                // Añadir la nueva tarea a la lista
                listaTareas.add(new Tarea(descripcion));
            }
        }

        // Redirigir al usuario para evitar re-envío del formulario
        response.sendRedirect("tareas");
    }
}
