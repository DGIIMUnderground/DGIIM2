# encoding:utf-8

require_relative 'nave_espacial'

nv  = NAVE::Nave.new # se pueden llamar igual
nv2 = NAVE::Nave.new

if nv.validez and nv.nave_valida # Estas dos llamadas son equivalentes, dado que hemos definido
                                 # un método llamado validez y usado attr_reader
    puts "\n\nnave_creada con éxito"
else
    puts "no se ha podido crear la nave"
end

puts "El número de recursos disponibles es #{NAVE::Nave.getRecursos} \nEl número de naves es #{NAVE::Nave.cantidad_naves}"


puts "AAAAAAAA SOY un camicace"
NAVE::Nave.destruccion_flota 3,2,1,0

puts "El número de naves es #{NAVE::Nave.cantidad_naves}"
#                             ^^^^  ^^^^
#                           modulo  clase


# comprueco si ha funcioando
# Notar la diferencia entre la variable @nave_valida, y la existencia de dos llamadas exactamente igual
if nv2.validez
    puts "No se ha destruido la flota con éxito, fantasssma"
else
    puts "SE HA DESTRUIDO CON ÉXITO :O"
end

if NAVE::Nave.naves?
    puts "Ni siquiera en su cabeza de clase ha destruído algo"
else
    puts ":0 en su cabeza de clase sí lo son"
end

# Lo siguiente no se puede hacer:
# puts Nave::Nave.n_naves
#Nave::Nave.recursos = 999999999 # UNDEFINED METHOD


