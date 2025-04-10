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

ALTER TRIGGER trg_cita DISABLE;

--Vehiculo
CREATE OR REPLACE TRIGGER trg_vehiculo
BEFORE INSERT ON VEHICULO
FOR EACH ROW
BEGIN
  :NEW.Id_vehiculo := seq_vehiculo.NEXTVAL;
END;

ALTER TRIGGER trg_vehiculo DISABLE;

--Procedimientos y funciones

--Agendar cita
CREATE OR REPLACE PROCEDURE agendar_cita (p_cedula_cliente IN CLIENTE.Cedula%TYPE, p_nombre IN CLIENTE.Nombre%TYPE, p_apellido IN CLIENTE.Apellido%TYPE, p_correo IN CLIENTE.Correo%TYPE,
p_celular IN CLIENTE.Celular%TYPE, p_fecha_cita IN CITA.Fecha_cita%TYPE, p_hora_cita IN CITA.Hora_cita%TYPE, p_id_cita OUT CITA.Id_cita%TYPE, p_fechaCita OUT CITA.Fecha_cita%TYPE, p_horaCita OUT CITA.Hora_cita%TYPE)
IS
    v_clienteExistente NUMBER := 0;
    v_reservado NUMBER := 0;
    v_idCita CITA.Id_cita%TYPE;

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
    WHERE Fecha_cita = p_fecha_cita 
          AND Hora_cita = p_hora_cita
          AND Estado IN ('Activa', 'Aplazada');
    
    --Si la cita esta reservada, mandamos un mensaje
    IF v_reservado > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ya hay una cita programa para esta fecha y hora');
    END IF;
    
    SELECT seq_cita.NEXTVAL INTO v_idCita FROM DUAL;
    
    --Si no hay cita, la insertamos
    INSERT INTO CITA (Id_cita, Cedula_cliente, Fecha_cita, Hora_cita, Estado)
    VALUES (v_idCita, p_cedula_cliente, p_fecha_cita, p_hora_cita, 'Activa');
    
    --Para devolver el id de la cita
    p_id_cita := v_idCita;
    p_fechaCita := p_fecha_cita;
    p_horaCita := p_hora_cita;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Ocurrio un error al guardar la cita' || SQLERRM);
    
END;


--Aplazar una cita
CREATE OR REPLACE PROCEDURE aplazar_cita(p_id_cita IN CITA.Id_cita%TYPE, p_nueva_fecha IN CITA.Fecha_cita%TYPE, p_nueva_hora IN CITA.Hora_cita%TYPE, p_fecha_final OUT CITA.Fecha_cita%TYPE, p_hora_final OUT CITA.Hora_cita%TYPE)
IS
    v_citaExistente NUMBER := 0;
    v_ocupada       NUMBER := 0;
    
BEGIN
    --Verificamos si la cita existe
    SELECT COUNT(*) INTO v_citaExistente
    FROM CITA
    WHERE Id_cita = p_id_cita;
    
    --Si la cita no existe lanzamos una excepcion
    IF v_citaExistente = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    --Verificamos que la nueva fecha no este ocupada
    SELECT COUNT(*) INTO v_ocupada
    FROM CITA
    WHERE Fecha_cita = p_nueva_fecha
          AND Hora_cita = p_nueva_hora
          AND Estado IN ('Activa', 'Aplazada')
          AND Id_cita != p_id_cita;
         
    --Si la fecha y hora estan ocupadas lanzamos una excepcion      
    IF v_ocupada > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'La nueva fecha y hora estan reservadas');
    END IF;
    
    --Si la cita existe, la actualizamos con la nueva fecha y hora
    UPDATE CITA
    SET Fecha_cita = p_nueva_fecha,
        Hora_cita = p_nueva_hora,
        Estado = 'Aplazada'
    WHERE Id_cita = p_id_cita;
    
    --Para devolver los nuevos valores
    p_fecha_final := p_nueva_fecha;
    p_hora_final := p_nueva_hora;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe una cita para el ID que se ingreso');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en la base de datos: ' || SQLERRM);
END;


--Cancelar cita
CREATE OR REPLACE PROCEDURE cancelar_cita(p_id_cita IN CITA.Id_cita%TYPE)
IS
    v_citaExistente NUMBER := 0;
BEGIN
    -- AQUI VEMOS SI SE VERIFICA EL VALOR
    SELECT COUNT(*) INTO v_citaExistente
    FROM CITA
    WHERE Id_cita = p_id_cita;

    --AQUI LANZAMOS UNA EXCEPTION 
    IF v_citaExistente = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    -- AQUI PASAMOSEL ESTADO DE LA CITA A CANCELADAA
    UPDATE CITA
    SET Estado = 'Cancelada'
    WHERE Id_cita = p_id_cita;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe una cita con el ID ingresado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al cancelar la cita: ' || SQLERRM);
END;

--Bloques anonimos

--Agendar cita
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_id_cita CITA.Id_cita%TYPE;
    v_fecha CITA.Fecha_cita%TYPE;
    v_hora  CITA.Hora_cita%TYPE;
BEGIN
    agendar_cita(
        p_cedula_cliente => '&Cedula',
        p_nombre         => '&nombre',
        p_apellido       => '&apellido',
        p_correo         => '&correo',
        p_celular        => '&celular',
        p_fecha_cita     => TO_DATE('&fecha', 'YYYY-MM-DD'),
        p_hora_cita      => '&hora',
        p_id_cita        => v_id_cita,
        p_fechaCita      => v_fecha,
	      p_horaCita       => v_hora
    );

    DBMS_OUTPUT.PUT_LINE('Cita registrada exitosamente');
    DBMS_OUTPUT.PUT_LINE('Numero de cita: ' || v_id_cita);
    DBMS_OUTPUT.PUT_LINE('Fecha de cita: ' || v_fecha);
    DBMS_OUTPUT.PUT_LINE('Hora de cita: ' || v_hora);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error: ' || SQLERRM);
END;

--Aplazar cita
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_id_cita     CITA.Id_cita%TYPE := &Id_cita;
    v_nueva_fecha CITA.Fecha_cita%TYPE;
    v_nueva_hora  CITA.Hora_cita%TYPE;
BEGIN
    aplazar_cita(
        p_id_cita => v_id_cita,
        p_nueva_fecha => TO_DATE('&Nueva_fecha', 'YYYY-MM-DD'),
        p_nueva_hora => '&Nueva_hora',
        p_fecha_final => v_nueva_fecha,
        p_hora_final  => v_nueva_hora
    );

    DBMS_OUTPUT.PUT_LINE('Cita aplazada exitosamente');
    DBMS_OUTPUT.PUT_LINE('Numero de cita: ' || v_id_cita);
    DBMS_OUTPUT.PUT_LINE('Nueva fecha: ' || v_nueva_fecha);
    DBMS_OUTPUT.PUT_LINE('Nueva cita: ' || v_nueva_hora);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error: ' || SQLERRM);
END;

--Cancelar cita
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    v_id_cita CITA.Id_cita%TYPE := &Id_cita; 
BEGIN
    cancelar_cita(p_id_cita => v_id_cita);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrio un error:' || SQLERRM);
END;
