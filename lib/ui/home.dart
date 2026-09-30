import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/pessoa.dart';
import 'cadastro.dart';

class HomeScreen extends StatefulWidget {
  final bool temaEscuro;
  final ValueChanged<bool> alterarTema;

  const HomeScreen({
    super.key,
    required this.temaEscuro,
    required this.alterarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PessoaService pessoaService = PessoaService();

  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    final lista = await pessoaService.listarPessoas();

    if (!mounted) return;

    setState(() {
      pessoas = lista;
    });
  }

  Future<void> excluirPessoa(int index) async {
    await pessoaService.excluirPessoa(index);
    await carregarPessoas();
  }

  Future<void> abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroScreen(),
      ),
    );

    await carregarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pessoas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Switch(
            value: widget.temaEscuro,
            onChanged: widget.alterarTema,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pessoas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Cadastrar pessoa'),
              onTap: () async {
                Navigator.pop(context);
                await abrirCadastro();
              },
            ),
          ],
        ),
      ),
      body: pessoas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma pessoa cadastrada',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = pessoas[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      pessoa.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      pessoa.cep,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        excluirPessoa(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
