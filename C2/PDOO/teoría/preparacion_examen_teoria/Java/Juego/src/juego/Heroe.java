package juego;

public class Heroe extends Entity {
    public Heroe (String name) {
        super (name, null, 10, 1, 1);
    }

    public Heroe (String name, Clase_entidad type, int health, int DPS, int stamina) {
        super(name, type, health, DPS, stamina);
    }

    public void furia() {
        System.out.println("ESTOY HECHO UNA FURIA AAAAAAAH");
    }

    void level_up () {
        this.ataque      += 5;
        this.resistencia += 6;
        this.vida        += 10;

        System.out.println("¡Has subido de nivel!");
        getStats();
    }
}