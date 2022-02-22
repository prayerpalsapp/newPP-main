class SearchArrayMaker {
  static List<String> setSearchParam(String inString) {
    List<String> paramList = [];
    String temp = "";
    for (int i = 0; i < inString.length; i++) {
      temp = temp + inString[i];
      temp = temp.toLowerCase();
      paramList.add(temp);
    }
    return paramList;
  }
}
