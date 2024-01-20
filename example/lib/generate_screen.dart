import 'package:example/env.dart';
import 'package:example/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cohere/flutter_cohere.dart';


class GenerateScreen extends StatefulWidget {

  const GenerateScreen({Key? key}) : super(key: key);

  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [];

  var co = CohereClient(apiKey: cohereApiKey);

  void _sendMessage() {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text: text));
      _controller.clear();
    });

    co.generate(
      prompt: text, 
      model: "command-light-nightly"
      ).then((value) {
        setState(() {
          var text = value['generations'][0]['text'];
          messages.add(Message(text: text, isSentByMe: false));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Generate Screen')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Align(
                  alignment: messages[index].isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: messages[index].isSentByMe ? Colors.blue : Colors.grey,
                    child: Text(messages[index].text, style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Enter your message'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
}
