/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package View.GUI;

import java.util.ArrayList;
import View.DeepSpaceView;
import controller.ControllerGrafico;
import javax.swing.JOptionPane;
import deepspace.*;

/**
 *
 * @author ana
 */
public class MainWindow extends javax.swing.JFrame implements DeepSpaceView{

    static ControllerGrafico controller = ControllerGrafico.getInstance();

    StationView station;
    EnemyView enemy;

    private static MainWindow instance = null;
    private String appName = "DeepSpace";
    /**
     * Creates new form MainWindow
     */

    public static MainWindow getInstance () {
        if (instance == null) {
            instance = new MainWindow();
        }
        return instance;
    }

    public MainWindow() {
        initComponents();
        station = new StationView();
        jpStation.add(station);
        enemy = new EnemyView();
        jpEnemy.add(enemy);

        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent e) {
                ControllerGrafico.getInstance().finish(0);
            }
        });
    }

    public String getAppName(){
        return appName;
    }

    @Override
    public boolean confirmExitMessage() {
        return (JOptionPane.showConfirmDialog(this, "¿Estás segur@ que deseas salir?", getAppName(), JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION);
}

    @Override
    public void updateView(){
    station.setStationView(controller.currentStation());
    enemy.setEnemy(controller.currentEnemy());
        GameState gs = controller.getState();
        if(gs == GameState.INIT){
            jpEnemy.setVisible(false);
            jbNextTurn.setEnabled(false);
            jbCombatir.setEnabled(true);
        }
        else if(gs == GameState.BEFORECOMBAT){
            jpEnemy.setVisible(false);
            jbNextTurn.setEnabled(false);
            jbCombatir.setEnabled(true);
        }
        else if (gs== GameState.AFTERCOMBAT){
            jpEnemy.setVisible(true);
            enemy.setEnemy(controller.currentEnemy());
            jbNextTurn.setEnabled(true);
            jbCombatir.setEnabled(false);
        }
        repaint();
    }

    @Override
    public void showView(){
        setVisible(true);
    }

    @Override
    public ArrayList<String> readNamePlayers(){
        NamesCapture namesCapt = new NamesCapture(this);
        return namesCapt.getNames();
    }

    @Override
    public void nextTurnNotAllowedMessage(){
        JOptionPane.showMessageDialog(this, "No puedes avanzar de turno, no has cumplido tu castigo" , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }
    @Override
    public void lostCombatMessage(){
        JOptionPane.showMessageDialog(this, "Has PERDIDO el combate. Cumple tu castigo." , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }
    @Override
    public void escapeMessage(){
        JOptionPane.showMessageDialog(this, "Has logrado escapar. Eres una Gallina Espacial." , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }
    @Override
    public void wonCombatMessage(){
        JOptionPane.showMessageDialog(this, "Has GANADO el combate. Disfruta de tu botín." , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }
    @Override
    public void wonGameMessage(){
        JOptionPane.showMessageDialog(this, "HAS GANADO LA PARTIDA" , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }
    @Override
    public void conversionMessage(){
        JOptionPane.showMessageDialog(this, "Has GANADO el combate. Además te has CONVERTIDO. Disfruta de tu botín" , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }

    @Override
    public void noCombatMessage(){
        JOptionPane.showMessageDialog(this, "No puedes combatir en este momento." , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);
    }

    @Override
    public void wonCombatAndConvertMessage(){
        JOptionPane.showMessageDialog(this, "Has GANADO el combate. Además te has CONVERTIDO. Disfruta de tu botín" , "Deepspace message" , JOptionPane.INFORMATION_MESSAGE);

    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jpStation = new javax.swing.JPanel();
        jpEnemy = new javax.swing.JPanel();
        jbCombatir = new javax.swing.JButton();
        jbNextTurn = new javax.swing.JButton();
        jbSalir = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jbCombatir.setText("Combatir");
        jbCombatir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbCombatirActionPerformed(evt);
            }
        });

        jbNextTurn.setText("Siguiente turno");
        jbNextTurn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbNextTurnActionPerformed(evt);
            }
        });

        jbSalir.setText("Salir");
        jbSalir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbSalirActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addComponent(jpStation, javax.swing.GroupLayout.PREFERRED_SIZE, 598, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jpEnemy, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jbSalir, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jbCombatir, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jbNextTurn))
                        .addGap(0, 225, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jpStation, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jpEnemy, javax.swing.GroupLayout.DEFAULT_SIZE, 445, Short.MAX_VALUE)
                        .addGap(18, 18, 18)
                        .addComponent(jbCombatir, javax.swing.GroupLayout.PREFERRED_SIZE, 62, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jbNextTurn)
                        .addGap(69, 69, 69)
                        .addComponent(jbSalir)
                        .addGap(14, 14, 14)))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jbCombatirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbCombatirActionPerformed
        // TODO add your handling code here:
        controller.combat();
        updateView();
        validate();
    }//GEN-LAST:event_jbCombatirActionPerformed

    private void jbSalirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbSalirActionPerformed
        // TODO add your handling code here:
        controller.finish(0);
    }//GEN-LAST:event_jbSalirActionPerformed

    private void jbNextTurnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbNextTurnActionPerformed
        // TODO add your handling code here:
       controller.nextTurn();
       updateView();
       validate();
    }//GEN-LAST:event_jbNextTurnActionPerformed

    /**
     * @param args the command line arguments
     */

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jbCombatir;
    private javax.swing.JButton jbNextTurn;
    private javax.swing.JButton jbSalir;
    private javax.swing.JPanel jpEnemy;
    private javax.swing.JPanel jpStation;
    // End of variables declaration//GEN-END:variables
}
