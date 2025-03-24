import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(home: _QuoteList()));

class _QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<_QuoteList> {
  List<Quote> quotes = [
    Quote(author: 'Oscar Wilde', text: 'Be yourself; everyone else is already taken'),
    Quote(author: 'Oscar Wilde', text: 'I have nothing to declare except my genius'),
    Quote(author: 'Oscar Wilde', text: 'The truth is rarely pure and never simple')
  ];

  void _showQuoteDialog({Quote? quote, required Function(String, String) onSubmit}) {
    TextEditingController textController = TextEditingController(text: quote?.text ?? '');
    TextEditingController authorController = TextEditingController(text: quote?.author ?? '');

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(quote == null ? 'New Quote' : 'Update Quote'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: 'Quote'),
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Author'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.trim().isEmpty || authorController.text.trim().isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Quote and Author cannot be empty.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  onSubmit(textController.text, authorController.text);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }

  void _showDeleteConfirmation(Quote quote) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Quote'),
          content: Text('Are you sure you want to delete this quote?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  quotes.remove(quote);
                });
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((quote) {
          return QuoteCard(
            quote: quote,
            delete: () => _showDeleteConfirmation(quote),
            update: () {
              _showQuoteDialog(
                quote: quote,
                onSubmit: (text, author) {
                  setState(() {
                    quote.text = text;
                    quote.author = author;
                  });
                },
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuoteDialog(
            onSubmit: (text, author) {
              setState(() {
                quotes.add(Quote(text: text, author: author));
              });
            },
          );
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}