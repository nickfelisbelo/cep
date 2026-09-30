import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/pessoa.dart';
import '../services/viacep.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final nomeController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  final ViaCepService viaCepService = ViaCepService();
  final PessoaService pessoaService = PessoaService();

  bool buscandoCep = false;
  String ultimoCepConsultado = '';

  Future<void> pesquisarCep(String valor) async {
    final cep = valor.replaceAll(RegExp(r'\D'), '');

    if (cep.length != 8 || cep == ultimoCepConsultado) {
      return;
    }

    ultimoCepConsultado = cep;

    setState(() {
      buscandoCep = true;
      ruaController.text = '...';
      bairroController.text = '...';
      cidadeController.text = '...';
      estadoController.text = '...';
    });

    try {
      final dados = await viaCepService.buscarCep(cep);

      if (mounted) {
        setState(() {
          ruaController.text = dados['logradouro'] ?? '';
          bairroController.text = dados['bairro'] ?? '';
          cidadeController.text = dados['localidade'] ?? '';
          estadoController.text = dados['uf'] ?? '';
        });
      }
    } catch (e) {
      limparEndereco();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('não encontrado')
                  ? 'CEP não encontrado.'
                  : 'Não foi possível consultar o CEP.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          buscandoCep = false;
        });
      }
    }
  }

  void limparEndereco() {
    setState(() {
      ruaController.clear();
      bairroController.clear();
      cidadeController.clear();
      estadoController.clear();
    });
  }

  Future<void> salvar() async {
    if (nomeController.text.isEmpty ||
        cepController.text.isEmpty ||
        numeroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha Nome, CEP e Número.',
          ),
        ),
      );

      return;
    }

    final pessoa = Pessoa(
      nome: nomeController.text,
      cep: cepController.text,
      rua: ruaController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
      numero: numeroController.text,
      complemento: complementoController.text,
    );

    await pessoaService.salvarPessoa(pessoa);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pessoa cadastrada com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget campo(
    String label,
    TextEditingController controller, {
    bool editavel = true,
    TextInputType? tipo,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: editavel,
        keyboardType: tipo,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastre-se',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            campo(
              'Nome',
              nomeController,
            ),
            campo(
              'CEP',
              cepController,
              tipo: TextInputType.number,
              onChanged: pesquisarCep,
            ),
            campo(
              'Rua',
              ruaController,
              editavel: false,
            ),
            campo(
              'Bairro',
              bairroController,
              editavel: false,
            ),
            campo(
              'Cidade',
              cidadeController,
              editavel: false,
            ),
            campo(
              'Estado',
              estadoController,
              editavel: false,
            ),
            campo(
              'Número',
              numeroController,
              tipo: TextInputType.number,
            ),
            campo(
              'Complemento',
              complementoController,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: buscandoCep ? null : salvar,
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
