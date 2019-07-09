package juego;

class Enemigo extends Entity {
    public Enemigo (String name) {
        super (name, null, 5, 2, 2);
    }

    public Enemigo (String name, Clase_entidad type, int health, int DPS, int stamina) {
        super(name, type, health, DPS, stamina);
    }

    @Override
    public int atacar() {
        //System.out.println("GRRRRAAAAAAAJJJJJ");
        return super.atacar();
    }
}