class ImageUtils{
   static String getImageExtension(String path) {
    List<String> splitDetails = path.split(".");
    if (splitDetails.isNotEmpty) {
      return splitDetails.last;
    }
    return "jpg";
  }
}