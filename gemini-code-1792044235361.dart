import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioResultSection extends StatefulWidget {
  final String audioUrl; // URL เสียงจาก Backend
  final String resultText; // ตัวอักษรข้อความสรุป

  const AudioResultSection({Key? key, required this.audioUrl, required this.resultText}) : super(key: key);

  @override
  _AudioResultSectionState createState() => _AudioResultSectionState();
}

class _AudioResultSectionState extends State<AudioResultSection> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayer.setUrl(widget.audioUrl);
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ปุ่มเล่น / หยุดเสียง
        Semantics(
          label: isPlaying ? "หยุดเล่นเสียงผลการตรวจสอบ" : "ฟังรายละเอียดผลการตรวจสอบ",
          button: true,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60), // ปุ่มขนาดใหญ่สำหรับผู้มีสายตาเลือนราง
              backgroundColor: isPlaying ? Colors.orange[800] : Colors.blue[900],
            ),
            onPressed: () {
              if (isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.play();
              }
            },
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white),
            label: Text(
              isPlaying ? "หยุดเสียง" : "ฟังรายละเอียด",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ปุ่มฟังซ้ำ
        Semantics(
          label: "ฟังซ้ำตั้งแต่ต้น",
          button: true,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(width: 2, color: Colors.black87),
            ),
            onPressed: () async {
              await _audioPlayer.seek(Duration.zero);
              _audioPlayer.play();
            },
            icon: const Icon(Icons.replay, size: 28, color: Colors.black87),
            label: const Text("ฟังซ้ำ", style: TextStyle(fontSize: 20, color: Colors.black87)),
          ),
        ),
      ],
    );
  }
}