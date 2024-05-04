import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechSampleApp extends StatefulWidget {
  const SpeechSampleApp({Key? key}) : super(key: key);

  @override
  State<SpeechSampleApp> createState() => _SpeechSampleAppState();
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class _SpeechSampleAppState extends State<SpeechSampleApp> {
  bool _logEvents = false;
  bool _btn_start = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    initSpeechState();
    super.initState();
  }

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.
  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();
        var item = LocaleName('ar_EG','arabic');
         var systemLocale = await speech.systemLocale();

       if(GetPlatform.isAndroid)
         _currentLocaleId =  'ar_SA';
       else
       _currentLocaleId =  'ar-SA';
       _switchLang(_currentLocaleId);
      //  _currentLocaleId = systemLocale?.localeId  ?? 'ar_EG';
      }
      if (!mounted) return;

      setState(() {});
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          Column(
            children: <Widget>[
              SessionOptionsWidget(
                _currentLocaleId,
                _switchLang,
                _localeNames
              ),
            ],
          ),
          Expanded(
            flex: 4,
            child: RecognitionResultsWidget(lastWords: lastWords, level: level, startListening: startListening,btn_start: speech,),
          ),
          
          SpeechStatusWidget(speech: speech),
        ]),
      ),
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _btn_start = true;
    _logEvent('start listening');
    lastWords = '';
    // Note that `listenFor` is the maximum, not the minimum, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds:  30),
      pauseFor: Duration(seconds:  3),
      partialResults: true,
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: false,
    );
    setState(() {});
  }

  void stopListening() {
    _btn_start = false ;
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }
  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(_currentLocaleId);
    debugPrint(selectedVal);
  }
  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {});
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }


  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }


}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.startListening,
    required this.level,
    required this.btn_start,
  }) : super(key: key);

  final String lastWords;
  final Function startListening;
  final double level;
  final SpeechToText  btn_start ;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: Center(
                  child: Text(
                    lastWords,style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon:  Icon(btn_start.isListening ? Icons.mic : Icons.mic_off_outlined ),
                      onPressed: ()=>startListening(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}







class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(
      this.currentLocaleId,
      this.switchLang,
      this.localeNames,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final List<LocaleName> localeNames;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
               Text('Language: '),
              DropdownButton<String>(
                elevation: 25,
                value: currentLocaleId,
                onChanged: (val) => switchLang(val),
                items: localeNames.map((localeName)=> DropdownMenuItem(
                  value: localeName.localeId,
                  child: Text(localeName.name),
                )
                ).toList(),
              ),
            ],
          ),

        ],
      ),
    );
  }
}



/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: speech.isListening
            ? const Text(
          "I'm listening...",
          style: TextStyle(fontWeight: FontWeight.bold),
        )
            : const Text(
          'Not listening',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}























