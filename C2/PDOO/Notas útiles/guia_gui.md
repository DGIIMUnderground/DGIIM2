# Creación de una GUI en java con netbeans

En este tutorial se explicará **bien** como se crea la GUI del ejemplo dado en PDOO.

Para ello se recomienda eliminar el paquete `View` del proyecto e ir sigueindo los pasos que se indiquen.

- Creamos el paquete `View` y un archivo *View* con los métodos `public void updateView ();` `public void showView ();`

- Creamos el paquete `View.GUI`, donde se crea una clase *MainWindow* formada por un `JFrame` y se modifica para que implemente `View` (se debe importar la clase).

- Se hará la clase *singleton* añadiendo:

  ```java
  private static MainWindow instance = null;
  
  public static MainWindow getInstance () {
          if (instance == null) {
              instance = new MainWindow();
          }
      return instance;
  }
  ```

- Eliminamos el método *main* de nuestra clase.

- Se añade el siguiente código en el constructor por defecto que hay creado para cuando se cierre la ventana (hay que importar el controlador):

  ```java
  setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
          addWindowListener(new java.awt.event.WindowAdapter() {
              @Override
              public void windowClosing(java.awt.event.WindowEvent e) {
                  Controller.getInstance().finish(0);
              }
          });
  ```

- Implementamos los métodos de *View*, dejando *updateView* en blanco y *showView* sólo contendrá: `setVisible(true);`

- Para leer los nombres se añade una clase *JDialog* llamada *NamesCapture* (añadir también un array de nombres y el método para devolverlos getNames y un constructor que reciba de *MainWindow*), se añade a la clase *View* un método para hacer la lectura, por ejemplo `public ArrayList<String> getNames();` y se implementa en *MainWindow* con el código:

  ```java
  public ArrayList<String> getNames() {
      NamesCapture namesCapt = new NamesCapture(this);
      return namesCapt.getNames();
  }
  // Otro código en NamesCapture
  ArrayList<String> getNames() {
          setVisible(true);
          return names;
  }
  // Otro código en NamesCapture
  public NamesCapture(MainWindow parent) {
         super(parent,true);
         names = new ArrayList();
         initComponents();
         setLocationRelativeTo (null);
         // setTitle (parent.getAppName());
         addWindowListener(new java.awt.event.WindowAdapter() {
             @Override
             public void windowClosing(java.awt.event.WindowEvent e) {
                 System.exit(0);
             }
         });
          
  }
  
  ```

- En este punto podemos añadir dos funciones más `getAppname` y `confirmExitMessage` a la vista e implementarlas como siempre en *MainWindow*.

  ```java
  @Override //Se añade el atributo de instancia appName
      public String getAppName() {
          return appName;
      }
  // Otro código, hay que incluir import javax.swing.JOptionPane;
  @Override
      public boolean confirmExitMessage() {
          return (JOptionPane.showConfirmDialog(this, "¿Estás segur@ que deseas salir?", getAppName(), JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION);
  }
  ```

  Para el diálogo se deben diseñar gráficamente las etiquetas (en este caso 2) y campos de texto editables (2) y ponerles nombres, los que se usarán luego para referenciarlos. Se añade un botón, click derecho, eventos, action, action performed y ahí se añade el código, en este caso (con campos campo1 y campo2). Es recomendable quitar el texto de los campos o se queda ahí y poner las cosas de un tamaño adecuado.

  ```java
   private void botonempezarActionPerformed(java.awt.event.ActionEvent evt) {                                             
                  //TODO add your handling code here:
          names.clear();
          names.add (nombre1.getText());
          names.add (nombre2.getText());
          dispose();
      }  
  ```

  - Para hacer cada vista se hacen de interior a exterior.

### Vista de cheques

Se ponen dos etiquetas, una para el importe y otra la cantidad de dinero. A la clase se le añade un atributo bool que indique si está seleccionado o no `selected`. Al constructor se le añade que se vuelva opaco si se selecciona, e sdecir `setOpaque(selected)`.

Podemos cambiar el texto de una etiqueta como `cantidaddinero.setText(Integer.toString(bc.getAmount()));`.

Añadimos además un método que nos modifique la vista (setAmount) y otro que nos indique si está seleccionado, además con botón derecho, ratón, ratón pulsado actualizamos la selección y opacidad. Siempre que se modifique el aspecto debemos hacer `repaint()`.

### Vista de persona

Al hacer la persona como el número de cheques va variano aparte de `repaint` hay que hacer un `revalidate`.

Ponemos el JPanel como siempre, luego en la barra de navegacion boton derecho y enclose in scroll bar y LISTO.

Para poner el scroll bar hay que poner en el jpanel elflow layout, para eso boton derecho en el jpanel (en la ventana de la izquierda donde se listan), layout y flowlayout (default).

### Vista principal

En el editor gráfico se pondrá un Jpanel para poner la información y luego en el código se le asignará la identidad (que será un atributo de instancia de clase).

Además con los botones se llamará al controlador para que le pida al modelo las acciones correspondientes.