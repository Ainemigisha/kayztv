class Movie {
  String title;
  String video;
  String thumbnail;  
  String program; 
  int views;
  DateTime uploadDate;

  Movie(
      {this.title, 
      this.video,
      this.thumbnail,
      this.program,
      this.uploadDate});

  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(
      title: map['title'],
      video: map['video'],
      thumbnail: map['thumbnail'],
      program: map['program']['name'].toString(),
      uploadDate: DateTime.parse(map['updated_at'])
    );
  }

  String get getThumbnail {
    return thumbnail;
  }

  String get getVideo {
    return video;
  }

  String get getTitle {
    return title;
  }

  String get getProgram {
    return program;
  }

  DateTime get getUploadDate {
    return uploadDate;
  }
  
}
