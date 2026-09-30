import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pessoa.dart';

class PessoaService {
  static const String chave = 'pessoas';

  Future<List<Pessoa>> listarPessoas() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(chave);

    if (dados == null) {
      return [];
    }

    final lista = jsonDecode(dados);

    return List<Map<String, dynamic>>.from(lista)
        .map((item) => Pessoa.fromJson(item))
        .toList();
  }

  Future<void> salvarPessoa(Pessoa pessoa) async {
    final pessoas = await listarPessoas();

    pessoas.add(pessoa);

    final prefs = await SharedPreferences.getInstance();

    final dados = pessoas.map((pessoa) => pessoa.toJson()).toList();

    await prefs.setString(
      chave,
      jsonEncode(dados),
    );
  }

  Future<void> excluirPessoa(int index) async {
    final pessoas = await listarPessoas();

    if (index < 0 || index >= pessoas.length) {
      return;
    }

    pessoas.removeAt(index);

    final prefs = await SharedPreferences.getInstance();

    final dados = pessoas.map((pessoa) => pessoa.toJson()).toList();

    await prefs.setString(
      chave,
      jsonEncode(dados),
    );
  }
}
