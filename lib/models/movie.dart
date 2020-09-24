class Movie {
  int videoId;
  String title;
  String video;
  String thumbnail;  
  String program; 
  int views;
  DateTime uploadDate;

  Movie(
      {this.videoId,
      this.title, 
      this.video,
      this.thumbnail,
      this.program,
      this.uploadDate});

  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(
      videoId: map['id'],
      title: map['title'],
      video: map['video'],
      thumbnail: map['thumbnail'],
      program: map['program']['name'].toString(),
      uploadDate: DateTime.parse(map['updated_at'])
    );
  }
  int get getVideoId{
    return videoId;
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
