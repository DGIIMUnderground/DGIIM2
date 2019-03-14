# coding: utf-8

require_relative 'nave_espacial'

nv = NAVE::Nave.new # se pueden llamar igual
nv2= NAVE::Nave.new 
if nv.validez and  nv.nave_valida # estas dos llamadas son equivalentes
  puts "nave_creada con éxito"
else
  puts "no se ha podido crear la nave"
end
 
puts " El número de recursos disponibles es
     #{NAVE::Nave.getRecursos}
     El número de naves es #{NAVE::Nave.cantidad_naves} "
puts "AAAAAAAA SOY un camicace"
NAVE::Nave.destruccion_flota 3,2,1,0
 
puts " El número de naves es #{NAVE::Nave.cantidad_naves} "
# comprueco si ha funcioando

if nv2.validez  # estas dos llamadas son equivalentes
  puts "No se ha destruido la flota con éxito, fantasssma"
else
  puts "SE HA DESTRUIDO CON ÉXITO :O"
end

if NAVE::Nave.naves?
  puts "Ni siquiera en su cabeza de clase ha destruído algo"
else
  puts ":0 en su cabeza de clase sí lo son"
end


# puts Nave::Nave.n_naves  # ESTO NO SE PUEDE HACER
#Nave::Nave.recursos = 999999999 # igual: UNDEFINED METHOD


