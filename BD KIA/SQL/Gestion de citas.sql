--Gestion citas

--Secuencias
--Cita
CREATE SEQUENCE seq_cita START WITH 1 INCREMENT BY 1;
--Vehiculo
CREATE SEQUENCE seq_vehiculo START WITH 101 INCREMENT BY 1;


--Trigger
--Cita
CREATE OR REPLACE TRIGGER trg_cita
BEFORE INSERT ON CITA
FOR EACH ROW
BEGIN
  :NEW.Id_cita := seq_cita.NEXTVAL;
END;

--Vehiculo
CREATE OR REPLACE TRIGGER trg_vehiculo
BEFORE INSERT ON VEHICULO
FOR EACH ROW
BEGIN
  :NEW.Id_vehiculo := seq_vehiculo.NEXTVAL;
END;

--Procedimientos y funciones

--Agendar cita
CREATE OR REPLACE PROCEDURE agendar_cita (p_cedula_cliente IN CLIENTE.Cedula%TYPE, p_nombre IN CLIENTE.Nombre%TYPE, p_apellido IN CLIENTE.Apellido%TYPE, p_correo IN CLIENTE.Correo%TYPE,
p_celular IN CLIENTE.Celular%TYPE, p_fecha_cita IN CITA.Fecha_cita%TYPE, p_hora_cita IN CITA.Hora_cita%TYPE)
IS
    v_clienteExistente NUMBER := 0;
    v_reservado NUMBER := 0;

BEGIN
    --Verificamos que el cliente si existe en la base de datos
    SELECT COUNT(*) INTO v_clienteExistente
    FROM CLIENTE
    WHERE Cedula = p_cedula_cliente;
    
    --Cuando el cliente no existe, lo insertamos en la BD
    IF v_clienteExistente = 0 THEN
        INSERT INTO CLIENTE (Cedula, Nombre, Apellido, Correo, Celular)
        VALUES (p_cedula_cliente, p_nombre, p_apellido, p_correo, p_celular);
    END IF;
    
    --Verificamos si se tienen citas programadas para la fecha y hora solicitada
    SELECT COUNT(*) INTO v_reservado
    FROM CITA
    WHERE Fecha_cita = p_fecha_cita AND Hora_cita = p_hora_cita;
    
    --Si la cita esta reservada, mandamos un mensaje
    IF v_reservado > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ya hay una cita programa para esta fecha y hora');
    END IF;
    
    --Si no hay cita, la insertamos
    INSERT INTO CITA (Id_cita, Cedula_cliente, Fecha_cita, Hora_cita, Estado)
    VALUES (seq_cita.NEXTVAL, p_cedula_cliente, p_fecha_cita, p_hora_cita, 'Activa');
    
END;


--Aplazar una cita
CREATE OR REPLACE PROCEDURE aplazar_cita(p_id_cita IN CITA.Id_cita%TYPE, p_nueva_fecha IN CITA.Fecha_cita%TYPE, p_nueva_hora IN CITA.Hora_cita%TYPE)
IS
    v_citaExistente NUMBER := 0;
    
BEGIN
    --Verificamos si la cita existe
    SELECT COUNT(*) INTO v_citaExistente
    FROM CITA
    WHERE Id_cita = p_id_cita;
    
    --Si la cita no existe lanzamos una excepcion
    IF v_citaExistente = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    --Si la cita existe, la actualizamos con la nueva fecha y hora
    UPDATE CITA
    SET Fecha_cita = p_nueva_fecha,
        Hora_cita = p_nueva_hora,
        Estado = 'Aplazada'
    WHERE Id_cita = p_id_cita;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe una cita para el ID que se ingreso');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en la base de datos: ' || SQLERRM);
END;




