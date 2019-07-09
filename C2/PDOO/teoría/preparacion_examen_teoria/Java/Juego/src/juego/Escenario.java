package juego;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;


class Escenario {
    Heroe heroe;
    ArrayList<Enemigo> enemigos = new ArrayList<>();
    private static int PROB_LUCHAR_HEROE = 6;

    public Escenario() {}
    public Escenario(Heroe MC) {
        heroe = MC; // Main character
    }

    public void addEnemigo (Enemigo nuevo) {
        enemigos.add(nuevo);
    }

    public void combatir () {
        int indice = ThreadLocalRandom.current().nextInt(0, enemigos.size());
        Enemigo enemigo = enemigos.get(indice);

        System.out.println("\nLucharás contra " + enemigo.getNombre());

        Entity atacante;
        Entity atacado;

        if (enemigo.getVida() <= heroe.atacar() && ThreadLocalRandom.current().nextInt(0, 10) < Escenario.PROB_LUCHAR_HEROE) {
            atacante = heroe;
            atacado  = enemigo;
        }
        else {
            atacante = enemigo;
            atacado  = heroe;
        }

        atacado.setVida(atacado.getVida() - atacante.atacar());
        System.out.println(atacante.getNombre() + " hace " + atacante.atacar() + " de daño. Vida restante de " + atacado.getNombre() + ": " + atacado.getVida());

        if (atacado.getVida() <= 0) {
            atacado.hacerse_el_muerto();
        }

        if (atacante == heroe) {
            System.out.println("\nPAPAPAPA PA PAAAA PAPAPAAAAAAM");
            heroe.level_up();
        }
    }
}