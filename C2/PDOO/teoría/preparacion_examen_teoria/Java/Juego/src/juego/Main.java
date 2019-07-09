/*
    Crear un mini juego en Java con las siguientes características:

    - En el juego voy a necesitar gestionar información sobre
    escenarios, enemigos y un único jugador

    Un enemigo tiene nombre, clase(guerrero, mago o pícaro),
    vida, resistencia y ataque. Además, tiene las siguientes habilidades:
        Saltar, correr, atacar y hacerse el muerto

    Un jugador tiene nombre, clase(guerrero, mago o pícaro),
    vida, resistencia y ataque. Además, tiene las siguientes habilidades:
        Saltar, correr, atacar, furia, hacerse el muerto

        Un escenario tiene una lista de enemigos y un jugador.

    Se pide crear un menú donde creamos los enemigos que queramos
    y los vamos a almacenar en el escenario.

    Además, un jugador también se almacena en el escenario.
    Crear la opción necesaria para que el jugador se enfrente
    a un enemigo que sea seleccionado.
*/


package juego;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("Crea un héroe:");
        Scanner sc = new Scanner(System.in);

        System.out.println("Nombre: ");
        String name = sc.next();

        System.out.println("Tipo: te lo asigno guerrero porque me da palo implementarlo\n\n");
        Clase_entidad clase = Clase_entidad.GUERRERO;

        Heroe   heroe    = new Heroe(name, clase, 20, 5, 2);
        Enemigo enemigo1 = new Enemigo("Slime");
        Enemigo enemigo2 = new Enemigo ("Goomba");
        Enemigo enemigo3 = new Enemigo ("Cunico");

        Escenario escenario = new Escenario(heroe);
        escenario.addEnemigo(enemigo1);
        escenario.addEnemigo(enemigo2);
        escenario.addEnemigo(enemigo3);

        escenario.combatir();
        escenario.combatir();
        escenario.combatir();
        escenario.combatir();
        escenario.combatir();
        escenario.combatir();

        sc.close();
    }
}