/* DANGER ZONE */
class UserException inherits Exception {}

class Empleado {
	var property profesion = espia
	const property habilidades = []
	var property salud = 100
	
	method agregarHabilidades(_habilidades) = habilidades.addAll(_habilidades)
	
	method recibirDanio(danio){
		salud -= danio
	}
	
	method estaIncapacitado() = salud < profesion.saludCritica()
	
	method puedeUsar(habilidad) = habilidades.contains(habilidad)
	
	method cumplirMision(mision){
		if(not self.puedeCumplirMision(mision) ){
			throw new UserException(message="No puedo cumplir mision")
		}
		
		self.completarMision(mision, mision.peligrosidad())
		
	}
	
	method completarMision(mision, danio) {
		
		self.recibirDanio(danio)
		if(self.sobrevive()){
			profesion.completarMision(mision, self)
		}
		
	}
	
	method puedeCumplirMision(mision) = mision.habilidadesNecesarias().all({habilidad => self.puedeUsar(habilidad)})
	
	method sobrevive() = salud > 0
	
}

class Jefe inherits Empleado {
	const property subordinados = []
	
	method subordinadosTienen(habilidad) = subordinados.any({empleado => empleado.puedeUsar(habilidad)})
	
	override method puedeUsar(habilidad) = super(habilidad) && self.subordinadosTienen(habilidad)
	
}

object espia {
	const property saludCritica = 15
	
	method completarMision(mision, empleado){
		const habilidadesDesconocidas = mision.habilidadesNecesarias().filter({habilidad => not empleado.puedeUsar(habilidad)})
		empleado.agregarHabilidades(habilidadesDesconocidas)
	}
}

class Oficinista {
	var property estrellas = 0
	
	method saludCritica() = 40 - 5*estrellas
	
	method completarMision(mision, empleado){
		estrellas += 1
		if(estrellas == 3) empleado.profesion(espia)
	}
}

class Mision {
	const property habilidadesNecesarias = []
	const property peligrosidad
}

class Equipo {
	const property integrantes = []
	
	method puedeCumplirMision(mision) = integrantes.any({integrante => integrante.puedeCumplirMision(mision)})
	
	method cumplirMision(mision){
		integrantes.map({integrante => integrante.completarMision(mision, mision.peligrosidad()/3)})
	}
}