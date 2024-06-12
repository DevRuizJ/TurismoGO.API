CREATE database Turismo_GO;

Use Turismo_GO;

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Contraseña NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Empresas de Turismo
CREATE TABLE EmpresasTurismo (
    EmpresaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Contraseña NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Actividades
CREATE TABLE Actividades (
    ActividadID INT IDENTITY(1,1) PRIMARY KEY,
    EmpresaID INT FOREIGN KEY REFERENCES EmpresasTurismo(EmpresaID),
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(MAX) NOT NULL,
    Destino NVARCHAR(100) NOT NULL,
    Itinerario NVARCHAR(MAX),
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    FechaPublicacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Reservas
CREATE TABLE Reservas (
    ReservaID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    ActividadID INT FOREIGN KEY REFERENCES Actividades(ActividadID),
    FechaReserva DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Reseñas
CREATE TABLE Reseñas (
    ReseñaID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    ActividadID INT FOREIGN KEY REFERENCES Actividades(ActividadID),
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
    Comentario NVARCHAR(MAX),
    FechaReseña DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Roles
CREATE TABLE Roles (
    RolID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Tabla de Permisos
CREATE TABLE Permisos (
    PermisoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- Tabla de Asignación de Roles
CREATE TABLE AsignacionRoles (
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    RolID INT FOREIGN KEY REFERENCES Roles(RolID),
    PRIMARY KEY (UsuarioID, RolID)
);
GO

-- Tabla de Asignación de Permisos
CREATE TABLE AsignacionPermisos (
    RolID INT FOREIGN KEY REFERENCES Roles(RolID),
    PermisoID INT FOREIGN KEY REFERENCES Permisos(PermisoID),
    PRIMARY KEY (RolID, PermisoID)
);
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

--CREAR USUARIO
CREATE PROCEDURE CrearUsuario
    @Nombre NVARCHAR(100),
    @Email NVARCHAR(100),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    INSERT INTO Usuarios (Nombre, Email, Contraseña)
    VALUES (@Nombre, @Email, @Contraseña);
END;
GO

--AREGAR NUEVA ACTIVIDAD
CREATE PROCEDURE AgregarActividad
    @EmpresaID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(MAX),
    @Destino NVARCHAR(100),
    @Itinerario NVARCHAR(MAX),
    @FechaInicio DATE,
    @FechaFin DATE,
    @Precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Actividades (EmpresaID, Nombre, Descripcion, Destino, Itinerario, FechaInicio, FechaFin, Precio)
    VALUES (@EmpresaID, @Nombre, @Descripcion, @Destino, @Itinerario, @FechaInicio, @FechaFin, @Precio);
END;
GO


--RESERVAR ACTIVIDAD
CREATE PROCEDURE ReservarActividad
    @UsuarioID INT,
    @ActividadID INT
AS
BEGIN
    INSERT INTO Reservas (UsuarioID, ActividadID)
    VALUES (@UsuarioID, @ActividadID);
END;
GO

--DEJAR RESEÑA
CREATE PROCEDURE DejarReseña
    @UsuarioID INT,
    @ActividadID INT,
    @Calificacion INT,
    @Comentario NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Reseñas (UsuarioID, ActividadID, Calificacion, Comentario)
    VALUES (@UsuarioID, @ActividadID, @Calificacion, @Comentario);
END;
GO

--GENERAR INFORME DE ACTIVIDADES
CREATE PROCEDURE GenerarInformeActividades
AS
BEGIN
    SELECT 
        A.Nombre,
        A.Destino,
        COUNT(R.ReservaID) AS NumeroReservas,
        AVG(Re.Calificacion) AS CalificacionPromedio,
        SUM(A.Precio) AS IngresosGenerados
    FROM 
        Actividades A
    LEFT JOIN 
        Reservas R ON A.ActividadID = R.ActividadID
    LEFT JOIN 
        Reseñas Re ON A.ActividadID = Re.ActividadID
    GROUP BY 
        A.Nombre, A.Destino;
END;
GO


--GESTION DE ROLES Y PERMISOS
-- Asignar Rol a Usuario
CREATE PROCEDURE AsignarRolUsuario
    @UsuarioID INT,
    @RolID INT
AS
BEGIN
    INSERT INTO AsignacionRoles (UsuarioID, RolID)
    VALUES (@UsuarioID, @RolID);
END;
GO

-- Asignar Permiso a Rol
CREATE PROCEDURE AsignarPermisoRol
    @RolID INT,
    @PermisoID INT
AS
BEGIN
    INSERT INTO AsignacionPermisos (RolID, PermisoID)
    VALUES (@RolID, @PermisoID);
END;
GO

-- Crear Rol
CREATE PROCEDURE CrearRol
    @Nombre NVARCHAR(50)
AS
BEGIN
    INSERT INTO Roles (Nombre)
    VALUES (@Nombre);
END;
GO

-- Crear Permiso
CREATE PROCEDURE CrearPermiso
    @Nombre NVARCHAR(100)
AS
BEGIN
    INSERT INTO Permisos (Nombre)
    VALUES (@Nombre);
END;
GO

