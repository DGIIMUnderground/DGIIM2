package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class TestP1 {

    public static void main(String[] args) {
        Loot botin;
        ShieldBooster pEscudo;
        Weapon arma;
        Dice dado;
        SuppliesPackage suministros;
        int i;
        
        arma=new Weapon("Rayo", WeaponType.LASER, 0);
        dado=new Dice();
        pEscudo=new ShieldBooster("Ligero", 3.5f, 0);
        botin= new Loot(1,1,1,1,1);
        suministros=new SuppliesPackage(3.0f, 50f, 3.5f);
        
        System.out.format("\nTipo de arma: %s\n", arma.getType());
        System.out.format("\nUsos del arma: %d\n", arma.getUses());
        System.out.format("\nPoder del arma: %f\n", arma.power());
        
        System.out.format("\nShieldBoost: %f\n", pEscudo.getBoost());
        System.out.format("\nUses: %f\n", pEscudo.getUses());
        
        System.out.format("\nSuministros obtenidos: %d\n", botin.getNSupplies());
        System.out.format("\nNumero de armas obtenidas: %d\n", botin.getNWeapons());
        System.out.format("\nNumero de escudos obtenidos: %d\n", botin.getNShields());
        System.out.format("\nNumero de medallas obtenidas: %d\n", botin.getNMedals());
        System.out.format("\nNumero de hangares obtenidos: %d\n", botin.getNHangars());

        System.out.format("\nPontenciador del escudo: %f\n", pEscudo.getBoost());
        System.out.format("\nUsos del escudo: %f\n", pEscudo.getUses());
        
        System.out.format("\nPoder del arma obtenida en los suministros: %f\n", suministros.getAmmoPower());
        System.out.format("\nPoder del escudo obtenido en los suministros: %f\n", suministros.getShieldPower());
        System.out.format("\nGasolina obtenida en los suministros: %f\n", suministros.getFuelUnits());
        
        
        for(i = 0; i < 100; i++){
            dado=new Dice();
            System.out.format("\nNumero de hangares: %d\n", dado.initWithNHangars());
            System.out.format("\nNumero de armas: %d\n", dado.initWithNWeapons());
            System.out.format("\nNumero de escudos: %d\n", dado.initWithNShields());
            System.out.format("\nComienzo: %d\n", dado.whoStarts(2));
            System.out.format("\nPrimer disparo: %s\n", dado.firstShot());
            System.out.format("\n¿Se ha movido?: %b\n", dado.spaceStationMoves(i/100));
        }
        
    }
    
}
