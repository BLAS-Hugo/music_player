
class Music {
  String title;
  String artist;
  Uri imageUrl;
  Uri musicUrl;

  Music(String title, String artist, String imageUrl, String musicUrl) {
    this.title = title;
    this.artist = artist;
    this.imageUrl = Uri.parse(imageUrl);
    this.musicUrl = Uri.parse(musicUrl);
  }


  }