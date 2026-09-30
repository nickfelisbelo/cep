import 'dart:convert';

import 'package:http/http.dart' as http;

class ViaCepService {
    Future<Map<String, dynamic>> buscarCep(String cep) async {
        final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');

        if (cepLimpo.length != 8) {
            throw Exception('CEP inválido');
        }

        final url = Uri.parse(
            'https://viacep.com.br/ws/$cepLimpo/json/',
        );

        final resposta = await http.get(url);

        if (resposta.statusCode != 200) {
            throw Exception('Erro ao consultar o CEP');
        }

        final dados = jsonDecode(resposta.body);

        if (dados['erro'] == true) {
            throw Exception('CEP não encontrado');
        }

        return dados;
    }
}