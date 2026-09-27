import 'dart:io';
import 'dart:typed_data';

void main() {
  const tracks = [
    'rain.mp3',
    'ocean.mp3',
    'forest.mp3',
    'whitenoise.mp3',
    'lofi.mp3',
    'campfire.mp3',
  ];

  // A standard MPEG-1 Audio Layer III silent frame (128 kbps, 44100 Hz, stereo).
  // Frame size = 417 bytes.
  const frameLength = 417;
  final frame = Uint8List(frameLength);

  // Sync and header: MPEG-1, Layer 3, no CRC, 128 kbps, 44.1 kHz, Joint Stereo
  frame[0] = 0xFF;
  frame[1] = 0xFB;
  frame[2] = 0x90;
  frame[3] = 0x64;

  // 120 frames gives ~3.1 seconds of valid playable audio loop (approx 50 KB)
  const numFrames = 120;
  final totalBytes = BytesBuilder();
  for (var i = 0; i < numFrames; i++) {
    totalBytes.add(frame);
  }
  final mp3Data = totalBytes.toBytes();

  Directory('assets/audio').createSync(recursive: true);

  for (final track in tracks) {
    final file = File('assets/audio/$track');
    file.writeAsBytesSync(mp3Data);
    // ignore: avoid_print
    print('Generated assets/audio/$track (${file.lengthSync()} bytes)');
  }

  // ignore: avoid_print
  print('Successfully generated all 6 ambient audio tracks!');
}
