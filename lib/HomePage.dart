import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_chatgpt/featureBox.dart';
import 'package:voice_assistant_chatgpt/openAIService.dart';

//AI CHAT BOT
// LOGIN using phone number
// store data
//Provider
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  String lastWords = '';
  final openAIService openAPI = openAIService();
  String? generatedContent;
  String? generatedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechtoText();
    initTexttoSpeech();
  }

  Future<void> initSpeechtoText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initTexttoSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade500,
          title: BounceInDown(child: Text('Ms GPT')),
          leading: const Icon(Icons.menu),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  backgroundImage:
                      AssetImage('assets/images/virtualAssistant.png'),
                  radius: 65,
                ),
              ),
              FadeInRight(
                child: Visibility(
                  visible: generatedImage == null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40)
                        .copyWith(top: 30, bottom: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade300,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0)
                            .copyWith(topLeft: Radius.zero)),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you? '
                          : generatedContent!,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: generatedContent == null ? 25 : 16,
                      ),
                    ),
                  ),
                ),
              ),
              if (generatedImage != null)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(generatedImage!)),
                ),
              SlideInLeft(
                child: Visibility(
                  visible: generatedContent == null && generatedImage == null,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Here are few commands: ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              //Functionalities
              Visibility(
                visible: generatedContent == null && generatedImage == null,
                child: Column(
                  children: [
                    FeatureBox(
                        color: Colors.blue.shade200,
                        title: 'ChatGPT',
                        description:
                            'A smarter way to stay organized and informed with ChatGPT'),
                    FeatureBox(
                        color: Colors.cyanAccent.shade100,
                        title: 'Dall-E',
                        description:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                    FeatureBox(
                        color: Colors.deepPurple.shade100,
                        title: 'Smart Voice Assistant',
                        description:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade200,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              startListening();
            } else if (speechToText.isListening) {
              print(lastWords);
              final speech = await openAPI.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImage = speech;
                generatedContent = null;
              } else {
                generatedImage = null;
                generatedContent = speech;
              }
              await systemSpeak(speech);
              print(speech);
              stopListening();
            } else
              initSpeechtoText();
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
