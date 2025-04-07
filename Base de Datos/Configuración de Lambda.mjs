//Importar libreria de promesas porque si no truena
import mysql from 'mysql2/promise';

const connectionConfig = {
  //Conexion porque si no truena
  host: 'db-hndocs-rds.cm14acywm1xy.us-east-1.rds.amazonaws.com',
  user: 'admin',
  password: 'adminhndocs',
  database: 'HnDocs'
};

export const handler = async (event) => {
  console.log('Evento recibido:', JSON.stringify(event));
  const connection = await mysql.createConnection(connectionConfig);
  const { httpMethod, resource } = event;

  try {
    const { httpMethod, path } = event;
    
    /*SELECT * FROM Documento
    WHERE idEstado = (SELECT idEstado FROM Estado WHERE Descripcion = 'Apostillado'); */
    if (path === '/GetApostillados' && httpMethod === 'GET') {
      const [rows] = await connection.query(
        'CALL ObtenerDocumentosApostillados()'
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Documentos apostillados obtenidos correctamente', resultado: rows })
      };
    }
    /*DECLARE idUsuario INT;
    SELECT idUsuario INTO idUsuario
    FROM Usuario
    WHERE nomUsuario = p_nomUsuario AND contraseña = p_contraseña;
    RETURN idUsuario; */
    if (path === '/GetContra' && httpMethod === 'GET') {
      const { p_nomUsuario, p_contrasena } = event.queryStringParameters;
      const [rows] = await connection.query(
        'SELECT ConfirmarContrasena(?, ?) AS resultado',
        [p_nomUsuario, p_contrasena]
      );
      const resultado = rows[0]?.resultado;
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({
          message: 'Parámetros coinciden correctamente',
          resultado: resultado
        }),
      };
    }    
    /*DECLARE total DOUBLE;
    SELECT SUM(Costo) INTO total
    FROM Documento
    WHERE idSolicitud = p_idSolicitud;
    RETURN total; */
    if (path === '/GetCostoSoli' && httpMethod === 'GET') {
      const body = JSON.parse(event.body);
      const {
        p_idSolicitud
      } = body;
      const [rows] = await connection.query(
        'SELECT ObtenerCostoTotalSolicitud(?)',
        [p_idSolicitud]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Costo total de la solicitud obtenido correctamente', resultado: rows })
      };
    }
    /*DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Persona
    WHERE dni = p_dni;
    RETURN existe > 0; */
    if (path === '/GetDNI' && httpMethod === 'GET') {
      const {
        p_dni
      } = event.queryStringParameters;
      const [rows] = await connection.query(
        'SELECT VerificarDniExistente(?)',
        [p_dni]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'DNI obtenido correctamente', resultado: rows })  
      };
    }
    /*SELECT * FROM Documento
    WHERE idEstado = (SELECT idEstado FROM Estado WHERE Descripcion = 'Pendiente'); */
    if (path === '/GetDocsPendientes' && httpMethod === 'GET') {
      const [rows] = await connection.query(
        'CALL ObtenerDocumentosPendientes()'
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Documentos pendientes obtenidos correctamente', resultado: rows })
      };
    }
    /*SELECT d.*
    FROM Documento d
    JOIN Persona p ON d.idPersona = p.idPersona
    WHERE p.dni = p_dni; */
    if (path === '/GetDocumentos' && httpMethod === 'GET') {
      const { p_dni } = event.queryStringParameters;
      const [rows] = await connection.query(
        'CALL ObtenerDocumentosPorDNI(?)',
        [p_dni]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Documento obtenido correctamente', resultado: rows })
      };
    }
    /*DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Usuario
    WHERE email = p_email;
    RETURN existe > 0; */
    if (path === '/GetEmail' && httpMethod === 'GET') {
      const body = JSON.parse(event.body);
      const {
        p_email
      } = body;
      const [rows] = await connection.query(
        'SELECT VerificarEmailExistente(?)',
        [p_email]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Email obtenido correctamente', resultado: rows })
      };
    }
    
    /*SELECT * FROM Documento
    WHERE idEstado = (SELECT idEstado FROM Estado WHERE Descripcion = 'Enviado'); */
    if (path === '/GetEnviados' && httpMethod === 'GET') {
      const [rows] = await connection.query(
        'CALL ObtenerDocumentosEnviados()'
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Documentos enviados obtenidos correctamente', resultado: rows })
      };
    }
    if (path === '/GetGenero' && httpMethod === 'GET') {
      const [rows] = await connection.query('SELECT * FROM HnDocs.Genero;');
      return {
        statusCode: 200,
        headers: {
          //Headers porque sino truena
          'Access-Control-Allow-Origin': '*', 
          'Access-Control-Allow-Headers': 'Content-Type', 
          'Access-Control-Allow-Methods': 'GET, POST', 
        },
        body: JSON.stringify({ message: 'Consulta realizada', rows }
      )
      };
    }
    /*DECLARE totalISV DOUBLE;
    SELECT SUM(ISV) INTO totalISV
    FROM Documento
    WHERE idSolicitud = p_idSolicitud;
    RETURN totalISV; */
    if (path === '/GetISVSoli' && httpMethod === 'GET') {
      const body = JSON.parse(event.body);
      const {
        p_idSolicitud
      } = body;
      const [rows] = await connection.query(
        'SELECT ObtenerISVTotalSolicitud(?)',
        [p_idSolicitud]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'ISV total de la solicitud obtenido correctamente', resultado: rows })
      };
    }
    if (path === '/GetPaises' && httpMethod === 'GET') {
      const [rows] = await connection.query('SELECT * FROM HnDocs.Pais;');
      return {
        statusCode: 200,
        headers: {
          //Headers porque sino truena
          'Access-Control-Allow-Origin': '*', 
          'Access-Control-Allow-Headers': 'Content-Type', 
          'Access-Control-Allow-Methods': 'GET, POST', 
        },
        body: JSON.stringify({ message: 'Consulta de Paises realizada', rows }
      )
      };
    }

    if (path === '/GetRolPorUsuario' && httpMethod === 'GET') {
      const { p_nomUsuario } = event.queryStringParameters;
      const [rows] = await connection.query(
        'SELECT ObtenerRolPorNomUsuario(?)',
        [p_nomUsuario]
      );
      const resultado = rows[0]?.resultado;
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({
          message: 'El rol del usuario es',
          resultado: resultado
        }),
      };
    }
    if (path === '/GetTipoDocumentos' && httpMethod === 'GET') {
      const [rows] = await connection.query('Call ObtenerTipoDocumentos()');
      return {
        statusCode: 200,
        headers: {
          //Headers porque sino truena
          'Access-Control-Allow-Origin': '*', 
          'Access-Control-Allow-Headers': 'Content-Type', 
          'Access-Control-Allow-Methods': 'GET, POST', 
        },
        body: JSON.stringify({ message: 'Consulta de Tipos de Documentos realizada', rows }
      )
      };
    }
    
    /*DECLARE existe BOOLEAN;
    SELECT COUNT(*) INTO existe
    FROM Usuario
    WHERE nomUsuario = p_nomUsuario;
    RETURN existe > 0; */
    if (path === '/GetUsuarioExiste' && httpMethod === 'GET') {
      const body = JSON.parse(event.body);
      const {
        p_nomUsuario
      } = body;
      const [rows] = await connection.query(
        'SELECT VerificarUsuarioExistente(?)',
        [p_nomUsuario]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'NomUsuario obtenido correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Apostilla (idDocumento, fechaPresentacion, idEstado)
    VALUES (p_idDocumento, p_fechaPresentacion, p_idEstado);*/
    if (path === '/PostApostilla' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idDocumento,
        fechaPresentacion,
        idEstado
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarApostilla(?, ?, ?)',
        [idDocumento, fechaPresentacion, idEstado]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Apostilla insertada correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Documento (idPersona, idTipoDocumento, idSolicitud, idPaisDestino, idSolicitante, idFactura, idTGR, idEstado, fechaSoli, fechaEntre)
    VALUES (p_idPersona, p_idTipoDocumento, p_idSolicitud, p_idPaisDestino, p_idSolicitante, p_idFactura, p_idTGR, p_idEstado, p_fechaSoli, p_fechaEntre);*/
    if (path === '/PostDocumento' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idPersona,
        idTipoDocumento,
        idSolicitud,
        idPaisDestino,
        idSolicitante,
        idFactura,
        idTGR,
        idEstado,
        fechaSoli,
        fechaEntre
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarDocumento(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [idPersona, idTipoDocumento, idSolicitud, idPaisDestino, idSolicitante, idFactura, idTGR, idEstado, fechaSoli, fechaEntre]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Documento insertado correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Envio (idDocumento, idEstado, fechaEnvio, fechaRecibido)
    VALUES (p_idDocumento, p_idEstado, p_fechaEnvio, p_fechaRecibido); */
    if (path === '/PostEnvio' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idDocumento,
        idEstado,
        fechaEnvio,
        fechaRecibido
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarEnvio(?, ?, ?, ?)',
        [idDocumento, idEstado, fechaEnvio, fechaRecibido]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Envio insertado correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Factura (idMetodoPago, idUsuario, idEstado, fechaFactura, total, isv)
    VALUES (p_idMetodoPago, p_idUsuario, p_idEstado, p_fechaFactura, p_total, p_isv);*/
    if (path === '/PostFactura' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idMetodoPago,
        idUsuario,
        idEstado,
        fechaFactura,
        total,
        isv,
        idSolicitud
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarFactura(?, ?, ?, ?, ?, ?, ?)',
        [idMetodoPago, idUsuario, idEstado, fechaFactura, total, isv, idSolicitud]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Factura insertada correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Institucion (idInstitucion, Descripcion)
    VALUES (p_idInstitucion, p_Descripcion); */
    if (path === '/PostInstitucion' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idInstitucion,
        Descripcion
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarInstitucion(?, ?)',
        [idInstitucion, Descripcion]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Institucion insertada correctamente', resultado: rows })
      };
    }
    /*INSERT INTO Persona (nom1, nom2, ape1, ape2, dni, idGenero, idPais)
    VALUES (p_nom1, p_nom2, p_ape1, p_ape2, p_dni, p_idGenero, p_idPais);  */
    if (path === '/PostPersona' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        nom1,
        nom2,
        ape1,
        ape2,
        dni,
        idGenero,
        idPais
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarPersona(?, ?, ?, ?, ?, ?, ?)',
        [nom1, nom2, ape1, ape2, dni, idGenero, idPais]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Persona insertada correctamente', resultado: rows })
      };
    }
    if (path === '/PostSolicitud' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idUsuario,
        fechaSolicitud,
        fechaEntrega,
        idPais,
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarSolicitud(?, ?, ?, ?)',
        [idUsuario, fechaSolicitud, fechaEntrega, idPais]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Solicitud insertada correctamente', resultado: rows })
      };
    }
    /*INSERT INTO TGR (idTGR, Descripcion, idEstado, Costo)
    VALUES (p_idTGR, p_Descripcion, p_idEstado, p_Costo); */
    if (path === '/PostTGR' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        p_idTGR,
        p_Descripcion,
        p_idEstado,
        p_Costo
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarTGR(?, ?, ?, ?)',
        [p_idTGR, p_Descripcion, p_idEstado, p_Costo]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'TGR insertado correctamente', resultado: rows })
      };
    }
    /*INSERT INTO TipoDocumento (idTipoDocumento, idInstitucion, idTGR, Descripcion, Costo, ISV)
    VALUES (p_idTipoDocumento, p_idInstitucion, p_idTGR, p_Descripcion, p_Costo, p_ISV);*/
    if (path === '/PostTipoDocumento' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
      const {
        idTipoDocumento,
        idInstitucion,
        idTGR,
        Descripcion,
        Costo,
        ISV
      } = body;
      const [rows] = await connection.query(
        'CALL InsertarTipoDocumento(?, ?, ?, ?, ?, ?)',
        [idTipoDocumento, idInstitucion, idTGR, Descripcion, Costo, ISV]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Tipo de documento insertado correctamente', resultado: rows })
      };
    }
    if (path === '/PostUsuario' && httpMethod === 'POST') {
      const body = JSON.parse(event.body);
    
      const {
        nom,
        ape,
        nomUsuario,
        email,
        contrasena,
        idRol,
        telefono
      } = body;
    
      const [rows] = await connection.query(
        'CALL InsertarUsuario(?, ?, ?, ?, ?, ?, ?)',
        [nom, ape, nomUsuario, email, contrasena, idRol, telefono]
      ); 
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Usuario insertado correctamente', resultado: rows })
      };
    }
    /*UPDATE Documento
    SET idEstado = p_idEstado
    WHERE idDocumento = p_idDocumento; */
    if (path === '/PutEstadoDocumento' && httpMethod === 'PUT') {
      const body = JSON.parse(event.body);
      const {
        idDocumento,
        idEstado
      } = body;
      const [rows] = await connection.query(
        'CALL ActualizarEstadoDocumento(?, ?)',
        [idDocumento, idEstado]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST, PUT',
        },
        body: JSON.stringify({ message: 'Documento actualizado correctamente', resultado: rows })
      };
    }
    /* UPDATE Solicitud
    SET idEstado = p_idEstado
    WHERE idSolicitud = p_idSolicitud; 
    NO IMPLEMENTADA*/
    if (path === '/PutEstadoSolicitud' && httpMethod === 'PUT') {
      const body = JSON.parse(event.body);
      const {
        idSolicitud,
        fechaEntrega
      } = body;
      const [rows] = await connection.query(
        'CALL ActualizarEstadoSolicitud(?, ?)',
        [idSolicitud, fechaEntrega]
      );
      return {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST',
        },
        body: JSON.stringify({ message: 'Solicitud actualizada correctamente', resultado: rows })
      };
    }
    return {
      statusCode: 404,
      headers: {
        'Access-Control-Allow-Origin': '*', 
      },
      body: JSON.stringify({ message: 'Ruta no encontrada ' })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      headers: {
        'Access-Control-Allow-Origin': '*', 
      },
      body: JSON.stringify({ message: 'Error interno del servidor en lambda' })
    };
  }
};