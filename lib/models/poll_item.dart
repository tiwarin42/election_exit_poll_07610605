class PollItem {
  final int number;
  final String displayName;
  final int score;

  PollItem({
    required this.number,
    required this.displayName,
    required this.score,
  });

  factory PollItem.fromJson(Map<String, dynamic> json) {
    return PollItem(
      number: json['number'],
      displayName: json['displayName'],
      score: json['score'],
    );
  }

  PollItem.fromJson2(Map<String, dynamic> json)
      : number=json['number'],
        displayName= json['displayName'],
        score= json['score'];

  @override
  String toString() {
    return '$number,$displayName';
  }
}