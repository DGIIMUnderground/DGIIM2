package juego;

interface Actions_entity {
    default public void saltar() {
        System.out.println("YAHOOO");
    }

    default public void correr() {
        System.out.println("NIOOOOM");
    }

    default public void hacerse_el_muerto () {
        System.out.println("F");
    }

    public int atacar ();
}