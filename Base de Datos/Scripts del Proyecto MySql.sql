
-- Scripts para Crear la base de datos
CREATE DATABASE HnDocs;
USE HnDocs;

-- Tabla: Pais
CREATE TABLE Pais (
    idPais INT PRIMARY KEY,
    Descripcion VARCHAR(20) NOT NULL
);

-- Tabla: Genero
CREATE TABLE Genero (
    idGenero INT PRIMARY KEY,
    Descripcion VARCHAR(20) NOT NULL
);

-- Tabla: Rol
CREATE TABLE Rol (
    idRol INT PRIMARY KEY,
    Descripcion VARCHAR(20) NOT NULL
);

-- Tabla: MetodoPago
CREATE TABLE MetodoPago (
    idMetodoPago INT PRIMARY KEY,
    Descripcion VARCHAR(35) NOT NULL
);

-- Tabla: Estado
CREATE TABLE Estado (
    idEstado INT PRIMARY KEY,
    Descripcion VARCHAR(20) NOT NULL
);

-- Tabla: Institucion
CREATE TABLE Institucion (
    idInstitucion INT PRIMARY KEY,
    Descripcion VARCHAR(35) NOT NULL
);

-- Tabla: TGR
CREATE TABLE TGR (
    idTGR INT PRIMARY KEY,
    Descripcion VARCHAR(20) NOT NULL,
    idEstado INT,
    Costo DOUBLE,
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

-- Tabla: TipoDocumento

CREATE TABLE TipoDocumento (
    idTipoDocumento INT PRIMARY KEY,
    idInstitucion INT,
    idTGR INT,
    Descripcion VARCHAR(50),
    Costo DOUBLE,
    ISV DOUBLE,
    FOREIGN KEY (idInstitucion) REFERENCES Institucion(idInstitucion),
    FOREIGN KEY (idTGR) REFERENCES TGR(idTGR)
);

-- Tabla: Persona
CREATE TABLE Persona (
    idPersona INT PRIMARY KEY AUTO_INCREMENT,
    nom1 VARCHAR(20),
    nom2 VARCHAR(20),
    ape1 VARCHAR(20),
    ape2 VARCHAR(20),
    dni VARCHAR(20),
    idGenero INT,
    idPais INT,
    FOREIGN KEY (idGenero) REFERENCES Genero(idGenero),
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

-- Tabla: Usuario
CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(20),
    ape VARCHAR(20),
    nomUsuario VARCHAR(20) UNIQUE,
    email VARCHAR(30) UNIQUE,
    contraseña VARCHAR(255),
    idRol INT,
    telefono VARCHAR(20),
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

-- Tabla: BitacoraAcceso
CREATE TABLE BitacoraAcceso (
    idUsuario INT,
    fechaAcceso DATE,
    PRIMARY KEY (idUsuario, fechaAcceso),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla: Solicitud
CREATE TABLE Solicitud (
    idSolicitud INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT,
    fechaSolicitud DATE,
    fechaEntrega DATE,
    idPaisDestino INT,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idPaisDestino) REFERENCES Pais(idPais)
);


-- Tabla: Factura
CREATE TABLE Factura (
    idFactura INT PRIMARY KEY AUTO_INCREMENT,
    idMetodoPago INT,
    idUsuario INT,
    idEstado INT,
    fechaFactura DATE,
    total DOUBLE,
    isv DOUBLE,
    FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);
-- Agregar la columna idSolicitud a la tabla Factura
ALTER TABLE Factura ADD idSolicitud INT;
-- Agregar la clave foranea a la tabla Factura
ALTER TABLE Factura ADD FOREIGN KEY (idSolicitud) REFERENCES Solicitud(idSolicitud);
-- Tabla: Documento
CREATE TABLE Documento (
    idDocumento INT PRIMARY KEY AUTO_INCREMENT,
    idPersona INT,
    idTipoDocumento INT,
    idSolicitud INT,
    idPaisDestino INT,
    idSolicitante INT,
    idFactura INT,
    idTGR INT,
    idEstado INT,
    fechaSoli DATE,
    fechaEntre DATE,
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona),
    FOREIGN KEY (idTipoDocumento) REFERENCES TipoDocumento(idTipoDocumento),
    FOREIGN KEY (idSolicitud) REFERENCES Solicitud(idSolicitud),
    FOREIGN KEY (idPaisDestino) REFERENCES Pais(idPais),
    FOREIGN KEY (idSolicitante) REFERENCES Persona(idPersona),
    FOREIGN KEY (idFactura) REFERENCES Factura(idFactura),
    FOREIGN KEY (idTGR) REFERENCES TGR(idTGR),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

-- Tabla: SolicitudXPersona
CREATE TABLE SolicitudXPersona (
    idSoliXPer INT PRIMARY KEY AUTO_INCREMENT,
    idPersona INT,
    idSolicitud INT,
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona),
    FOREIGN KEY (idSolicitud) REFERENCES Solicitud(idSolicitud)
);

-- Tabla: Apostilla
CREATE TABLE Apostilla (
    idApostilla INT PRIMARY KEY AUTO_INCREMENT,
    idDocumento INT,
    fechaPresentacion DATE,
    idEstado INT,
    FOREIGN KEY (idDocumento) REFERENCES Documento(idDocumento),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

-- Tabla: Envio
CREATE TABLE Envio (
    idEnvio INT PRIMARY KEY AUTO_INCREMENT,
    idDocumento INT,
    idEstado INT,
    fechaEnvio DATE,
    fechaRecibido DATE,
    FOREIGN KEY (idDocumento) REFERENCES Documento(idDocumento),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

-- Procedimiento Almacenados, funciones y triggers
DELIMITER //
-- Procedimiento para insertar un nuevo usuario
CREATE PROCEDURE InsertarUsuario(
    IN p_nom VARCHAR(20),
    IN p_ape VARCHAR(20),
    IN p_nomUsuario VARCHAR(20),
    IN p_email VARCHAR(30),
    IN p_contraseña VARCHAR(255),
    IN p_idRol INT,
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO Usuario (nom, ape, nomUsuario, email, contraseña, idRol, telefono)
    VALUES (p_nom, p_ape, p_nomUsuario, p_email, p_contraseña, p_idRol, p_telefono);
END //

-- Procedimiento para insertar una nueva persona
CREATE PROCEDURE InsertarPersona(
    IN p_nom1 VARCHAR(20),
    IN p_nom2 VARCHAR(20),
    IN p_ape1 VARCHAR(20),
    IN p_ape2 VARCHAR(20),
    IN p_dni VARCHAR(20),
    IN p_idGenero INT,
    IN p_idPais INT
)
BEGIN
    INSERT INTO Persona (nom1, nom2, ape1, ape2, dni, idGenero, idPais)
    VALUES (p_nom1, p_nom2, p_ape1, p_ape2, p_dni, p_idGenero, p_idPais);
END //
-- Procedimiento para insertar una nueva factura
CREATE PROCEDURE InsertarFactura(
    IN p_idMetodoPago INT,
    IN p_idUsuario INT,
    IN p_idEstado INT,
    IN p_fechaFactura DATE,
    IN p_total DOUBLE,
    IN p_isv DOUBLE
)
BEGIN
    INSERT INTO Factura (idMetodoPago, idUsuario, idEstado, fechaFactura, total, isv)
    VALUES (p_idMetodoPago, p_idUsuario, p_idEstado, p_fechaFactura, p_total, p_isv);
END //
-- Procedimiento para insertar un nuevo tipo de documento
CREATE PROCEDURE InsertarTipoDocumento(
    IN p_idTipoDocumento INT,
    IN p_idInstitucion INT,
    IN p_idTGR INT,
    IN p_Descripcion VARCHAR(50),
    IN p_Costo DOUBLE,
    IN p_ISV DOUBLE
)
BEGIN
    INSERT INTO TipoDocumento (idTipoDocumento, idInstitucion, idTGR, Descripcion, Costo, ISV)
    VALUES (p_idTipoDocumento, p_idInstitucion, p_idTGR, p_Descripcion, p_Costo, p_ISV);
END //
-- Procedimiento para insertar una nueva institucion
CREATE PROCEDURE InsertarInstitucion(
    IN p_idInstitucion INT,
    IN p_Descripcion VARCHAR(35)
)
BEGIN
    INSERT INTO Institucion (idInstitucion, Descripcion)
    VALUES (p_idInstitucion, p_Descripcion);
END //

-- Procedimiento para insertar una nueva solicitud
CREATE PROCEDURE InsertarSolicitud(
    IN p_idUsuario INT,
    IN p_fechaSolicitud DATE,
    IN p_fechaEntrega DATE,
    IN p_idPaisDestino INT
)
BEGIN
    INSERT INTO Solicitud (idUsuario, fechaSolicitud, fechaEntrega, idPaisDestino)
    VALUES (p_idUsuario, p_fechaSolicitud, p_fechaEntrega, p_idPaisDestino);
END //

-- Procedimiento para insertar un nuevo documento
CREATE PROCEDURE InsertarDocumento(
    IN p_idPersona INT,
    IN p_idTipoDocumento INT,
    IN p_idSolicitud INT,
    IN p_idPaisDestino INT,
    IN p_idSolicitante INT,
    IN p_idFactura INT,
    IN p_idTGR INT,
    IN p_idEstado INT,
    IN p_fechaSoli DATE,
    IN p_fechaEntre DATE
)
BEGIN
    INSERT INTO Documento (idPersona, idTipoDocumento, idSolicitud, idPaisDestino, idSolicitante, idFactura, idTGR, idEstado, fechaSoli, fechaEntre)
    VALUES (p_idPersona, p_idTipoDocumento, p_idSolicitud, p_idPaisDestino, p_idSolicitante, p_idFactura, p_idTGR, p_idEstado, p_fechaSoli, p_fechaEntre);
END //

-- Procedimiento para insertar una nueva apostilla
CREATE PROCEDURE InsertarApostilla(
    IN p_idDocumento INT,
    IN p_fechaPresentacion DATE,
    IN p_idEstado INT
)
BEGIN
    INSERT INTO Apostilla (idDocumento, fechaPresentacion, idEstado)
    VALUES (p_idDocumento, p_fechaPresentacion, p_idEstado);
END //

-- Procedimiento para insertar un nuevo envio
CREATE PROCEDURE InsertarEnvio(
    IN p_idDocumento INT,
    IN p_idEstado INT,
    IN p_fechaEnvio DATE,
    IN p_fechaRecibido DATE
)
BEGIN
    INSERT INTO Envio (idDocumento, idEstado, fechaEnvio, fechaRecibido)
    VALUES (p_idDocumento, p_idEstado, p_fechaEnvio, p_fechaRecibido);
END //

-- Procedimiento para insertar un nuevo TGR
CREATE PROCEDURE InsertarTGR(
    IN p_idTGR INT,
    IN p_Descripcion VARCHAR(20),
    IN p_idEstado INT,
    IN p_Costo DOUBLE
)
BEGIN
    INSERT INTO TGR (idTGR, Descripcion, idEstado, Costo)
    VALUES (p_idTGR, p_Descripcion, p_idEstado, p_Costo);
END //

-- Trigger para insertar un nuevo usuario en la bitacora de acceso
CREATE TRIGGER InsertarBitacoraAcceso
AFTER INSERT ON Usuario
FOR EACH ROW
BEGIN
    INSERT INTO BitacoraAcceso (idUsuario, fechaAcceso)
    VALUES (NEW.idUsuario, CURDATE());
END //

-- Procedimiento para actualizar el estado de un documento al ser apostillado
CREATE PROCEDURE ActualizarEstadoDocumento(
    IN p_idDocumento INT,
    IN p_idEstado INT
)
BEGIN
    UPDATE Documento
    SET idEstado = p_idEstado
    WHERE idDocumento = p_idDocumento;
END //

-- Procedimiento para actualizar el estado de una solicitud
CREATE PROCEDURE ActualizarEstadoSolicitud(
    IN p_idSolicitud INT,
    IN p_fechaEntrega INT
)
BEGIN
    UPDATE Solicitud
    SET fechaEntrega = p_fechaEntrega
    WHERE idSolicitud = p_idSolicitud;
END //
DROP PROCEDURE ActualizarEstadoSolicitud;
-- Procedimiento para actualizar el estado de un envio
-- Sin implementar
CREATE PROCEDURE ActualizarEstadoEnvio(
    IN p_idEnvio INT,
    IN p_idEstado INT
)
BEGIN
    UPDATE Envio
    SET idEstado = p_idEstado
    WHERE idEnvio = p_idEnvio;
END //

-- Procedimiento para obtener todos los documento de un dni
DROP PROCEDURE ObtenerDocumentosPorDNI;
//
CREATE PROCEDURE ObtenerDocumentosPorDNI(
	IN p_dni varchar(20)
)
BEGIN
    SELECT d.idDocumento, d.fechaSoli, d.fechaEntre, d.idSolicitud,
           p.nom1 AS Nombre1, p.nom2 AS Nombre2, p.ape1 AS Apellido1, p.ape2 AS Apellido2,
           td.Descripcion AS TipoDocumento, e.Descripcion AS Estado
    FROM Documento d
    JOIN Persona p ON d.idPersona = p.idPersona
    JOIN TipoDocumento td ON d.idTipoDocumento = td.idTipoDocumento
    JOIN Estado e ON d.idEstado = e.idEstado
    WHERE p.dni = p_dni;
END //
DROP PROCEDURE ObtenerDocumentosPorDNI;
-- Procedimiento para obtener los documentos con estado pendiente
CREATE PROCEDURE ObtenerDocumentosPendientes()
BEGIN
    SELECT d.idDocumento, d.fechaSoli, d.fechaEntre, d.idSolicitud,
           p.nom1 AS Nombre1, p.nom2 AS Nombre2, p.ape1 AS Apellido1, p.ape2 AS Apellido2,
           td.Descripcion AS TipoDocumento, e.Descripcion AS Estado
    FROM Documento d
    JOIN Persona p ON d.idPersona = p.idPersona
    JOIN TipoDocumento td ON d.idTipoDocumento = td.idTipoDocumento
    JOIN Estado e ON d.idEstado = e.idEstado
    WHERE d.idEstado = (SELECT idEstado FROM Estado WHERE Descripcion = 'Pendiente');
END //

-- Procedimiento para obtener los documentos apostillados
CREATE PROCEDURE ObtenerDocumentosApostillados()
BEGIN
    SELECT * FROM Documento d
    JOIN Apostilla a ON d.idDocumento = a.idDocumento;
END //

-- Procedimiento para obtener los documentos apostillados
CREATE PROCEDURE ObtenerTipoDocumentos()
BEGIN
    SELECT * FROM TipoDocumento;
END //

-- Procedimiento para obtener los documentos enviados
CREATE PROCEDURE ObtenerDocumentosEnviados()
BEGIN
    SELECT d.idDocumento, d.fechaSoli, d.fechaEntre, d.idSolicitud,
           p.nom1 AS Nombre1, p.nom2 AS Nombre2, p.ape1 AS Apellido1, p.ape2 AS Apellido2,
           td.Descripcion AS TipoDocumento, e.Descripcion AS Estado
    FROM Documento d
    JOIN Persona p ON d.idPersona = p.idPersona
    JOIN TipoDocumento td ON d.idTipoDocumento = td.idTipoDocumento
    JOIN Estado e ON d.idEstado = e.idEstado
    WHERE d.idEstado = (SELECT idEstado FROM Estado WHERE Descripcion = 'Enviado');
END //
//
-- DROP PROCEDURE ObtenerDocumentosEnviados;
//
DELIMITER //

-- funciones para obtener el costo total de una solicitud
CREATE FUNCTION ObtenerCostoTotalSolicitud(
	p_idSolicitud INT
) RETURNS DOUBLE
READS SQL DATA
BEGIN
    DECLARE total DOUBLE;
    SELECT SUM(costo) INTO total
    FROM Documento d
    JOIN TipoDocumento td ON d.idTipoDocumento = td.idTipoDocumento
    WHERE d.idSolicitud = p_idSolicitud;
    RETURN total;
END //
DROP FUNCTION ObtenerCostoTotalSolicitud;
//
-- Función para obtener el ISV total de una solicitud
DROP FUNCTION ObtenerISVTotalSolicitud;
//
CREATE FUNCTION ObtenerISVTotalSolicitud(
    p_idSolicitud INT
) RETURNS DOUBLE
BEGIN
    DECLARE totalISV DOUBLE;
    SELECT SUM(costo*ISV) INTO totalISV
    FROM Documento d
    JOIN TipoDocumento td ON d.idTipoDocumento = td.idTipoDocumento
    WHERE d.idSolicitud = p_idSolicitud;
    RETURN totalISV;
END //

-- Función para verificar si un usuario existe
CREATE FUNCTION VerificarUsuarioExistente(
    p_nomUsuario VARCHAR(20)
) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Usuario
    WHERE nomUsuario = p_nomUsuario;
    RETURN existe > 0;
END //
-- Función para verificar si un email ya está registrado
CREATE FUNCTION VerificarEmailExistente(
    p_email VARCHAR(30)
) RETURNS BOOLEAN
reads sql data
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Usuario
    WHERE email = p_email;
    RETURN existe > 0;
END //

-- Función para verificar si un DNI ya esta registrado
CREATE FUNCTION VerificarDniExistente(
    p_dni VARCHAR(20)
) RETURNS BOOLEAN
reads sql data
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Persona
    WHERE dni = p_dni;
    RETURN existe > 0;
END // 

-- Función para confirmar la contraseña de un usuario y devolver su ID
CREATE FUNCTION ConfirmarContrasena(
    p_nomUsuario VARCHAR(20),
    p_contraseña VARCHAR(255)
) RETURNS INT
BEGIN
    DECLARE v_idUsuario INT;
    SELECT idUsuario INTO v_idUsuario
    FROM Usuario
    WHERE nomUsuario = p_nomUsuario AND contraseña = p_contraseña;
    RETURN v_idUsuario;
END //
-- Función para obtener el rol de un usuario por su nombre de usuario
CREATE FUNCTION ObtenerRolPorNomUsuario(
    p_nomUsuario VARCHAR(20)
) RETURNS VARCHAR(20)
BEGIN
    DECLARE v_rol VARCHAR(20);
    SELECT idRol INTO v_rol
    FROM Usuario 
    WHERE nomUsuario = p_nomUsuario;
    RETURN v_rol;
END //
-----
-- Inserts de datos base
INSERT INTO Pais (idPais, Descripcion) VALUES
(1, 'Honduras'),
(2, 'Espania'),
(3, 'Colombia'),
(4, 'Mexico'); 
//
-----
INSERT INTO Genero (idGenero, Descripcion) VALUES
(1, 'Masculino'),
(2, 'Femenino'),
(3, 'Helicoptero Apache');
//
-----
INSERT INTO Rol (idRol, Descripcion) VALUES
(1, 'Administrador'),
(2, 'Usuario'),
(3, 'Invitado');
//
-----
INSERT INTO Estado (idEstado, Descripcion) VALUES
(1, 'Pendiente'),
(2, 'Apostillado'),
(3, 'Enviado');
//
-----
//
INSERT INTO Institucion (idInstitucion, Descripcion) VALUES
(1, 'Registro Nacional de las Personas'),
(2, 'Corte Suprema de Justicia'),
(3, 'Secretaria de Seguridad'),
(4, 'Secretaria de Educacion'),
(5, 'DNVT')
//
-----
INSERT INTO TipoDocumento (idTipoDocumento, idInstitucion, Descripcion, Costo, ISV) VALUES
(1, 1,  'Partida de Nacimiento', 30.00, 0.15),
(2, 1,  'Certificado de Matrimonio', 30.00, 0.15),
(3, 1,  'Certificado de Defuncion', 30.00, 0.15),
(4, 2, 'Certificado de Antecedentes Penales', 45.00, 0.15),
(5, 5,  'Record de Transito', 90.00, 0.15),
(6, 3,  'Certificado de Antecedentes Policiales', 90.00, 0.15),
(7, 4,  'Titulo de Educacion media', 90.00, 0.15),
(8, 4,  'Certificacion de estudios', 90.00, 0.15),
(9, 4,  'Constancia de conducta', 90.00, 0.15),
(10, 1,  'Constancia de Estado Civil', 30.00, 0.15),
(11, 1,  'Copia de Folio de Nacimiento', 30.00, 0.15),
(12, 1, 'Certificacion de Expediente Literal', 30.00, 0.15),
(13, 1, 'Incripcion de Nacimiento', 120.00, 0.15),
(14, 1, 'Autentica de firma notarial', 90.00, 0.15),
(15, 1, 'Certificacion de firma de jueces', 90.00, 0.15);
//
-----
INSERT INTO MetodoPago (idMetodoPago, Descripcion) VALUES
(1, 'Efectivo'),
(2, 'Tarjeta de Credito'),
(3, 'Transferencia Bancaria'),
(4, 'Deposito Bancario');
//
-----
INSERT INTO TGR (idTGR, Descripcion, idEstado, Costo) VALUES
(1, 'TGR Acta de Nacimiento', 1, 200.00);
//
-----
INSERT INTO Solicitud (idUsuario, fechaSolicitud, fechaEntrega, idPaisDestino) VALUES
(1, '2023-10-01', '2023-10-15', 2);
//
-----
INSERT INTO Documento (idPersona, idTipoDocumento, idSolicitud, idPaisDestino, idSolicitante, idFactura, idTGR, idEstado, fechaSoli, fechaEntre) VALUES
(1, 1, 1, 2, 1, 1, 1, 1, '2023-10-01', '2023-10-15');
//
-----
INSERT INTO SolicitudXPersona (idPersona, idSolicitud) VALUES
(1, 1);
//
-----
INSERT INTO Apostilla (idDocumento, fechaPresentacion, idEstado) VALUES
(2, '2023-10-01', 1);
//
-----
INSERT INTO Envio (idDocumento, idEstado, fechaEnvio, fechaRecibido) VALUES
(1, 1, '2023-10-01', '2023-10-15');
//
-----
INSERT INTO BitacoraAcceso (idUsuario, fechaAcceso) VALUES
(1, '2023-10-01');
//
-----
INSERT INTO Factura (idMetodoPago, idUsuario, idEstado, fechaFactura, total, isv) VALUES
(1, 1, 1, '2023-10-01', 200.00, 30.00);