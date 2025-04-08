--Concesionario KIA

--Tablas

--Cliente
CREATE TABLE CLIENTE(
    Cedula VARCHAR2(12) PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL,
    Correo VARCHAR2(80) NOT NULL,
    Celular VARCHAR2(10) NOT NULL
);

--Cita
CREATE TABLE CITA(
    Id_cita NUMBER PRIMARY KEY,
    Cedula_cliente VARCHAR2(12),
    Fecha_cita DATE NOT NULL,
    Hora_cita VARCHAR2(10) NOT NULL,
    Estado VARCHAR2(20) CHECK (Estado IN ('Activa', 'Aplazada', 'Cancelada')) NOT NULL,
    
    FOREIGN KEY (Cedula_cliente) REFERENCES CLIENTE(Cedula)
);

--Vehiculo
CREATE TABLE VEHICULO(
    Id_vehiculo NUMBER PRIMARY KEY,
    Modelo VARCHAR2(50) NOT NULL,
    Precio NUMBER(12,2) NOT NULL,
    Color VARCHAR2(20) NOT NULL,
    Rines VARCHAR2(30) NOT NULL,
    Tipo_motor VARCHAR2(50) CHECK (Tipo_motor IN ('Gasolina', 'Hibrido', 'Electrico'))NOT NULL,
    Ancho NUMBER(5,2) NOT NULL,
    LARGO NUMBER(5,2) NOT NULL,
    ALTO NUMBER(5,2)NOT NULL,
    Disponibilidad VARCHAR2(20) CHECK (Disponibilidad IN ('En stock', 'Agotado')) NOT NULL,
    Capacidad NUMBER NOT NULL
);

--Notificacion
CREATE TABLE NOTIFICACION(
    Id_notificacion NUMBER PRIMARY KEY,
    Cliente_cedula VARCHAR2(12) NOT NULL,
    Fecha_solicitud DATE NOT NULL,
    Estado_envio VARCHAR2(20) CHECK (Estado_envio IN ('Enviado', 'No enviado')) NOT NULL,
    
    FOREIGN KEY (Cliente_cedula) REFERENCES CLIENTE(Cedula)
);

--Cotizacion
CREATE TABLE COTIZACION(
    Id_cotizacion NUMBER PRIMARY KEY,
    Cedula_cli VARCHAR2(20) NOT NULL,
    Estado_cotizacion VARCHAR2(20) CHECK (Estado_cotizacion IN ('Activa', 'Expirada', 'Rechazada')) NOT NULL,
    Fecha_creacion DATE NOT NULL,
    Descripcion VARCHAR2(300),
    
    FOREIGN KEY (Cedula_cli) REFERENCES CLIENTE(Cedula)
);

--Historial_disponibilidad
CREATE TABLE HISTORIAL_DISPONIBILIDAD(
    Id_historial NUMBER PRIMARY KEY,
    Id_vehiculo NUMBER NOT NULL,
    Nuevo_estado VARCHAR2(20) CHECK (Nuevo_estado IN ('En stock', 'Agotado')) NOT NULL,
    
    FOREIGN KEY (Id_vehiculo) REFERENCES VEHICULO(Id_vehiculo)
);

--Solicita
CREATE TABLE SOLICITA(
    Cedula VARCHAR2(12) NOT NULL,
    Id_notificacion NUMBER NOT NULL,
    
    PRIMARY KEY (Cedula, Id_notificacion),
    FOREIGN KEY (Cedula) REFERENCES CLIENTE(Cedula),
    FOREIGN KEY (Id_notificacion) REFERENCES NOTIFICACION(Id_notificacion)
);

--RECORDATORIO
CREATE TABLE RECORDATORIO(
    Id_notificacion NUMBER NOT NULL,
    Cedula VARCHAR2(12) NOT NULL,
    Id_vehiculo NUMBER NOT NULL,
    
    PRIMARY KEY (Id_notificacion, Cedula),
    FOREIGN KEY (Id_notificacion) REFERENCES NOTIFICACION(Id_notificacion),
    FOREIGN KEY (Cedula) REFERENCES CLIENTE(Cedula),
    FOREIGN KEY (Id_vehiculo) REFERENCES VEHICULO(Id_vehiculo)
);

--Asigna
CREATE TABLE ASIGNA(
    Id_cotizacion NUMBER NOT NULL,
    Id_vehiculo NUMBER NOT NULL,
    
    PRIMARY KEY (Id_cotizacion, Id_vehiculo),
    FOREIGN KEY (Id_cotizacion) REFERENCES COTIZACION(Id_cotizacion),
    FOREIGN KEY (Id_vehiculo) REFERENCES VEHICULO(Id_vehiculo)
);

--Tiene
CREATE TABLE TIENE(
    Id_historial NUMBER NOT NULL,
    Id_vehiculo NUMBER NOT NULL,
    
    PRIMARY KEY (Id_historial, Id_vehiculo),
    FOREIGN KEY (Id_historial) REFERENCES HISTORIAL_DISPONIBILIDAD(Id_historial),
    FOREIGN KEY (Id_vehiculo) REFERENCES VEHICULO(Id_vehiculo)
);



