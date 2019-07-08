//package base;

// Lo pongo comentado para que no dé fallo el linter.

public class A {
    protected int protegidoA = 0;
}

public class B extends A {
    protected int protegidoB = 1;
}

// ────────────────────────────────────────────────────────────────────────────────

//import base2.c;

public class D extends C {
    protected int protegidoD = 3;
}

// ────────────────────────────────────────────────────────────────────────────────

//package base2;
//import base.*;

public class C extends B {
    protected int protegidoC = 2;

    public void test () {
        A a = new A();
        //a.protegidoA = 666;
        // No es accedido por herencia ni por el mecanismo de protegidos especial

        B b = new B();
        //b.protegidoB = 666;
        // Lo mismo que arriba


        // Sin embargo, en los dos siguientes sí
        C local1 = new C();
        local1.protegidoA = 555;

        D local2 = new D();
        local2.protegidoB = 555;

        // Cuidado, que el atributo tiene que estar definido en las superclases.
        // No podemos acceder a uno inferior:

        //local3.protegidoD;

        this.protegidoA = 777;
    }
}
