class Pack {
  const duracionEnDias
  const precioBase
  const beneficios = #{}
  const coordinador
  
  method duracionEnDias() = duracionEnDias
  
  method precioBase() = precioBase
  
  method beneficios() = beneficios
  
  method coordinador() = coordinador
  
  method addBeneficioOpcional(beneficio) {
    beneficios.add(beneficio)
  }
  
  method precioFinal() = precioBase + beneficios.filter(
    { beneficio => beneficio.estaVigente() }
  ).sum(0, { beneficio => beneficio.costo() })
  
  method esPremium()
}

class PackNacional inherits Pack {
  const provinciaDestino
  const actividadesIncluidas = #{}
  
  method provinciaDestino() = provinciaDestino
  
  method actividadesIncluidas() = actividadesIncluidas
  
  method agregarActividad(nuevaActividad) = actividadesIncluidas.add(
    nuevaActividad
  )
  
  override method esPremium() = (self.duracionEnDias() > 10) && self.coordinador().altamenteCalificado()
}

class PackInternacional inherits Pack {
  const paisDestino
  const cantidadEscalas
  const esLugarDeInteres
  
  method paisDestino() = paisDestino
  
  method cantidadEscalas() = cantidadEscalas
  
  method esLugarDeInteres() = esLugarDeInteres
  
  override method precioFinal() = super().precioFinal() * 1.2
  
  override method esPremium() = (self.esLugarDeInteres() && (self.duracionEnDias() > 20)) && (self.cantidadEscalas() == 0)
}

class PackProvincial inherits PackNacional {
  const cantidadDeCiudadesAvisitar
  
  method cantidadDeCiudadesAvisitar() = cantidadDeCiudadesAvisitar
  
  override method esPremium() = ((self.actividadesIncluidas().size() >= 4) && (self.cantidadDeCiudadesAvisitar() > 5)) && (self.beneficios().filter(
    { beneficio => beneficio.estaVigente() }
  ).size() >= 3)
  
  override method precioFinal() = if (self.esPremium())
                                    super().precioFinal() * 1.05
                                  else super().precioFinal()
}

class Coordinador {
  const cantidadDeViajesRealizados
  const aniosDeExperiencia
  var rol
  const estaMotivado
  
  method estaMotivado() = estaMotivado
  
  method rol() = rol
  
  method cambiarDeRol(nuevoRol) {
    if (!#{guia, asistenteLogistico, acompaniante}.contains(nuevoRol))
      self.error("El rol especificado es inválido")
    rol = nuevoRol
  }
  
  method cantidadDeViajesRealizados() = cantidadDeViajesRealizados
  
  method aniosDeExperiencia() = aniosDeExperiencia
  
  method altamenteCalificado() = (cantidadDeViajesRealizados > 20) && rol.cumpleCondicion(
    self
  )
}

object guia {
  method cumpleCondicion(coordinador) = coordinador.estaMotivado()
}

object asistenteLogistico {
  method cumpleCondicion(coordinador) = coordinador.aniosDeExperiencia() >= 3
}

object acompaniante {
  method cumpleCondicion(coordinador) = true
}

class BeneficiosOpcionales {
  const tipo
  const costo
  const estaVigente
  
  method tipo() = tipo
  
  method costo() = costo
  
  method estaVigente() = estaVigente
}