
package UI;

enum Command {
  EXIT                   (0, "Salir del juego"),
  GOBACK                (-1, "Volver al menú anterior"),
  SHOWENEMY              ( 2, "  Mostrar Información del Enemigo"),
  NEXTTURN               ( 3, "Siguiente Turno"),
  MOUNTWEAPONS           (47, "   Montar Armas"),
  MOUNTSHIELDS           (48, "   Montar Potenciadores de Escudo"),
  DISCARDWEAPONS         (57, "Descartar Elementos Montados: Armas"),
  DISCARDSHIELDS         (58, "Descartar Elementos Montados: Potenciadores de Escudo"),
  DISCARDWEAPONSINHANGAR (67, "Descartar del Hangar: Armas"),
  DISCARDSHIELDSINHANGAR (68, "Descartar del Hangar: Potenciadores de Escudo"),
  DISCARDHANGAR          (69, "Descartar del Hangar: Hangar Completo"),
  COMBAT                 ( 1, "¡¡¡ C O M B A T I R !!!"),
  SHOWSTATION            (-11, "  Mostrar Información de la Estación Espacial"),
  NEXTTURNALLOWED       (-10, "");
  ;
  
  public final int menu;
  public final String text;
  
  private Command (int aValue, String aText) {
    this.menu = aValue;
    this.text = aText;
  }
}
