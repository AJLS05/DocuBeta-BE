-- Scripts para crear tablas
CREATE DATABASE IF NOT EXISTS ProyectoBD;
USE ProyectoBD;

CREATE TABLE Persona (
    idPersona INT PRIMARY KEY AUTO_INCREMENT,
    nom1 VARCHAR(20),
    nom2 VARCHAR(20),
    ape1 VARCHAR(20),
    ape2 VARCHAR(20),
    dni VARCHAR(20) UNIQUE,
    idGenero INT,
    idPais INT,
    FOREIGN KEY (idGenero) REFERENCES Genero(idGenero),
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

CREATE TABLE Estado (
    idEstado INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(20)
);

CREATE TABLE Genero (
    idGenero INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(20)
);

CREATE TABLE Pais (
    idPais INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(20)
);

CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(20),
    ape VARCHAR(20),
    nomUsuario VARCHAR(20) UNIQUE,
    contraseña VARCHAR(20)
);

CREATE TABLE Solicitud (
    idSolicitud INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT,
    fechaSolicitud DATE,
    fechaEntrega DATE,
    idPaisDestino INT,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idPaisDestino) REFERENCES Pais(idPais)
);

CREATE TABLE TipoDocumento (
    idTipoDocumento INT PRIMARY KEY AUTO_INCREMENT,
    idInstitucion INT,
    descripcion VARCHAR(30),
    costo DOUBLE,
    FOREIGN KEY (idInstitucion) REFERENCES Institucion(idInstitucion),
    FOREIGN KEY (idTGR) REFERENCES TGR(idTGR)
);

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
    FOREIGN KEY (idSolicitante) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idFactura) REFERENCES Factura(idFactura),
    FOREIGN KEY (idTGR) REFERENCES TGR(idTGR),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

CREATE TABLE Apostilla (
    idApostilla INT PRIMARY KEY AUTO_INCREMENT,
    idDocumento INT,
    fechaPresentacion DATE,
    idEstado INT,
    FOREIGN KEY (idDocumento) REFERENCES Documento(idDocumento),
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

CREATE TABLE Institucion (
    idInstitucion INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(20)
);

CREATE TABLE TGR (
    idTGR INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(20),
    idEstado INT,
    costo DOUBLE,
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

CREATE TABLE Factura (
    idFactura INT PRIMARY KEY AUTO_INCREMENT,
    CAI VARCHAR(20),
    fechaLim DATE,
    nom VARCHAR(20),
    puntoE VARCHAR(20),
    docFisc VARCHAR(10),
    cantidad INT,
    rangoAut INT,
    idEstado INT,
    FOREIGN KEY (idEstado) REFERENCES Estado(idEstado)
);

CREATE TABLE DetalleFactura (
    idDetalle INT PRIMARY KEY AUTO_INCREMENT,
    idFactura INT,
    idSolicitud INT,
    monto VARCHAR(30),
    FOREIGN KEY (idFactura) REFERENCES Factura(idFactura),
    FOREIGN KEY (idSolicitud) REFERENCES Solicitud(idSolicitud)
);

CREATE TABLE Envio (
    idEnvio INT PRIMARY KEY AUTO_INCREMENT,
    idDocumento INT,
    lugarDestino INT,
    numGuia VARCHAR(20),
    FOREIGN KEY (idDocumento) REFERENCES Documento(idDocumento),
    FOREIGN KEY (lugarDestino) REFERENCES Pais(idPais)
);

CREATE TABLE SolicitudXPersona (
    idSoliXPer INT PRIMARY KEY AUTO_INCREMENT,
    idPersona INT,
    idSolicitud INT,
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona),
    FOREIGN KEY (idSolicitud) REFERENCES Solicitud(idSolicitud)
);

-- Scripts para rellenar tablas por defecto
Insert Into Estado (idEstado, descripcion) VALUES (1, 'Pendiente');
Insert Into Estado (idEstado, descripcion) VALUES (2, 'En Proceso');
Insert Into Estado (idEstado, descripcion) VALUES (3, 'En Apostilla');
Insert Into Estado (idEstado, descripcion) VALUES (4, 'Escaneado');
Insert Into Estado (idEstado, descripcion) VALUES (5, 'Enviado');
Insert Into Estado (idEstado, descripcion) VALUES (6, 'Pagado');

Insert Into Genero (idGenero, descripcion) VALUES (1, 'Masculino');
Insert Into Genero (idGenero, descripcion) VALUES (2, 'Femenino');
Insert Into Genero (idGenero, descripcion) VALUES (3, 'Helicoptero Apache');

Insert Into Pais (idPais, descripcion) VALUES (1, 'Espana');
Insert Into Pais (idPais, descripcion) VALUES (2, 'Estados Unidos');
Insert Into Pais (idPais, descripcion) VALUES (3, 'Mexico');
Insert Into Pais (idPais, descripcion) VALUES (4, 'Colombia');

Insert Into Institucion (idInstitucion, descripcion) VALUES (1, 'Corte Suprema de Justicia');
Insert Into Institucion (idInstitucion, descripcion) VALUES (2, 'Resgistro Nacional de las Personas');
Insert Into Institucion (idInstitucion, descripcion) VALUES (3, 'Secretaria de Seguridad');
Insert Into Institucion (idInstitucion, descripcion) VALUES (4, 'Direccion Nacional de Vialidad y Transporte');

Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (1, 2, 'Partida de Nacimiento', 100);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (2, 1, 'Antecedentes Penales', 50);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (3, 3, 'Antecedentes Policiales', 75);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 2, 'Acta de Solteria', 150);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 2, 'Acta de Parentezco', 150);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 2, 'Acta de Defunsion', 150);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 2, 'Copia de Folio', 150);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 4, 'Historial de Transito', 150);
Insert Into TipoDocumento (idTipoDocumento, idInstitucion, descripcion, costo) VALUES (4, 2, 'Acta de matrimonio', 150);

