class Abeshinzo {
  final String nameOfHouse;
  final String nameOfMeeting;
  final String date;
  final String speaker;
  final String speakerYomi;
  final String speech;
  final String speechUrl;
  final String meetingUrl;

  Abeshinzo({
    required this.nameOfHouse,
    required this.nameOfMeeting,
    required this.date,
    required this.speaker,
    required this.speakerYomi,
    required this.speech,
    required this.speechUrl,
    required this.meetingUrl,
  });

  factory Abeshinzo.fromJson(Map<String, dynamic> json) {
    return Abeshinzo(
        nameOfHouse: json['NameOfHouse'],
        nameOfMeeting: json['NameOfMeeting'],
        date: json['Date'],
        speaker: json['Speaker'],
        speakerYomi: json['SpeakerYomi'],
        speech: json['Speech'],
        speechUrl: json['SpeechUrl'],
        meetingUrl: json['MeetingUrl'],
    );
  }
}
