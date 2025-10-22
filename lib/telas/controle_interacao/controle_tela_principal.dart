import 'package:cosmoview/dominio/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControleTelaPrincipal{
  Usuario usuario;
  List<DocumentSnapshot>? document_itens;


  ControleTelaPrincipal(this.usuario);

}