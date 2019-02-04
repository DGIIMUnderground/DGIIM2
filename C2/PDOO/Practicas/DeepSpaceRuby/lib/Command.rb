#encoding: utf-8

module UI

module Command
  class Option
    attr_reader :menu, :text
    def initialize (aValue, aText)
      @menu = aValue
      @text = aText
    end
  end

  EXIT = Option.new(0, "Salir del juego")
  GOBACK = Option.new(-1, "Volver al menú anterior")
  SHOWENEMY = Option.new( 2, "  Mostrar Información del Enemigo")
  NEXTTURN = Option.new( 3, "Siguiente Turno")
  MOUNTWEAPONS = Option.new(47, "   Montar Armas")
  MOUNTSHIELDS = Option.new(48, "   Montar Potenciadores de Escudo")
  DISCARDWEAPONS = Option.new(57, "Descartar Elementos Montados: Armas")
  DISCARDSHIELDS = Option.new(58, "Descartar Elementos Montados: Potenciadores de Escudo")
  DISCARDWEAPONSINHANGAR = Option.new(67, "Descartar del Hangar: Armas")
  DISCARDSHIELDSINHANGAR = Option.new(68, "Descartar del Hangar: Potenciadores de Escudo")
  DISCARDHANGAR = Option.new(69, "Descartar del Hangar: Hangar Completo")
  COMBAT = Option.new( 1, "¡¡¡ C O M B A T I R !!!")
  SHOWSTATION = Option.new(-11, "  Mostrar Información de la Estación Espacial")
  NEXTTURNALLOWED = Option.new(-10, "")

end # Command

end # UI

