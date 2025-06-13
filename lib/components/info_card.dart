import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLink;
  final Function()? onPressed;
  final bool isWarning; // Nova propriedade

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLink,
    this.onPressed,
    this.isWarning = false, // Falso por padrão
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: isWarning ? Colors.red[100] : Colors.white, // Cor condicional
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWarning) // Mostrar aviso se necessário
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Atenção: Ação pendente!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (isWarning) SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: isWarning ? Colors.red[900] : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isWarning ? Colors.red[800] : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onPressed,
                child: Text(
                  actionLink,
                  style: TextStyle(
                    color: isWarning ? Colors.red : Colors.blue,
                    fontWeight: FontWeight.w500,
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