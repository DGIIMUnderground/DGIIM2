module Simple_geometria

#
# ────────────────────────────────────────────────── INTERFACES Y ENUMERADOS ─────
#

    module Form_type
        CIRCULO   = :cirulo
        CUADRADO  = :cuadrado
        TRIANGULO = :triangulo
    end



    class Angulo
        def initialize l1, l2, angulo
            @lado1  = l1
            @lado2  = l2
            @angulo = angulo
        end

        def self.new_specific_angle angulo
            new(0, 0, angulo)
        end

        def self.new_angle_given_sides l1, l2
            ang = Math.atan2(l2, l1)
            new(l1, l2, ang)
        end

        private_class_method :new
        attr_reader :lado1, :lado2, :angulo

        def to_s
            "Lados: " + @lado1.to_s + " " + @lado2.to_s + ". Ángulo: " + @angulo.to_s
        end
    end



    class Geometria
        def area
            0.0
        end

        def angulos
            Array.new
        end

        def perimetro
            0.0
        end
    end


#
# ──────────────────────────────────────────────────── I ──────────
#   :::::: C L A S E S : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────
#


    class Forma < Geometria
        @@formas_creadas = 0

        def initialize
            super()
            @tipo
        end

        attr_reader :tipo

        def self.formas_creadas
            @@formas_creadas
        end
    end



    class Cuadrado < Forma
        def initialize l
            super()
            @tipo = Form_type::CUADRADO
            @@formas_creadas += 1
            @lado = l
        end

        attr_reader :lado

        def area
            @lado * @lado
        end

        def perimetro
            @lado * 4
        end

        def angulos
            angulos = Array.new
            4.times(angulos.push(Angulo.new_angle_given_sides(@lado, @lado)))
            angulos
        end

        def to_s
            "Datos del cuadrado:" + "\n\tLado: " + @lado.to_s + "\n\tÁrea: " + area().to_s + "\n\tPerímetro: " + perimetro().to_s
        end
    end



    class Triangulo < Forma
        def initialize l1, l2, l3
            super()
            @tipo = Form_type::TRIANGULO
            @@formas_creadas += 1

            @lado1 = l1
            @lado2 = l2
            @lado3 = l3

            @angulos = Array.new

            calcular_angulos()
        end

        attr_reader :lado1, :lado2, :lado3, :angulos

        def calcular_angulos
            angulos.push(Angulo.new_angle_given_sides(@lado1, @lado2))
            angulos.push(Angulo.new_angle_given_sides(@lado2, @lado3))
            angulos.push(Angulo.new_angle_given_sides(@lado1, @lado3))
        end

        def perimetro
            @lado1 + @lado2 + @lado3
        end

        def area
            sp = perimetro()/2
            Math.sqrt(sp * (sp - @lado1) * (sp - @lado2) * (sp - @lado3))
        end

        def to_s
            salida = "Datos del triángulo: \n\tLados: " + @lado1.to_s + " " + @lado2.to_s + " " + @lado3.to_s + "\n\tÁrea: " + area().to_s + "\n\tPerímetro: " + perimetro().to_s + "\n\tÁngulos: ["
            @angulos.each{ |angulo|
                salida += angulo.to_s + ", "
            }
            salida += "]"

            salida
        end
    end

    class Circulo < Forma
        def initialize radio
            super()
            @@formas_creadas += 1
            @tipo = Form_type::CIRCULO
            @radio = radio
        end

        attr_reader :radio

        def area
            Math::PI * @radio * @radio
        end

        def perimetro
            2 * Math::PI * @radio
        end

        def to_s
            "Datos del círculo:" + "\n\tRadio: " + @radio.to_s + "\n\tÁrea: " + area().to_s + "\n\tPerímetro: " + perimetro().to_s
        end
    end

    circulo   = Circulo.new(1)
    cuadrado  = Cuadrado.new(3)
    triangulo = Triangulo.new(3, 4, 5)

    puts circulo.area()
    puts Forma.formas_creadas

    puts triangulo, "\n"
    puts cuadrado, "\n"
    puts circulo
end