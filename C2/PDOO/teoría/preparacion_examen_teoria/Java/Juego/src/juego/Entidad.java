package juego;

abstract class Entity implements Actions_entity {
    protected Clase_entidad clase;
    protected int vida = 10;
    protected int resistencia = 1;
    protected int ataque = 1;

    protected String nombre;

    Entity(String name, Clase_entidad type, int health, int DPS, int stamina) {
        this.nombre      = name;
        this.clase       = type;
        this.ataque      = DPS;
        this.vida        = health;
        this.resistencia = stamina;
    }

    public int atacar () {
        //System.out.println("Al ataqueeeerl");
        return ataque;
    }

//
// ────────────────────────────────────────────────────────────────── GETTERS ─────
//

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @return the vida
     */
    public int getVida() {
        return vida;
    }

    /**
     * @param vida the vida to set
     */
    public void setVida(int vida) {
        this.vida = vida;
    }

    public void getStats() {
        System.out.println("Nombre: " + this.nombre);
        System.out.println("Clase: " + this.clase);

        System.out.println("Vida: " + this.vida);
        System.out.println("Ataque: " + this.ataque);
        System.out.println("Resistencia: " + this.resistencia);
    }
}