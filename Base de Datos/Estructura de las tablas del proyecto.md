- Documento
-- idPersona
-- idTipoDocumento
-- idSolicitud
-- idPaisDestino
-- idSolicitante
-- idFactura
-- idEstado
-- idTGR
-- FechaSolicitud
-- FechaEntrega

- Apostilla
-- idApostilla
-- idDocumento
-- fechaPresentacion
-- fechaRetiro
-- IdEstado

- Estado
-- idEstado
-- Descripcion

- Persona
-- IdPersona
-- dni
-- nom1
-- nom2
-- ape1
-- ape2
-- idGenero
-- IdPais

- TipoDocumento
-- idTipoDocumento
-- idInstitucion
-- Descripcion
-- costo

- TGR
-- idTGR
-- Descripcion
-- Estado

- Institucion
-- idInstitucion
-- Descripcion

- Solicitud
-- idSolicitud
-- idPersona
-- IdSolicitante
-- FechaSolicitud
-- FechaEntrega
-- idPaisDestino
-- idFactura

- Genero
-- idGenero
-- Descripcion

- Pais
-- idPais
-- Descripcion

- Solicitante
-- IdSolicitante
-- nombre
-- apellido

- DetalleFactura
-- idDetalle
-- idFactura
-- idSolicitud
-- monto

- Factura
-- idFactura
-- fecha
-- monto

- Envio 
-- idEnvio
-- idDocumento
-- lugarDestino
-- NumGuia