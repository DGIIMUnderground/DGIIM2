package simple_geometria;

import java.util.ArrayList;

// Dejamos las clases y los tipos con visibilidad de paquete (por defecto) por comodidad

//
// ────────────────────────────────────────────────── INTERFACES Y ENUMERADOS ─────
//

    enum form_type {
        CIRCULO,
        CUADRADO,
        TRIANGULO,
    }


    class angulo {
        public double lado1;
        public double lado2;
        public double angulo;

        angulo () {
            lado1 = 0f;
            lado2 = 0f;
            angulo = 0.0;
        }

        angulo (double l1, double l2) {
            lado1 = l1;
            lado2 = l2;

            angulo = Math.atan(lado2/lado1);
        }

        @Override
        public String toString() {
            return "Lados: " + lado1 + " " + lado2 + ". Ángulo: " + angulo;
        }
    }


    interface geometria {
        default public double area () {
            return 0f;
        }

        default public ArrayList<angulo> angulos () {
            return new ArrayList<angulo>();
        }

        default public double perimetro () {
            return 0;
        }

        //public Float altura ();
    }


//
// ──────────────────────────────────────────────────── I ──────────
//   :::::: C L A S E S : :  :   :    :     :        :          :
// ──────────────────────────────────────────────────────────────
//

    abstract class Forma implements geometria {
        protected form_type tipo;
        public static int formas_creadas;

        form_type tipo () {
            return tipo;
        }
    }



    class Cuadrado extends Forma {
        private double lado = 0f;

        Cuadrado () {
            super();
            tipo = form_type.CUADRADO;
            formas_creadas++;
        }

        Cuadrado (double side) {
            super();
            tipo = form_type.CUADRADO;
            lado = side;
            formas_creadas++;
        }

        @Override
        public double area () {
            return lado * lado;
        }

        @Override
        public ArrayList<angulo> angulos () {
            ArrayList<angulo> angulos = new ArrayList<>();

            for (int i = 0; i < 4; i++) {
                angulos.add(new angulo(lado, lado));
            }

            return angulos;
        }

        @Override
        public double perimetro() {
            return 4 * lado;
        }

        /**
         * @return the lado
         */
        public double getLado() {
            return lado;
        }

        @Override
        public String toString() {
            return "Datos del cuadrado:"
                    + "\n\tLado: " + lado
                    + "\n\tÁrea: " + area()
                    + "\n\tPerímetro: " + perimetro();
        }

        // public Float altura () { return lado; }
    }



    class Triangulo extends Forma {
        private double lado1 = 0f;
        private double lado2 = 0f;
        private double lado3 = 0f;

        private ArrayList<angulo> angulos = new ArrayList<>();

        Triangulo (double side1, double side2, double side3) {
            super();
            tipo = form_type.TRIANGULO;
            formas_creadas++;

            lado1 = side1;
            lado2 = side2;
            lado3 = side3;

            calcular_angulos();
        }

        private void calcular_angulos() {
            angulos.add(new angulo(lado1, lado2));
            angulos.add(new angulo(lado2, lado3));
            angulos.add(new angulo(lado1, lado3));
        }

        @Override
        public double perimetro() {
            return lado1 + lado2 + lado3;
        }

        @Override
        public double area() {
            // Fórmula de Heron

            double sp = perimetro() / 2;
            return Math.sqrt(sp * (sp - lado1) * (sp - lado2) * (sp - lado3));
        }

        @Override
        public ArrayList<angulo> angulos() {
            return angulos;
        }

        /**
         * @return the lado1
         */
        public double getLado1() {
            return lado1;
        }

        /**
         * @return the lado2
         */
        public double getLado2() {
            return lado2;
        }

        /**
         * @return the lado3
         */
        public double getLado3() {
            return lado3;
        }

        @Override
        public String toString() {
            String salida =  "Datos del triángulo: \n\tLados: " + lado1 + " " + lado2 + " " + lado3
                        + "\n\tÁrea: " + area()
                        + "\n\tPerímetro: " + perimetro()
                        + "\n\tÁngulos: [";

            for (angulo elemento: angulos)
                salida += elemento.toString() + ", ";

            salida += "]";

            return salida;
        }
    }



    class Circulo extends Forma {
        private double radio = 0;

        Circulo () {
            super();
            formas_creadas++;
            tipo = form_type.CIRCULO;
        }

        Circulo (double radio) {
            super();
            formas_creadas++;
            this.radio = radio;
            tipo = form_type.CIRCULO;
        }

        @Override
        public double area() {
            return Math.PI * radio * radio;
        }

        @Override
        public double perimetro() {
            return 2 * Math.PI * radio;
        }

        /**
         * @return the radio
         */
        public double getRadio() {
            return radio;
        }

        @Override
        public String toString() {
            return "Datos del círculo:"
                    + "\n\tRadio: " + radio
                    + "\n\tÁrea: " + area()
                    + "\n\tPerímetro: " + perimetro();
        }
    }


    class ArrayFormas<T extends Forma> implements geometria {
        private ArrayList<T> figuras;

        ArrayFormas () {
            figuras = new ArrayList<>();
        }

        @Override
        public double area() {
            double resultado = 0;

            for (T elemento: figuras)
                resultado += elemento.area();

            return resultado;
        }

        @Override
        public ArrayList<angulo> angulos() {
            ArrayList<angulo> total = new ArrayList<>();

            for (T elemento: figuras)
                total.addAll(elemento.angulos());

            return total;
        }

        @Override
        public double perimetro() {
            double resultado = 0;

            for (T elemento: figuras)
                resultado += elemento.perimetro();

            return resultado;
        }
    }

//
// ───────────────────────────────────────────────────────────────────── MAIN ─────
//

    public class simple_geometria {
        public static void main(String[] args) {
            Circulo   circulo   = new Circulo(1);
            Cuadrado  cuadrado  = new Cuadrado(3);
            Triangulo triangulo = new Triangulo(3, 4, 5);


            System.out.println(circulo.area());
            System.out.println(Forma.formas_creadas);

            System.out.println(triangulo);
            System.out.println(cuadrado);
            System.out.println(circulo);

            // TODO: practicar polimorfismo, errores de código, probar clase ArrayFormas
        }
    }