import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Alterado para super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Define a fonte Inter
        useMaterial3: true, // Usa o Material Design 3
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key}); // Alterado para super.key

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  // Lista que representa o tabuleiro do jogo.
  // Cada elemento pode ser '', 'X' ou 'O'.
  List<String> _board = List.filled(9, '');
  // Indica o jogador atual. 'X' começa.
  String _currentPlayer = 'X';
  // Contador de jogadas para detectar empates.
  int _moveCount = 0;
  // Indica se o jogo terminou.
  bool _gameEnded = false;
  // Mensagem de status do jogo (ex: "X Venceu!", "Empate!").
  String _gameStatus = 'Vez do Jogador X';

  @override
  void initState() {
    super.initState();
    _resetGame(); // Garante que o jogo comece limpo.
  }

  // Reinicia o estado do jogo para um novo começo.
  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _moveCount = 0;
      _gameEnded = false;
      _gameStatus = 'Vez do Jogador X';
    });
  }

  // Lida com o toque em uma célula do tabuleiro.
  void _onCellTapped(int index) {
    // Se a célula já estiver preenchida ou o jogo tiver terminado, não faz nada.
    if (_board[index] != '' || _gameEnded) {
      return;
    }

    setState(() {
      _board[index] = _currentPlayer; // Preenche a célula com o jogador atual.
      _moveCount++; // Incrementa o contador de jogadas.

      // Verifica se há um vencedor ou um empate após a jogada.
      if (_checkWinner()) {
        _gameEnded = true;
        _gameStatus = 'Jogador $_currentPlayer Venceu!';
        _showResultModal(_gameStatus); // Exibe o modal de resultado.
      } else if (_moveCount == 9) {
        _gameEnded = true;
        _gameStatus = 'Empate!';
        _showResultModal(_gameStatus); // Exibe o modal de resultado.
      } else {
        // Alterna para o próximo jogador.
        _currentPlayer = (_currentPlayer == 'X' ? 'O' : 'X');
        _gameStatus = 'Vez do Jogador $_currentPlayer';
      }
    });
  }

  // Verifica todas as condições de vitória (linhas, colunas, diagonais).
  bool _checkWinner() {
    // Condições de vitória (índices do tabuleiro)
    final List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6], // Diagonais
    ];

    for (var condition in winConditions) {
      // Verifica se os três índices da condição têm o mesmo jogador e não estão vazios.
      if (_board[condition[0]] != '' &&
          _board[condition[0]] == _board[condition[1]] &&
          _board[condition[1]] == _board[condition[2]]) {
        return true; // Há um vencedor.
      }
    }
    return false; // Não há vencedor.
  }

  // Exibe um modal com o resultado do jogo.
  void _showResultModal(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // O modal só fecha ao tocar no botão.
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Fim de Jogo!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade700,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey.shade600,
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o modal.
                  _resetGame(); // Reinicia o jogo.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Jogar Novamente',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Retorna a cor do texto para 'X' ou 'O'
  Color _getPlayerColor(String player) {
    return player == 'X' ? Colors.red.shade400 : Colors.blue.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text(
          'Jogo da Velha',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
        elevation: 8,
        toolbarHeight: 70,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Exibe o status atual do jogo.
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _gameStatus,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Pega o menor valor entre largura e altura disponíveis
                  double boardSize = (constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight) * 0.9;
                  return SizedBox(
                    width: boardSize,
                    height: boardSize,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: 9, // 9 células no tabuleiro.
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 colunas.
                        crossAxisSpacing: 10.0, // Espaçamento horizontal entre as células.
                        mainAxisSpacing: 10.0, // Espaçamento vertical entre as células.
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => _onCellTapped(index), // Chama a função ao tocar na célula.
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0), // Cantos arredondados.
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.shade200.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _board[index], // Conteúdo da célula ('X', 'O' ou '').
                                style: TextStyle(
                                  fontSize: 70, // Tamanho grande para 'X' e 'O'.
                                  fontWeight: FontWeight.bold,
                                  color: _getPlayerColor(_board[index]), // Cor baseada no jogador.
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Botão para reiniciar o jogo.
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 7,
                  shadowColor: Colors.blueGrey.shade200,
                ),
                child: const Text(
                  'Reiniciar Jogo',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
